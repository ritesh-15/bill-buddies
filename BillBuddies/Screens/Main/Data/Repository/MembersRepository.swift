import Foundation

protocol MembersRepositoryProtocol: AnyObject {

    func fetchMembers(query: String?, userId: String) async -> Result<[MembersModel], NetworkError>
}

final class MembersRepository: MembersRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchMembers(query: String?, userId: String) async -> Result<[MembersModel], NetworkError> {
        do {
            let searchQuery = query ?? ""

            let request = try NetworkRequestBuilder()
                .method(method: .get)
                .setPath(path: "/users")
                .addHeader(key: "Content-Type", value: "application/json")
                .addQuery("filters[$or][0][id][$eq]=", value: searchQuery)
                .addQuery("filters[$or][1][documentId][$eq]=", value: searchQuery)
                .addQuery("filters[$or][2][username][$containsi]=", value: searchQuery)
                .addQuery("filters[$and][0][id][$ne]=", value: userId)
                .build()

            let result: NetworkResult<[DTOMembersResponseElement]> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(MembersResponseMapper.toDomain(data))
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
