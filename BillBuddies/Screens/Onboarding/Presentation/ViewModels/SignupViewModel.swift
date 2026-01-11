import Foundation
import Combine

final class SignupViewModel: ObservableObject {

    // MARK: - Observerable properties

    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var emailAddressErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""

    @Published var isLoading: Bool = false

    // MARK: - Private properties

    private let registerUseCase: RegisterUserCase
    private var authManager: AuthManager?
    private var router: NavigationRouter?

    private let toastManager: ToastManager = DependencyContainer.shared.toastManager

    init(with registerUseCase: RegisterUserCase) {
        self.registerUseCase = registerUseCase
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

    func register() {
        Task {
            // Validate password and confirm password are same
            if !isValidPasswords() {
                return
            }

            isLoading = true

            let result = await registerUseCase.execute(data:  .init(email: emailAddress, password: password))

            switch result {
            case .success(let data):
                toastManager.show(message: "Registration succesfull!", style: .success)
                authManager?.login(accessToken: data.token, refreshToken: data.refreshToken, user: data.user)
                router?.resetAllPaths()
            case .failure(let failure):
                toastManager.show(message: failure.errorDescription ?? "Something went wrong please try again later!", style: .error)
            }

            isLoading = false
        }
    }

    // MARK: - Private methods

    private func isValidPasswords() -> Bool {
        if password.isEmpty {
            passwordErrorMessage = "Password cannot be empty"
            confirmPasswordErrorMessage = ""
            return false
        }

        if confirmPasswordErrorMessage.isEmpty || password != confirmPassword {
            confirmPasswordErrorMessage = "Confirm password and password must be same"
            passwordErrorMessage = ""
            return false
        }

        if password.count < 6 {
            passwordErrorMessage = "Password length must be greater than 6 characters"
            confirmPasswordErrorMessage = ""
            return false
        }

        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
