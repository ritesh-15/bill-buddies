//
//  SDExpenseEntity.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation
import SwiftData

@Model
final class SDExpenseEntity: SDModelProtocol {
    @Attribute(.unique)
    var id: Int
    @Attribute(.unique)
    var documentId: String

    var amount: Double
    var expenseDescription: String?
    var splitMethod: String
    var isSettled: Bool = false

    @Relationship
    var paidBy: SDMemberEntity?

    @Relationship
    var group: SDGroupEntity?

    @Relationship
    var splitShares: SDSplitShareEntity?

    var isDeleted: Bool
    var isSynced: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    init(id: Int, documentId: String, amount: Double, description: String? = nil, splitMethod: String, isSettled: Bool, paidBy: SDMemberEntity? = nil, group: SDGroupEntity? = nil, splitShares: SDSplitShareEntity? = nil, isDeleted: Bool, isSynced: Bool, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil) {
        self.id = id
        self.documentId = documentId
        self.amount = amount
        self.expenseDescription = description
        self.splitMethod = splitMethod
        self.isSettled = isSettled
        self.paidBy = paidBy
        self.group = group
        self.splitShares = splitShares
        self.isDeleted = isDeleted
        self.isSynced = isSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
