import Foundation

final class DependencyContainer {

    static let shared: DependencyContainer = DependencyContainer()

    private init() {}

    // MARK: - Repositories

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository()
    }()

    // MARK: - Services

    lazy var authService: AuthServiceProtocol = {
        AuthService(authRepository: authRepository)
    }()

    // MARK: - ViewModel

    lazy var singupViewModel: SignupViewModel = {
        SignupViewModel(with: authService)
    }()
}
