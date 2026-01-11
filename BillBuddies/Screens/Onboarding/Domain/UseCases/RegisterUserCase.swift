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

            if let encodedData = User.encodeToJSON(user: data.user) {
                storage.save(with: KeychainStorage.me, data: encodedData)
            }
        }

        return result
    }
}
