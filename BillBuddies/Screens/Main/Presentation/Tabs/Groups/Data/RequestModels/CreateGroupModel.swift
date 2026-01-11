import Foundation

struct CreateGroupModel: Codable {
    let data: CreateGroupModelData

    struct CreateGroupModelData: Codable {
        let name: String
        let creator: String
        let members: [String]
    }
}
