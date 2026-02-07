import Foundation

protocol GroupsRepositoryProtocol: AnyObject {

    func fetchGroups(userId: String, query: String?) async -> Result<[GroupsModel], NetworkError>

    func createGroup(group: CreateGroupModel) async -> Result<CreateGroupResponseModel, NetworkError>

    func fetchGroupDetails(groupId: String) async -> Result<GroupDetailResponseModel, NetworkError>

    func fetchGroupMembers(groupId: String) async -> Result<GroupMembersModel, NetworkError>
}

final class GroupsRepository: GroupsRepositoryProtocol {

    private let networkService: NetworkServiceProtocol
    private let groupsLocalDataSource: GroupsLocalDataStoreProtocol

    init(networkService: NetworkServiceProtocol, groupsLocalDataSource: GroupsLocalDataStoreProtocol) {
        self.networkService = networkService
        self.groupsLocalDataSource = groupsLocalDataSource
    }

    func fetchGroups(userId: String, query: String? = "") async -> Result<[GroupsModel], NetworkError> {
        do {
            // Try local first
            let localEntities = try groupsLocalDataSource.fetchAll()
            if !localEntities.isEmpty {
                let domain = localEntities.map(GroupsEntityMapper.toDomain)

                // Fire remote refresh in background
                Task {
                    await refreshGroupsRemote(query: query)
                }

                return .success(domain)
            }

            return await fetchGroupsRemoteAndCache(query: query)
        }  catch _ {
            return .failure(.unknown)
        }
    }

    private func refreshGroupsRemote(query: String?) async {
        _ = await fetchGroupsRemoteAndCache(query: query)
    }

    // TODO: Create remote data source and move this method in that
    private func fetchGroupsRemoteAndCache(
        query: String?
    ) async -> Result<[GroupsModel], NetworkError> {

        do {
            let searchQuery = query ?? ""

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
                .addQuery("filters[$or][2][id][$eq]=", value: searchQuery)
                .addQuery("filters[$or][3][documentId][$eq]=", value: searchQuery)
                .addQuery("filters[$or][4][name][$containsi]=", value: searchQuery)
                .addQuery("sort[createdAt]", value: "desc")
                .build()

            let result: NetworkResult<DTOGroups> =
                await networkService.request(request)

            switch result {

            case .success(let data):

                let entities = GroupsResponseMapper.toEntity(data)
                try groupsLocalDataSource.saveAll(entities)

                return .success(GroupsResponseMapper.toDomain(data))

            case .failure(let error):
                return .failure(error)
            }

        } catch {
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

    func fetchGroupMembers(groupId: String) async -> Result<GroupMembersModel, NetworkError> {
        do {
            let request = try NetworkRequestBuilder()
                .method(method: .get)
                .setPath(path: "/groups/\(groupId)")
                .addHeader(key: "Content-Type", value: "application/json")
                .addQuery("populate[members][fields][0]", value: "id")
                .addQuery("populate[members][fields][1]", value: "username")
                .addQuery("fields[0]", value: "name")
                .addQuery("fields[1]", value: "id")
                .build()

            let result: NetworkResult<GroupMembersDto> = await networkService.request(request)

            switch result {
            case .success(let data):
                return .success(GroupMembersResponseMapper.toDomain(data))
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
