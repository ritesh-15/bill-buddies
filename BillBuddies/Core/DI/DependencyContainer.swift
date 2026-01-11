import Foundation

final class DependencyContainer {

    static let shared: DependencyContainer = DependencyContainer()

    private init() {}

    // MARK: - Repositories

    lazy var networkService: NetworkServiceProtocol = {
        NetworkService()
    }()

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(networkService: networkService)
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
