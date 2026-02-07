//
//  ExpenseDetailResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation

final class ExpenseDetailResponseMapper: ResponseMapperProtocol {

    static func toDomain(_ dto: ExpenseDetailsResponseDto) -> ExpenseDetailModel {
        return ExpenseDetailModel(
            id: dto.data.id,
            documentId: dto.data.documentId,
            amount: dto.data.amount,
            createdAt: dto.data.createdAt,
            description: dto.data.description,
            splitShares: dto.data.splitShares.map({ splitShare in
                ExpenseDetailModel.SplitShare(
                    id: splitShare.id,
                    documentId: splitShare.documentId,
                    amount: splitShare.amount,
                    ownedBy: ExpenseDetailModel.OwnedBy(
                        id: splitShare.id,
                        documentId: splitShare.ownedBy.documentId,
                        username: splitShare.ownedBy.username)
                )
            }),
            paidBy: ExpenseDetailModel.PaidBy(
                id: dto.data.paidBy.id,
                documentId: dto.data.paidBy.documentId,
                username: dto.data.paidBy.username)
        )
    }
}
