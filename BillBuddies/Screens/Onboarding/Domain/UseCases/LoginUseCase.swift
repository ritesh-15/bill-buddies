import Foundation

final class LoginUseCase {

    private let authRespository: AuthRepositoryProtocol
    private let storage: KeychainStorageProtocol

    init (authRepository: AuthRepositoryProtocol, storage: KeychainStorageProtocol) {
        self.authRespository = authRepository
        self.storage = storage
    }

    func execute(data: SignInModel) async -> Result<AuthResult, NetworkError> {
        let result = await authRespository.login(data: data)
        return result
    }
}

