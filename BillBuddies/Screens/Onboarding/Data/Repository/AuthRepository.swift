import Foundation

protocol AuthRepositoryProtocol: AnyObject {

    func register(data: RegistrationModel) async -> Result<AuthResult, NetworkError>

    func login(data: SignInModel) async -> Result<AuthResult, NetworkError>
}

final class AuthRepository: AuthRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func register(data: RegistrationModel) async -> Result<AuthResult, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .post)
                .setPath(path: "/auth/local/register")
                .addHeader(key: "Content-Type", value: "application/json")
                .setJSONBody(data)
                .build()

            let result: NetworkResult<AuthResponseDTO> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(AuthResponseMapper.toDomain(data))
            case .failure(let networkError):
                return .failure(networkError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch _ {
            return .failure(.unknown)
        }
    }

    func login(data: SignInModel) async -> Result<AuthResult, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .post)
                .setPath(path: "/auth/local")
                .addHeader(key: "Content-Type", value: "application/json")
                .setJSONBody(data)
                .build()

            let result: NetworkResult<AuthResponseDTO> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(AuthResponseMapper.toDomain(data))
            case .failure(let networkError):
                return .failure(networkError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch _ {
            return .failure(.unknown)
        }
    }
}
