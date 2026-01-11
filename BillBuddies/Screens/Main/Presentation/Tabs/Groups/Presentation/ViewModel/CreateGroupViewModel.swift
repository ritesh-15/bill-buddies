import Foundation
import Combine

class CreateGroupViewModel: ObservableObject {

    private let toastManager = DependencyContainer.shared.toastManager
    private let createGroupUseCase = CreateGroupUseCase(groupsRepository: DependencyContainer.shared.groupsRepository)
    private let fetchMembersUseCase = FetchMembersUseCase(membersRepository: DependencyContainer.shared.membersRepository)

    private var authManager: AuthManager?
    private var router: NavigationRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var groupName: String = ""
    @Published var groupNameError: String = ""

    @Published var memberSearchText: String = ""
    @Published var shouldShowAddMembersScreen: Bool = false

    @Published var members: [MembersModel] = []

    @Published var selectedMembers: [MembersModel] = []

    init() {
        $memberSearchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Wait 0.5s
            .removeDuplicates()
            .sink { [weak self] query in
                self?.fetchMembers(query: query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public methods

    func configure(authManager: AuthManager, router: NavigationRouter) {
        self.authManager = authManager
        self.router = router
    }

    func toggleMemember(member: MembersModel) {
        if isMemberSelected(member: member) {
            selectedMembers.removeAll { it in
                it.id == member.id
            }
            return
        }

        selectedMembers.append(member)
    }

    func isMemberSelected(member: MembersModel) -> Bool {
        return selectedMembers.contains(where: { it in
            it.id == member.id
        })
    }

    func fetchMembers(query: String = "") {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            let result = await fetchMembersUseCase.execute(query: query, userId: me.id)

            switch result {
            case .success(let data):
                members = data
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Something weng wrong please try again later!")
            }
        }
    }

    func createGroup() {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            if groupName.isEmpty {
                groupNameError = "Please provide a name for your group"
                return
            } else {
                groupNameError = ""
            }

            let result = await createGroupUseCase.execute(
                group: CreateGroupModel(
                    data: .init(
                        name: groupName,
                        creator: me.id,
                        members: selectedMembers.map({ member in
                            member.documentId
                        }))
                )
            )

            switch result {
            case .success( _):
                toastManager.show(message: "Group created succesfully!", style: .success)
                router?.dismissFullScreen()
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Something weng wrong please try again later!", style: .error)
            }
        }
    }
}
