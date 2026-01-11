//
//  CreateGroupUseCase.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

final class CreateGroupUseCase {

    private let groupsRepository: GroupsRepositoryProtocol

    init (groupsRepository: GroupsRepositoryProtocol) {
        self.groupsRepository = groupsRepository
    }

    func execute(group: CreateGroupModel) async -> Result<CreateGroupResponseModel, NetworkError> {
        let result = await groupsRepository.createGroup(group: group)
        return result
    }
}
