import Foundation
import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {

    // MARK: - Observerable properties

    @Published var emailAddress: String = ""
    @Published var password: String = ""

    @Published var emailAddressErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""

    @Published var isLoading: Bool = false

    // MARK: - Private properties

    private let loginUseCase: LoginUseCase
    private var authManager: AuthManager?
    private var router: NavigationRouter?
    private let toastManager: ToastManager = DependencyContainer.shared.toastManager

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    // MARK: - Public methods

    func configure(authManager: AuthManager, router: NavigationRouter) {
        self.authManager = authManager
        self.router = router
    }

    func canGotoEmailVerificationScreen() -> Bool {
        if emailAddress.isEmpty || !isValidEmail(emailAddress) {
            emailAddressErrorMessage = "Please enter a valid email address"
            return false
        }

        emailAddressErrorMessage = ""
        return true
    }

    func login() {
        Task {
            if !isValidEmail(emailAddress) {
                emailAddressErrorMessage = "Email address should be valid"
                return
            } else {
                emailAddressErrorMessage = ""
            }

            // Validate password
            if password.isEmpty {
                passwordErrorMessage = "Password is required"
                return
            } else {
                passwordErrorMessage = ""
            }

            let result = await loginUseCase.execute(data: .init(identifier: emailAddress, password: password))

            switch result {
            case .success(let data):
                toastManager.show(message: "Login successfull!", style: .success)
                authManager?.login(accessToken: data.token, refreshToken: data.refreshToken, user: data.user)
                router?.resetAllPaths()
            case .failure(let error):
                toastManager.show(message: error.errorDescription ?? "Something went wrong please try again later!", style: .error)
            }
        }
    }

    // MARK: - Private methods

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
