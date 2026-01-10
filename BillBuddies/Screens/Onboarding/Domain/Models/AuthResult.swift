import Foundation

struct AuthResult: Codable {
    let token: String
    let refreshToken: String
    let user: User
}
