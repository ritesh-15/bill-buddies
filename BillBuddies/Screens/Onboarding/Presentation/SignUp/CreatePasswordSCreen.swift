import SwiftUI

struct CreatePasswordSCreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: SignupViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xl.rawValue) {
                VStack(alignment: .leading) {
                    Text("Lets get your account secured")
                        .font(UIStyleConstants.Typography.subHeading.font)

                    Text("Please set a strong password to protect your account")
                        .font(UIStyleConstants.Typography.caption.font)
                        .fontWeight(.light)
                        .tint(.brandPrimary)
                }

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    InputField(
                        "Password",
                        placeHolder: "*******",
                        value: $viewModel.password,
                        textInputType: .password,
                        errorMessage: $viewModel.passwordErrorMessage)

                    InputField(
                        "Confirm password",
                        placeHolder: "*******",
                        value: $viewModel.confirmPassword,
                        textInputType: .password,
                        errorMessage: $viewModel.confirmPasswordErrorMessage)

                    AppButton(style: .primary) {
                        Text("Confirm")
                    } action: {
                        viewModel.register()
                    }
                }
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

#Preview {
    CreatePasswordSCreen()
        .environmentObject(NavigationRouter())
}

