import Foundation
import Combine
import SwiftUI

class CreateSplitViewModel: ObservableObject {

    @Published var currentStep = 0

    @Published var amount: String = ""
    @Published var description: String = ""
    @Published var paymentDate: Date = Date()

    // Choose group
    @Published var showChooseGroupScreen = false
    @Published var groupNameSearchText: String = ""

    @Published var selectedGroup: GroupsModel?

    // New: Track the selected split method
    @Published var selectedSplitMethod: SplitMethod = .equally

    // Participants for splitting
    @Published var participants: [Participant] = []
    @Published var selectedParticipantIDs: Set<String> = []

    @Published var searchGroups: [GroupsModel] = []

    lazy var steps: [AnyView] = [
        AnyView(CreateSplit(viewModel: self)),
        AnyView(ChooseGroupAndShare(viewModel: self))
    ]

    // MARK: - Properties

    private let toastManager = DependencyContainer.shared.toastManager
    private let fetchSelectGroupsUseCase = FetchSelectGroupsUseCase(groupsRepository: DependencyContainer.shared.groupsRepository)

    private var authManager: AuthManager?
    private var cancellables = Set<AnyCancellable>()

    init() {
        $groupNameSearchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Wait 0.5s
            .removeDuplicates()
            .sink { [weak self] query in
                self?.fetchSelectGroups(query: query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods

    func configure(authManager: AuthManager) {
        self.authManager = authManager
    }

    func toggleParticipantSelection(participant: Participant) {
        // At least one member should be selected at any point of time
        if selectedParticipantIDs.count == 1, selectedParticipantIDs.contains(participant.id) {
            toastManager.show(message: "At least one member should be selected!", style: .warning)
            return
        }

        if selectedParticipantIDs.contains(participant.id) {
            selectedParticipantIDs.remove(participant.id)
        } else {
            selectedParticipantIDs.insert(participant.id)
        }

        // Re-calculate the equal split amount once the participent is toggled
        if selectedSplitMethod == .equally {
            recalculateEquallySplitAmount()
        }
    }

    func nextStep() {
        if amount.isEmpty {
            toastManager.show(message: "Please enter a valid amount!", style: .error)
            return
        }

        if currentStep >= steps.count - 1 {
            return
        }

        currentStep += 1
    }

    func previousStep() {
        if currentStep == 0 {
            return
        }

        currentStep -= 1
    }

    func currentComponent() -> AnyView {
        return steps[currentStep]
    }

    func fetchSelectGroups(query: String = "") {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            let result = await fetchSelectGroupsUseCase.execute(userId: me.id, query: query)

            switch result {
            case .success(let data):
                self.searchGroups = data
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Failed to fetch groups, please try again!", style: .error)
            }
        }
    }

    func selectGroup(group: GroupsModel) {
        self.selectedGroup = group

        // Calculate equally split amount
        let equalSplit = (Double(amount) ?? 0) / Double(group.members.count)

        // Convert members to participients
        let participients = group.members.map { member in
            var participient = Participant(id: member.documentId, name: member.username)
            participient.amount = equalSplit
            return participient
        }
        // For the first time select all the participients
        self.selectedParticipantIDs = Set(participients.map(\.id))
        self.participants = participients
    }

    // MARK: - Private methods

    private func recalculateEquallySplitAmount() {
        // Calculate equally split amount
        let equalSplit = (Double(amount) ?? 0) / Double(selectedParticipantIDs.count)

        self.participants = participants.map { member in
            var newMember = member
            let isMemberSelected = selectedParticipantIDs.contains(member.id)

            if !isMemberSelected {
                newMember.amount = 0
            } else {
                newMember.amount = equalSplit
            }

            return newMember
        }
    }
}
