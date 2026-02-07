//
//  SDModelProtocol.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation


public protocol SDModelProtocol {
    var id: Int { get set }
    var documentId: String { get set }
    var isDeleted: Bool { get set }
    var isSynced: Bool { get set }
    var createdAt: Date? { get set }
    var updatedAt: Date? { get set }
    var deletedAt: Date? { get set }
}
