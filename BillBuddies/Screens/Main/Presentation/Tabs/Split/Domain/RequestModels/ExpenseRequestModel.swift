//
//  ExpenseRequestModel.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 17/01/26.
//

import Foundation

struct ExpenseRequestModel: Codable {

    let data: ExpenseModel

    struct ExpenseModel: Codable {
        let description: String
        let paidBy: String
        let amount: Double
        let category: String
        let date: String
        let splitShares: [SplitShareRequestModel]
        let group: String
        let splitMethod: String
    }
}
