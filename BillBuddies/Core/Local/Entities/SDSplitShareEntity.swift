//
//  SDSplitShareEntity.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation
import SwiftData

@Model
final class SDSplitShareEntity: SDModelProtocol {
    @Attribute(.unique)
    var id: Int
    @Attribute(.unique)
    var documentId: String

    var amount: Double
    var percentage: Int
    var share: Int
    var isPaid: Bool

    @Relationship
    var expense: SDExpenseEntity?

    @Relationship
    var ownedBy: SDMemberEntity?

    @Relationship
    var paidTo: SDMemberEntity?

    var isDeleted: Bool
    var isSynced: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    init(id: Int, documentId: String, amount: Double, percentage: Int, share: Int, isPaid: Bool, expense: SDExpenseEntity? = nil, ownedBy: SDMemberEntity? = nil, paidTo: SDMemberEntity? = nil, isDeleted: Bool, isSynced: Bool, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil) {
        self.id = id
        self.documentId = documentId
        self.amount = amount
        self.percentage = percentage
        self.share = share
        self.isPaid = isPaid
        self.expense = expense
        self.ownedBy = ownedBy
        self.paidTo = paidTo
        self.isDeleted = isDeleted
        self.isSynced = isSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
