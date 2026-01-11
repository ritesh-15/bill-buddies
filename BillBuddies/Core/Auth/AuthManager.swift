import Foundation
import Combine
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {

    @Published var isAuthenticated: Bool = false

    @AppStorage(KeychainStorage.accessToken) private var accessToken: String?
    @AppStorage(KeychainStorage.refreshToken) private var refreshToken: String?
    @AppStorage(KeychainStorage.me) private var user: Data?

    init() {
        // Initialize authentication state
        checkAuthState()
    }

    func checkAuthState() {
        isAuthenticated = accessToken != nil && refreshToken != nil
    }

    func login(accessToken: String, refreshToken: String, user: User) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.user = User.encodeToJSON(user: user)
        isAuthenticated = true
    }

    func logout() {
        accessToken = nil
        refreshToken = nil
        user = nil

        isAuthenticated = false
    }

    func me() -> User? {
        if let user {
            return User.decodeToUser(data: user)
        }

        return nil
    }
}
