import Foundation

final class FetchSelectGroupsUseCase {

    private let groupsRepository: GroupsRepositoryProtocol

    init (groupsRepository: GroupsRepositoryProtocol) {
        self.groupsRepository = groupsRepository
    }

    func execute(userId: String, query: String) async -> Result<[GroupsModel], NetworkError> {
        let result = await groupsRepository.fetchGroups(userId: userId, query: query)
        return result
    }
}
