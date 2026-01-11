// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dTOGroupDetailResponse = try DTOGroupDetailResponse(json)

import Foundation

// MARK: - DTOGroupDetailResponse
struct DTOGroupDetailResponse: Codable {
    let data: DTOData
    let meta: DTOMeta


    // MARK: - DTOData
    struct DTOData: Codable {
        let id: Int
        let documentId, name: String
        let description, category: String?
        let simplifyDebts: Bool
        let createdAt, updatedAt, publishedAt: String
        let creator: DTOCreator
        let members: [DTOCreator]
        let expenses: [DTOExpense]
    }

    // MARK: - DTOCreator
    struct DTOCreator: Codable {
        let id: Int
        let documentId, username: String
    }

    // MARK: - DTOExpense
    struct DTOExpense: Codable {
        let id: Int
        let documentId, description: String
        let amount: Int
        let splitShares: [DTOSplitShare]
        let paidBy: DTOPaidBy
    }

    // MARK: - DTOSplitShare
    struct DTOSplitShare: Codable {
        let id: Int
        let documentId: String
        let ownedBy: DTOOwnedBy
    }

    // MARK: - DTOOwnedBy
    struct DTOOwnedBy: Codable {
        let id: Int
        let documentId: String
    }

    struct DTOPaidBy: Codable {
        let id: Int
        let documentId: String
    }

    // MARK: - DTOMeta
    struct DTOMeta: Codable {
    }

}
