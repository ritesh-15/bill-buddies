import Foundation

final class RegisterUserCase {

    private let authRespository: AuthRepositoryProtocol
    private let storage: KeychainStorageProtocol

    init (authRepository: AuthRepositoryProtocol, storage: KeychainStorageProtocol) {
        self.authRespository = authRepository
        self.storage = storage
    }

    func execute(data: RegistrationModel) async -> Result<AuthResult, NetworkError> {
        let result = await authRespository.register(data: data)

        if case .success(let data) = result {
            // Save tokens
            storage.save(with: KeychainStorage.accessToken, data: data.token)
            storage.save(with: KeychainStorage.refreshToken, data: data.refreshToken)

            // Save user as JSON Data
            let encoder = JSONEncoder()
            if let userData = try? encoder.encode(data.user) {
                storage.save(with: KeychainStorage.me, data: userData)
            }
        }

        return result
    }
}
