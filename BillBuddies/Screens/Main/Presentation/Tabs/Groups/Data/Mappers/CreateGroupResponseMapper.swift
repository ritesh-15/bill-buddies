//
//  CreateGroupResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

struct CreateGroupResponseMapper: ResponseMapperProtocol {

    static func toDomain(_ dto: DTOCreateGroupResponse) -> CreateGroupResponseModel {
        return CreateGroupResponseModel(
            id: dto.data.id,
            documentId: dto.data.documentId,
            name: dto.data.name,
            description: dto.data.description ?? "",
            category: GroupCategory(rawValue: dto.data.category ?? "") ?? .other
        )
    }
}
