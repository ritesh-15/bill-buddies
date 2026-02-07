import Foundation
import SwiftData

final class DependencyContainer {

    static let shared: DependencyContainer = DependencyContainer()

    private var container: ModelContainer?

    private init() {
    }

    func configure(container: ModelContainer) {
        self.container = container
    }

    // MARK: - Repositories

    lazy var networkService: NetworkServiceProtocol = {
        NetworkService()
    }()

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(networkService: networkService)
    }()

    lazy var groupsRepository: GroupsRepositoryProtocol = {
        // Avoid force unwrap, identify better approach here
        GroupsRepository(networkService: networkService, groupsLocalDataSource: GroupsLocalDataStore(context: container!.mainContext))
    }()

    lazy var membersRepository: MembersRepositoryProtocol = {
        MembersRepository(networkService: networkService)
    }()

    lazy var expenseRepository: ExpenseRepositoryProtocol = {
        ExpenseRepository(networkService: networkService)
    }()

    // MARK: - ViewModel

    lazy var singupViewModel: SignupViewModel = {
        SignupViewModel(with: RegisterUserCase(
            authRepository: authRepository,
            storage: keychainStorage
        ))
    }()

    // MARK: - Storage

    lazy var keychainStorage: KeychainStorageProtocol = {
        KeychainStorage()
    }()

    // MARK: - ToastManager

    lazy var toastManager: ToastManager = {
        ToastManager()
    }()
}
