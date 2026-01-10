struct SignInModel: Codable {
    let identifier: String
    let password: String

    init(identifier: String, password: String) {
        self.identifier = identifier
        self.password = password
    }
}
