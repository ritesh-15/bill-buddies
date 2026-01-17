// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dTOCreateExpenseResponse = try DTOCreateExpenseResponse(json)

import Foundation

struct DTOCreateExpenseResponse: Codable {
    let data: DTOData
    let message: String

    struct DTOData: Codable {
        let id: Int
        let documentId: String
        let amount: Int
        let description, date: String?
        let isSettled: Bool
        let splitMethod: String?
        let category, createdAt, updatedAt, publishedAt: String
        let locale: String?
    }

    struct DTOMeta: Codable {
    }
}
