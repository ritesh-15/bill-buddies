//
//  GroupMembersResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation

final class GroupMembersResponseMapper: ResponseMapperProtocol {

    static func toDomain(_ dto: GroupMembersDto) -> GroupMembersModel {
        return GroupMembersModel(
            id: dto.data.id,
            documentId: dto.data.documentId,
            name: dto.data.name,
            members: dto.data.members.map({ member in
                GroupMembersModel.Member(
                    id: member.id,
                    documentId: member.documentId,
                    username: member.username)
            }))
    }
}
