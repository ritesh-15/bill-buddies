//
//  SplitShareRequestModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

struct SplitShareRequestModel: Codable {
    let amount: Double
    let percentage: Double
    let share: Int
    let ownedBy: String
    let paidTo: String
}
