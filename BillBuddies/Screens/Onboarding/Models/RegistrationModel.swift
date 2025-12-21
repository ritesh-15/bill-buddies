import Foundation

struct RegistrationModel: Codable {
    let email: String
    let password: String
    let username: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.username = email
    }
}
