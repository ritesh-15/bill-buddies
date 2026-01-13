import Foundation

protocol GroupsRepositoryProtocol: AnyObject {

    func fetchGroups(userId: String) async -> Result<[GroupsModel], NetworkError>

    func createGroup(group: CreateGroupModel) async -> Result<CreateGroupResponseModel, NetworkError>

    func fetchGroupDetails(groupId: String) async -> Result<GroupDetailResponseModel, NetworkError>
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
                .addQuery("sort[createdAt]", value: "desc")
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

    func fetchGroupDetails(groupId: String) async -> Result<GroupDetailResponseModel, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .get)
                .setPath(path: "/groups/\(groupId)")
                .addHeader(key: "Content-Type", value: "application/json")
                .addQuery("populate[creator][fields][0]", value: "id")
                .addQuery("populate[creator][fields][1]", value: "username")
                .addQuery("populate[members][fields][0]", value: "id")
                .addQuery("populate[members][fields][1]", value: "username")
                .addQuery("populate[expenses][fields][0]", value: "id")
                .addQuery("populate[expenses][fields][1]", value: "description")
                .addQuery("populate[expenses][fields][2]", value: "amount")
                .addQuery("populate[expenses][populate][paidBy][fields][0]", value: "id")
                .addQuery("populate[expenses][populate][splitShares][fields][0]", value: "id")
                .addQuery("populate[expenses][populate][splitShares][populate][ownedBy][fields][0]", value: "id")
                .build()

            let result: NetworkResult<DTOGroupDetailResponse> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(GroupDetailsResponseMapper.toDomain(data))
            case .failure(let networkError):
                return .failure(networkError)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch _ {
            return .failure(.unknown)
        }
    }

    func createGroup(group: CreateGroupModel) async -> Result<CreateGroupResponseModel, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .post)
                .setPath(path: "/groups")
                .addHeader(key: "Content-Type", value: "application/json")
                .setJSONBody(group)
                .build()

            let result: NetworkResult<DTOCreateGroupResponse> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(CreateGroupResponseMapper.toDomain(data))
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
