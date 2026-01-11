//
//  GroupDetailsResponseMapper.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

struct GroupDetailsResponseMapper: ResponseMapperProtocol {

    typealias Input = DTOGroupDetailResponse
    typealias Output = GroupDetailResponseModel

    static func toDomain(_ dto: DTOGroupDetailResponse) -> GroupDetailResponseModel {
        let data = dto.data
        return GroupDetailResponseModel(
            id: data.id,
            documentId: data.documentId,
            name: data.name,
            description: data.description,
            category: data.category,
            simplifyDebts: data.simplifyDebts,
            creator: Self.toDomain(data.creator),
            members: Self.toDomain(data.members),
            expenses: Self.toDomain(data.expenses)
        )
    }

    static private func toDomain(_ dto: DTOGroupDetailResponse.DTOCreator) -> GroupDetailResponseModel.Creator {
        return GroupDetailResponseModel.Creator(
            id: dto.id,
            documentId: dto.documentId,
            username: dto.username
        )
    }

    static private func toDomain(_ dtos: [DTOGroupDetailResponse.DTOCreator]) -> [GroupDetailResponseModel.Creator] {
        return dtos.map { dto in
            GroupDetailResponseModel.Creator(
                id: dto.id,
                documentId: dto.documentId,
                username: dto.username
            )
        }
    }

    static private func toDomain(_ dtos: [DTOGroupDetailResponse.DTOExpense]) -> [GroupDetailResponseModel.Expense] {
        return dtos.map { dto in
            GroupDetailResponseModel.Expense(
                id: dto.id,
                documentId: dto.documentId,
                description: dto.description,
                amount: dto.amount,
                splitShares: Self.toDomain(dto.splitShares),
                paidBy: GroupDetailResponseModel.PaidBy(
                    id: dto.paidBy.id,
                    documentId: dto.paidBy.documentId
                )
            )
        }
    }

    static private func toDomain(_ dtos: [DTOGroupDetailResponse.DTOSplitShare]) -> [GroupDetailResponseModel.SplitShare] {
        return dtos.map { dto in
            GroupDetailResponseModel.SplitShare(
                id: dto.id,
                documentId: dto.documentId,
                ownedBy: GroupDetailResponseModel.OwnedBy(
                    id: dto.ownedBy.id,
                    documentId: dto.ownedBy.documentId
                )
            )
        }
    }
}
