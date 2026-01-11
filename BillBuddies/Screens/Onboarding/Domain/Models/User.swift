import Foundation

struct User: Codable {
    let id: String
    let email: String
    let username: String

    static func encodeToJSON(user: User) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(user)
            return encoded
        } catch let error {
            print("[ERROR] \(error.localizedDescription)")
            return nil
        }
    }

    static func decodeToUser(data: Data) -> User? {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch let error {
            print("[ERROR] \(error.localizedDescription)")
            return nil
        }
    }
}
