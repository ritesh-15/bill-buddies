import SwiftUI

struct SignUpScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: SignupViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xl.rawValue) {
                Text("Get your free account")
                    .font(UIStyleConstants.Typography.subHeading.font)

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    ThirdPartyButton(
                        logo: "apple.logo",
                        text: "Continue with Apple",
                        isSystemLogo: true)

                    ThirdPartyButton(logo: "google_logo", text: "Continue with Google")
                }

                Divider()
                    .overlay {
                        Text("OR")
                            .font(.custom(UIStyleConstants.FontStyle.light.value, size: UIStyleConstants.FontSize.caption.rawValue))
                    }

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    InputField(
                        "Email address",
                        placeHolder: "johndoe@gmail.com",
                        value: $viewModel.emailAddress,
                        textInputType: .emailAddress,
                        keyboardType: .emailAddress,
                        errorMessage: $viewModel.emailAddressErrorMessage)

                    AppButton(style: .primary, content: {
                        Text("Continue")
                    }, action: {
                        if viewModel.canGotoEmailVerificationScreen() {
                            router.navigate(to: .emailVerification)
                        }
                    }, isLoading: $viewModel.isLoading)
                }

                HStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Already have an account ?")
                        .font(UIStyleConstants.Typography.body.font)

                    Button {
                        router.navigate(to: .signin)
                    } label: {
                        Text("Sign In")
                            .font(UIStyleConstants.Typography.body.font)
                            .foregroundStyle(.brandPrimary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

#Preview {
    SignUpScreen()
        .environmentObject(NavigationRouter())
        .environmentObject(SignupViewModel(with: DependencyContainer.shared.authService))
}
