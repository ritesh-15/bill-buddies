import Foundation

final class FetchGroupDetailsUseCase {

    private let groupsRepository: GroupsRepositoryProtocol

    init (groupsRepository: GroupsRepositoryProtocol) {
        self.groupsRepository = groupsRepository
    }

    func execute(groupId: String) async -> Result<GroupDetailResponseModel, NetworkError> {
        let result = await groupsRepository.fetchGroupDetails(groupId: groupId)
        return result
    }
}
