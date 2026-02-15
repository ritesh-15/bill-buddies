//
//  SDMemberEntity.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation
import SwiftData

@Model
final class SDMemberEntity: SDModelProtocol {
    @Attribute(.unique)
    var id: Int
    @Attribute(.unique)
    var documentId: String
    
    var isDeleted: Bool
    var isSynced: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    var username: String

    @Relationship(inverse: \SDGroupEntity.members)
    var groups: [SDGroupEntity] = []

    init(id: Int, documentId: String, isDeleted: Bool, isSynced: Bool, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil, username: String) {
        self.id = id
        self.documentId = documentId
        self.isDeleted = isDeleted
        self.isSynced = isSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.username = username
        self.groups = []
    }
}
