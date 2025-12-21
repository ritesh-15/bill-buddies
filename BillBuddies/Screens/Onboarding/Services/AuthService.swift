import Foundation

protocol AuthServiceProtocol: AnyObject {

    func register(data: RegistrationModel) async throws
}

final class AuthService: AuthServiceProtocol {

    let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func register(data: RegistrationModel) async throws {
        try await authRepository.register(data: data)
    }
}
