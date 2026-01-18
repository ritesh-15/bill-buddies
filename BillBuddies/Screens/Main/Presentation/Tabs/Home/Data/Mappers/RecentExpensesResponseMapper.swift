//
//  RecentExpensesResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation

final class RecentExpensesResponseMapper: ResponseMapperProtocol {

    typealias Input = RecentExpensesDto
    typealias Output = [RecentExpensesModel]

    static func toDomain(_ dto: RecentExpensesDto) -> [RecentExpensesModel] {
        return dto.data.map { model in
            RecentExpensesModel(
                id: model.id,
                documentId: model.documentId,
                date: model.date,
                description: model.description,
                amount: model.amount,
                splitShares: toDomain(model.splitShares)
            )
        }
    }

    static private func toDomain(_ splitShares: [RecentExpensesDto.SplitShare]) -> [RecentExpensesModel.SplitShare] {
        return splitShares.map { share in
            RecentExpensesModel.SplitShare(
                id: share.id,
                documentId: share.documentId,
                ownedBy: RecentExpensesModel.OwnedBy(
                    id: share.ownedBy.id,
                    documentId: share.ownedBy.documentId)
            )
        }
    }
}
