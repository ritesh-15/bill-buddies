// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let groupMembersDto = try GroupMembersDto(json)

import Foundation

// MARK: - GroupMembersDto
struct GroupMembersDto: Codable {
    let data: DataClass
    let meta: Meta

    // MARK: - DataClass
    struct DataClass: Codable {
        let id: Int
        let documentId, name: String
        let members: [Member]
    }

    // MARK: - Member
    struct Member: Codable {
        let id: Int
        let documentId, username: String
    }

    // MARK: - Meta
    struct Meta: Codable {
    }

}
