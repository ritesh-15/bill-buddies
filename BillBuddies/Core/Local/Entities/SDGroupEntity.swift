//
//  SDGroupEntity.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation
import SwiftData

@Model
final class SDGroupEntity:  SDModelProtocol {
    var name: String
    var groupDescription: String?
    var category: String
    var simplifyDebts: Bool

    @Relationship(deleteRule: .cascade)
    var expenses: [SDExpenseEntity]  = []

    @Relationship(deleteRule: .cascade)
    var members: [SDMemberEntity]  = []

    @Attribute(.unique)
    var id: Int
    @Attribute(.unique)
    var documentId: String

    var isDeleted: Bool
    var isSynced: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    init(name: String, groupDescription: String? = nil, category: String, simplifyDebts: Bool, id: Int, documentId: String, isDeleted: Bool, isSynced: Bool, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil) {
        self.name = name
        self.groupDescription = groupDescription
        self.category = category
        self.simplifyDebts = simplifyDebts
        self.id = id
        self.documentId = documentId
        self.isDeleted = isDeleted
        self.isSynced = isSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
