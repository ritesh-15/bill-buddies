// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recentExpensesDto = try RecentExpensesDto(json)

import Foundation

// MARK: - RecentExpensesDto
struct RecentExpensesDto: Codable {
    let data: [Datum]
    let meta: Meta

    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let documentId, date: String
        let description: String?
        let amount: Double
        let splitShares: [SplitShare]
    }

    // MARK: - SplitShare
    struct SplitShare: Codable {
        let id: Int
        let documentId: String
        let ownedBy: OwnedBy
        let amount: Double
    }

    // MARK: - OwnedBy
    struct OwnedBy: Codable {
        let id: Int
        let documentId: String
    }

    // MARK: - Meta
    struct Meta: Codable {
        let pagination: Pagination
    }

    // MARK: - Pagination
    struct Pagination: Codable {
        let page, pageSize, pageCount, total: Int
    }
}
