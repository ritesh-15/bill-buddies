//
//  GroupMembersModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 18/01/26.
//

import Foundation

struct GroupMembersModel: Codable {
    let id: Int
    let documentId, name: String
    let members: [Member]

    struct Member: Codable, Identifiable {
        let id: Int
        let documentId, username: String
    }
}
