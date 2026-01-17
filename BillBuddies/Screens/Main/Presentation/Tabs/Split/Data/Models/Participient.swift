import Foundation

struct Participant: Identifiable, Hashable {
    var id: String
    var name: String
    var avatarSeed: String
    var avatarUrl: String
    var amount: Double
    var share: Int
    var percentage: Double

    init(id: String, name: String, avatarSeed: String = UUID().uuidString, avatarUrl: String = "https://api.dicebear.com/9.x/adventurer-neutral/png") {
        self.id = id
        self.name = name
        self.avatarSeed = avatarSeed
        self.avatarUrl = avatarUrl
        self.amount = 0
        self.share = 0
        self.percentage = 0
    }
}
