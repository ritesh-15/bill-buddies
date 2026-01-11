//
//  MembersModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

struct MembersModel: Identifiable, Codable {
    let id: Int
    let username: String
    let documentId: String
}
