import Foundation

struct ExpenseDetailModel: Codable {
    let id: Int
    let documentId: String
    let amount: Int
    let createdAt: String
    let description: String?
    let splitShares: [SplitShare]
    let paidBy: PaidBy

    struct SplitShare: Codable, Identifiable {
        let id: Int
        let documentId: String
        let amount: Double
        let ownedBy: OwnedBy
    }

    struct OwnedBy: Codable {
        let id: Int
        let documentId, username: String
    }

    struct PaidBy: Codable {
        let id: Int
        let documentId, username: String
    }
}
