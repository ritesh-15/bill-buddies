//
//  LocalDataStore.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 07/02/26.
//

import Foundation
import SwiftData

protocol GroupsLocalDataStoreProtocol {
    func fetchAll() throws -> [SDGroupEntity]
    func save(_ entity: SDGroupEntity) throws
    func saveAll(_ entities: [SDGroupEntity]) throws
    func unsynced() throws -> [SDGroupEntity]
}


final class GroupsLocalDataStore: GroupsLocalDataStoreProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [SDGroupEntity] {
        try context.fetch(
                FetchDescriptor<SDGroupEntity>(
                    sortBy: [SortDescriptor(\.createdAt, order: .reverse)],
                )
            )
    }
    
    func save(_ entity: SDGroupEntity) throws {

    }
    
    func saveAll(_ entities: [SDGroupEntity]) throws {
        entities.forEach(context.insert)
        try context.save()
    }
    
    func unsynced() throws -> [SDGroupEntity] {
        return []
    }
}
