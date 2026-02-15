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
            // Calculate you owe
            var youOwe: Double? = nil

            if let currentUserId = DependencyContainer.shared.authManager.me()?.id {
                youOwe = model.splitShares.first{ split in
                    split.ownedBy.documentId == currentUserId
                }?.amount
            }

            return RecentExpensesModel(
                id: model.id,
                documentId: model.documentId,
                date: model.date,
                description: model.description,
                amount: model.amount,
                splitShares: toDomain(model.splitShares),
                youOwe: (youOwe != nil) ? Int(youOwe ?? 0) : nil
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
