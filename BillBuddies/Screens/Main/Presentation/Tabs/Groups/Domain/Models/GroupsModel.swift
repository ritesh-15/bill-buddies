import Foundation

enum GroupCategory: String, CaseIterable {
    case friends = "Friends"
    case faimily = "Familiy"
    case trip = "Trip"
    case roommates = "Roommates"
    case couple = "Couple"
    case events = "events"
    case other = "Other"
}

struct GroupsModel: Identifiable {
    let id: Int
    let documentId: String
    let name: String
    let description: String?
    let category: GroupCategory?
    let simplifyDebts: Bool
    let createdAt: String
    let creator: CreatorModel
    let members: [MemberModel]
}

struct CreatorModel: Identifiable {
    let id: Int
    let documentId: String
    let username: String
}

struct MemberModel: Identifiable {
    let id: Int
    let documentId: String
    let username: String
}
