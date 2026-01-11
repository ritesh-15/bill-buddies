import SwiftUI

struct SignInScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var authManager: AuthManager

    @StateObject var viewModel = SignInViewModel(
        loginUseCase: LoginUseCase(
            authRepository: DependencyContainer.shared.authRepository,
            storage: DependencyContainer.shared.keychainStorage),
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xl.rawValue) {
                Text("Log in to Bill Buddies")
                    .font(UIStyleConstants.Typography.subHeading.font)

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    InputField(
                        "Email address",
                        placeHolder: "johndoe@gmail.com",
                        value: $viewModel.emailAddress,
                        textInputType: .emailAddress,
                        keyboardType: .emailAddress,
                        errorMessage: $viewModel.emailAddressErrorMessage)

                    InputField(
                        "Password",
                        placeHolder: "*******",
                        value: $viewModel.password,
                        textInputType: .password,
                        errorMessage: $viewModel.passwordErrorMessage)

                    AppButton(style: .primary) {
                        Text("Log In")
                    } action: {
                        viewModel.login()
                    }
                }

                Divider()
                    .overlay {
                        Text("OR")
                            .font(.custom(UIStyleConstants.FontStyle.light.value, size: UIStyleConstants.FontSize.caption.rawValue))
                    }


                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    ThirdPartyButton(
                        logo: "apple.logo",
                        text: "Continue with Apple",
                        isSystemLogo: true)

                    ThirdPartyButton(logo: "google_logo", text: "Continue with Google")
                }

                HStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Dont have an account?")
                        .font(UIStyleConstants.Typography.body.font)

                    Button {
                        router.navigate(to: .signup)
                    } label: {
                        Text("Sign Up")
                            .font(UIStyleConstants.Typography.body.font)
                            .foregroundStyle(.brandPrimary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .onAppear {
            viewModel.configure(authManager: authManager, router: router)
        }
    }
}

#Preview {
    SignInScreen()
        .environmentObject(NavigationRouter())
}
