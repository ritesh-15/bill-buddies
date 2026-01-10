import Foundation
import Combine
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {

    @Published var isAuthenticated: Bool = false

    @AppStorage(KeychainStorage.accessToken) private var accessToken: String?
    @AppStorage(KeychainStorage.refreshToken) private var refreshToken: String?

    init() {
        // Initialize authentication state
        checkAuthState()
    }

    func checkAuthState() {
        isAuthenticated = accessToken != nil && refreshToken != nil
    }

    func login(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        isAuthenticated = true
    }

    func logout() {
        accessToken = nil
        refreshToken = nil

        // Also clear stored user
        DependencyContainer.shared.keychainStorage.clear(for: KeychainStorage.me)

        isAuthenticated = false
    }
}
