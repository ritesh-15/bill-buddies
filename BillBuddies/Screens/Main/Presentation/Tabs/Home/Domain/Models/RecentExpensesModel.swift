import Foundation

struct RecentExpensesModel: Codable, Identifiable {
    let id: Int
    let documentId, date: String
    let description: String?
    let amount: Double
    let splitShares: [SplitShare]
    // This will be the amount current user owed
    var youOwe: Int? = nil

    struct SplitShare: Codable {
        let id: Int
        let documentId: String
        let ownedBy: OwnedBy
    }

    struct OwnedBy: Codable, GroupCardMemberProtocol {
        var id: Int
        var documentId: String
    }
}
