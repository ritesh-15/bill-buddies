import SwiftUI

struct SignUpScreen: View {

    @State var emailAddress: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xl.rawValue) {
                Text("Get your free account")
                    .font(UIStyleConstants.Typography.subHeading.font)

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    ThirdPartySignInButtonView(
                        logo: "apple.logo",
                        text: "Continue with Apple",
                        isSystemLogo: true)

                    ThirdPartySignInButtonView(logo: "google_logo", text: "Continue with Google")
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
                        value: $emailAddress)

                    AppButton(style: .primary) {
                        Text("Continue")
                    } action: {

                    }
                }

                HStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Already have an account ?")
                        .font(UIStyleConstants.Typography.body.font)

                    Button {

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

fileprivate struct ThirdPartySignInButtonView: View {

    let logo: String
    let text: String
    var isSystemLogo: Bool = false

    var body: some View {
        AppButton(style: .secondary) {
            HStack {
                if isSystemLogo {
                    Image(systemName: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                } else {
                    Image(logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Text(text)
                    .font(UIStyleConstants.Typography.body.font)

                Spacer()
            }
        } action: {

        }
        .overlay {
            Rectangle()
                .stroke(lineWidth: 1)
        }
    }
}

#Preview {
    SignUpScreen()
}
