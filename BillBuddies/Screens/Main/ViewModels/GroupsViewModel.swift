import Foundation
import Combine

final class GroupsViewModel: ObservableObject {

    // MARK: - Observable object

    @Published var showCreateGroup: Bool = false
    @Published var groups: [GroupsModel] = []

    // MARK: - Private properties

    private var authManager: AuthManager?

    private let toastManager = DependencyContainer.shared.toastManager
    private let fetchGroupsUseCase = FetchGroupsUseCase(groupsRepository: DependencyContainer.shared.groupsRepository)

    // MARK: - Public methods

    func configure(authManager: AuthManager) {
        self.authManager = authManager
    }

    func fetchGroups() {
        Task {
            guard let me = authManager?.me() else {
                return
            }

            let result = await fetchGroupsUseCase.execute(userId: me.id)

            switch result {
            case .success(let data):
                print("[DEBUG] \(data)")
                self.groups = data
            case .failure(let error):
                print("[ERROR] \(error)")
                toastManager.show(message: error.errorDescription ?? "Something went wrong please try again later!", style: .error)
            }
        }
    }
}
