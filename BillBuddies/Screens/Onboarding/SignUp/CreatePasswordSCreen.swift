import SwiftUI

struct CreatePasswordSCreen: View {

    @EnvironmentObject var router: NavigationRouter
    @State var confirmPassword: String = ""
    @State var password: String = ""

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
                        value: $password,
                        textInputType: .password)

                    InputField(
                        "Confirm password",
                        placeHolder: "*******",
                        value: $confirmPassword,
                        textInputType: .password)

                    AppButton(style: .primary) {
                        Text("Confirm")
                    } action: {

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

