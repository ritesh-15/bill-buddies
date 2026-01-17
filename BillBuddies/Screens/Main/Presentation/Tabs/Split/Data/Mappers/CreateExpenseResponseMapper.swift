//
//  CreateExpenseResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

final class CreateExpenseResponseMapper: ResponseMapperProtocol {

    static func toDomain(_ dto: DTOCreateExpenseResponse) -> CreateExpenseModel {
        return CreateExpenseModel(id: dto.data.id, documentId: dto.data.documentId)
    }
}
