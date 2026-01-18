//
//  FetchGroupMembersUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation

final class FetchGroupMembersUseCase {

    private let repository: GroupsRepositoryProtocol

    init(repository: GroupsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(groupId: String) async -> Result<GroupMembersModel, NetworkError> {
        let result = await repository.fetchGroupMembers(groupId: groupId)
        return result
    }
}
