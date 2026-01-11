import Foundation

protocol GroupsRepositoryProtocol: AnyObject {

    func fetchGroups(userId: String) async -> Result<[GroupsModel], NetworkError>
}

final class GroupsRepository: GroupsRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchGroups(userId: String) async -> Result<[GroupsModel], NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .get)
                .setPath(path: "/groups")
                .addHeader(key: "Content-Type", value: "application/json")
                .addQuery("populate[creator][fields][0]", value: "id")
                .addQuery("populate[creator][fields][1]", value: "documentId")
                .addQuery("populate[creator][fields][2]", value: "username")
                .addQuery("populate[members][fields][0]", value: "id")
                .addQuery("populate[members][fields][1]", value: "documentId")
                .addQuery("populate[members][fields][2]", value: "username")
                .addQuery("filters[$or][0][creator][documentId][$eq]", value: userId)
                .addQuery("filters[$or][1][members][documentId][$in]", value: userId)
                .build()

            let result: NetworkResult<DTOGroups> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(GroupsResponseMapper.toDomain(data))
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
