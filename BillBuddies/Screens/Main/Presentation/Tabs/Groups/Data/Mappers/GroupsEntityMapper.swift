//
//  GroupsEntityMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation

final class  MemberEntityMapper {

    static func toDomain(_ entity: SDMemberEntity) -> MemberModel {
        MemberModel(id: entity.id, documentId: entity.documentId, username: entity.username)
    }
}

final class GroupsEntityMapper {

    static func toDomain(_ entity: SDGroupEntity) -> GroupsModel {
        return GroupsModel(
            id: entity.id,
            documentId: entity.documentId,
            name: entity.name,
            description: entity.groupDescription,
            category: GroupCategory(rawValue: entity.category) ?? .other,
            simplifyDebts: entity.simplifyDebts,
            createdAt: "2025-01-12",
            creator:  .init(id: 12, documentId: "temp-id", username: "temp"),
            members: entity.members.map(MemberEntityMapper.toDomain))
    }
}
