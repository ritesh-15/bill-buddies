// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let expenseDetailsResponseDto = try ExpenseDetailsResponseDto(json)

import Foundation

// MARK: - ExpenseDetailsResponseDto
struct ExpenseDetailsResponseDto: Codable {
    let data: DataClass
    let meta: Meta

    // MARK: - DataClass
    struct DataClass: Codable {
        let id: Int
        let documentId: String
        let amount: Int
        let description, createdAt: String
        let splitShares: [SplitShare]
        let paidBy: PaidBy
    }

    // MARK: - SplitShare
    struct SplitShare: Codable {
        let id: Int
        let documentId: String
        let amount: Double
        let ownedBy: OwnedBy
    }

    // MARK: - OwnedBy
    struct OwnedBy: Codable {
        let id: Int
        let documentId, username: String
    }

    struct PaidBy: Codable {
        let id: Int
        let documentId, username: String
    }

    // MARK: - Meta
    struct Meta: Codable {
    }
}
