//
//  MembersResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

struct MembersResponseMapper: ResponseMapperProtocol {

    static func toDomain(_ dto: [DTOMembersResponseElement]) -> [MembersModel] {
        return dto.map { model in
            MembersModel(id: model.id, username: model.username, documentId: model.documentId)
        }
    }
}
