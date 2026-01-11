// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dTOCreateGroupResponse = try DTOCreateGroupResponse(json)

import Foundation

// MARK: - DTOCreateGroupResponse

struct DTOCreateGroupResponse: Codable {
    let data: DTOData
    let meta: DTOMeta

    // MARK: - DTOData

    struct DTOData: Codable {
        let id: Int
        let documentId, name: String
        let description, category: String?
        let simplifyDebts: Bool
        let createdAt, updatedAt, publishedAt: String
    }

    // MARK: - DTOMeta

    struct DTOMeta: Codable {

    }

}
