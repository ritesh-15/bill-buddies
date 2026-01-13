import Foundation

struct GroupDetailResponseModel: Codable, Identifiable {
    let id: Int
    let documentId, name: String
    let description, category: String?
    let simplifyDebts: Bool
    let creator: Creator
    let members: [Creator]
    let expenses: [Expense]

    struct Creator: Codable, Identifiable {
        let id: Int
        let documentId, username: String
    }

    struct Expense: Codable, Identifiable {
        let id: Int
        let documentId, description: String
        let amount: Int
        let splitShares: [SplitShare]
        let paidBy: PaidBy
    }

    struct SplitShare: Codable, Identifiable {
        let id: Int
        let documentId: String
        let ownedBy: OwnedBy
    }

    struct OwnedBy: Codable, Identifiable, GroupCardMemberProtocol {
        var id: Int
        var documentId: String
    }

    struct PaidBy: Codable, Identifiable {
        let id: Int
        let documentId: String
    }
}
