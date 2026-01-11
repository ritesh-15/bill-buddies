import Foundation

final class FetchGroupsUseCase {

    private let groupsRepository: GroupsRepositoryProtocol

    init (groupsRepository: GroupsRepositoryProtocol) {
        self.groupsRepository = groupsRepository
    }

    func execute(userId: String) async -> Result<[GroupsModel], NetworkError> {
        let result = await groupsRepository.fetchGroups(userId: userId)
        return result
    }
}
