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

    private let createExpenseUseCase = CreateExpenseUseCase(repository: DependencyContainer.shared.expenseRepository)

    private var authManager: AuthManager?
    private var router: NavigationRouter?
    private var cancellables = Set<AnyCancellable>()
    private var hasSetupSearchObservation = false

    init() {
        // Intentionally left empty. We will start observing search text after dependencies are configured.
    }

    // MARK: - Public methods

    func configure(authManager: AuthManager, router: NavigationRouter) {
        self.authManager = authManager
        self.router = router

        // Set up the debounced search observation only once, after dependencies are injected.
        setupSearchObservationIfNeeded()
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

        switch selectedSplitMethod {
        case .equally:
            recalculateEquallySplitAmount()
        case .amount:
            recalculateCustomSplitAmount()
        case .percent:
            recalculatePercentageSplit()
        case .share:
            recalculateShareSplit()
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
            participient.share = 1
            return participient
        }
        // For the first time select all the participients
        self.selectedParticipantIDs = Set(participients.map(\.id))
        self.participants = participients
    }

    func onChangeSelectMethod(method: SplitMethod) {
        if method == .equally {
            recalculateEquallySplitAmount()
        }
    }

    func createSplit() {
        if selectedGroup == nil {
            toastManager.show(message: "Please select a group to split with!", style: .error)
            return
        }

        guard let me = authManager?.me(),
              let selectedGroup else {
            return
        }

        var splitShares: [SplitShareRequestModel] = []

        // Check current split method type
        switch selectedSplitMethod {
        case .equally:
            splitShares = generateSplitShareModelForEquallyOrAmountSplit(me: me)
        case .amount:
            // Validate that full amount is being entered
            guard validateFullAmountIsEntered() else {
                toastManager.show(message: "The amount for split does not match the selected participants split amount!", style: .error)
                return
            }

            splitShares = generateSplitShareModelForEquallyOrAmountSplit(me: me)
        case .percent:
            // validate the percentage entered has sum equal to 100
            guard validatePercentageSumIs100() else {
                toastManager.show(message: "The percentage for split does not sum up to 100!", style: .error)
                return
            }

            splitShares = generateSplitShareModelForPercentageSplit(me: me)
        case .share:
            splitShares = generateSplitShareModelForShareSplit(me: me)
        }

        // Formate date to YYYY-MM-DD format and then into string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: paymentDate)

        let expense = ExpenseRequestModel(data: .init(
            description: description,
            paidBy: me.id,
            amount: (Double(amount) ?? 0),
            category: "General",
            date: dateString,
            splitShares: splitShares,
            group: selectedGroup.documentId,
            splitMethod: selectedSplitMethod.title))

        Task {
            let result = await createExpenseUseCase.execute(expense: expense)

            switch result {
            case .success(_):
                toastManager.show(message: "Created split succesfully!", style: .success)
                router?.dismissFullScreen()
                // Add slight deply for smooth transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self,
                          let router = self.router,
                          let selectedGroup = self.selectedGroup else {
                        return
                    }
                    router.navigate(to: .groupDetail(id: selectedGroup.documentId))
                }
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Failed to create split, please try again!", style: .error)
            }
        }
    }

    // MARK: - Private methods

    private func setupSearchObservationIfNeeded() {
        guard !hasSetupSearchObservation else { return }
        hasSetupSearchObservation = true

        $groupNameSearchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Wait 0.5s
            .removeDuplicates()
            .sink { [weak self] query in
                if query.isEmpty {
                    return
                }
                self?.fetchSelectGroups(query: query)
            }
            .store(in: &cancellables)
    }

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

    private func recalculateCustomSplitAmount() {
        self.participants = participants.map { member in
            var newMember = member
            let isMemberSelected = selectedParticipantIDs.contains(member.id)
            
            if !isMemberSelected {
                newMember.amount = 0
            }

            return newMember
        }
    }

    private func recalculatePercentageSplit() {
        self.participants = participants.map { member in
            var newMember = member
            let isMemberSelected = selectedParticipantIDs.contains(member.id)

            if !isMemberSelected {
                newMember.percentage = 0
            }

            return newMember
        }
    }

    private func recalculateShareSplit() {
        self.participants = participants.map { member in
            var newMember = member
            let isMemberSelected = selectedParticipantIDs.contains(member.id)

            if !isMemberSelected {
                newMember.share = 0
            }

            return newMember
        }
    }

    // MARK: - Utils

    private func validateFullAmountIsEntered() -> Bool {
        let totalAmount = Double(amount) ?? 0
        let selectedParticipantList = participants.filter { participant in
            selectedParticipantIDs.contains(participant.id) && participant.amount != 0
        }
        let enteredAmounts = selectedParticipantList.map { participant in
            participant.amount
        }
        let totalSelectedAmount: Double = enteredAmounts.reduce(0, +)
        
        if totalSelectedAmount != totalAmount {
            return false
        }

        return true
    }

    private func validatePercentageSumIs100() -> Bool {
        let selectedParticipantList = participants.filter { participant in
            selectedParticipantIDs.contains(participant.id) && participant.percentage != 0
        }
        let enteredPercentages: [Double] = selectedParticipantList.map(\.percentage)
        let totalSelectedPercentage: Double = enteredPercentages.reduce(0, +)
        if totalSelectedPercentage != 100 {
            return false
        }
        return true
    }

    private func generateSplitShareModelForPercentageSplit(me: User) -> [SplitShareRequestModel] {
        let totalAmount = Double(self.amount) ?? 0

        return participants.filter({ participant in
            selectedParticipantIDs.contains(participant.id) && participant.percentage != 0
        }).map({ participant in
            SplitShareRequestModel(
                amount: totalAmount * (participant.percentage / 100),
                percentage: participant.percentage,
                share: 0,
                ownedBy: participant.id,
                paidTo: me.id)
        })
    }

    private func generateSplitShareModelForShareSplit(me: User) -> [SplitShareRequestModel] {
        let totalAmount = Double(self.amount) ?? 0

        // Get filtered participants
        let filteredParticipants = participants.filter { participant in
            selectedParticipantIDs.contains(participant.id) && participant.share != 0
        }

        // Calculate total shares
        let totalShares = filteredParticipants.reduce(0) { $0 + $1.share }

        // Prevent division by zero
        guard totalShares > 0 else { return [] }

        return filteredParticipants.map { participant in
            let share = Double(participant.share)
            let shareAmount = (totalAmount * share) / Double(totalShares)

            return SplitShareRequestModel(
                amount: shareAmount,
                percentage: (share / Double(totalShares)) * 100, // Calculate actual percentage
                share: participant.share,
                ownedBy: participant.id,
                paidTo: me.id
            )
        }
    }

    private func generateSplitShareModelForEquallyOrAmountSplit(me: User) -> [SplitShareRequestModel] {
        return participants.filter({ participant in
            selectedParticipantIDs.contains(participant.id) && participant.amount != 0
        }).map({ participant in
            SplitShareRequestModel(
                amount: participant.amount,
                percentage: 0,
                share: 0,
                ownedBy: participant.id,
                paidTo: me.id)
        })
    }
}
