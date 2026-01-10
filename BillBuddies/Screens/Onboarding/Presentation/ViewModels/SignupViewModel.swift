import Foundation
import Combine

final class SignupViewModel: ObservableObject {

    // MARK: - Observerable properties

    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var emailAddressErrorMessage: String = ""
    @Published var passwordErroMessage: String = ""
    @Published var confirmPasswordErroMessage: String = ""

    @Published var isLoading: Bool = false

    // MARK: - Private properties

    let registerUseCase: RegisterUserCase

    init(with registerUseCase: RegisterUserCase) {
        self.registerUseCase = registerUseCase
    }

    // MARK: - Public methods

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
                // Redirect to main page
                print("[DEBUG] SignupViewModel \(data)")
            case .failure(let failure):
                // TODO: Handle errors better
                print("[ERROR] \(failure.errorDescription ?? "")")
            }

            isLoading = false
        }
    }

    // MARK: - Private methods

    private func isValidPasswords() -> Bool {
        if password.isEmpty {
            passwordErroMessage = "Password cannot be empty"
            confirmPasswordErroMessage = ""
            return false
        }

        if confirmPasswordErroMessage.isEmpty || password != confirmPassword {
            confirmPasswordErroMessage = "Confirm password and password must be same"
            passwordErroMessage = ""
            return false
        }

        if password.count < 6 {
            passwordErroMessage = "Password length must be greater than 6 characters"
            confirmPasswordErroMessage = ""
            return false
        }

        passwordErroMessage = ""
        confirmPasswordErroMessage = ""
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
