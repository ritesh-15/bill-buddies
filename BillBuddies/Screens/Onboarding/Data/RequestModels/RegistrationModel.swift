import Foundation

struct RegistrationModel: Codable {
    let email: String
    let password: String
    let username: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
        // Remove the part after '@' symbol
        self.username = email.replacingOccurrences(of: "@.*", with: "", options: .regularExpression)
    }
}
