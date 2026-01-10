import SwiftUI

struct EmailVerificationScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: SignupViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xl.rawValue) {
                VStack(alignment: .leading) {
                    Text("Check your email")
                        .font(UIStyleConstants.Typography.subHeading.font)

                    Text("We have sent an verification code to \(viewModel.emailAddress)")
                        .font(UIStyleConstants.Typography.caption.font)
                        .fontWeight(.light)
                        .tint(.brandPrimary)
                }

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    OtpInputField()

                    AppButton(style: .primary) {
                        Text("Verify email")
                    } action: {
                        router.navigate(to: .createPassword)
                    }
                }

                HStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Didn't received the email?")
                        .font(UIStyleConstants.Typography.body.font)

                    Button {
                        router.navigate(to: .signup)
                    } label: {
                        Text("Click to resend")
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

fileprivate struct OtpInputField: View {

    @State var inputValues: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusState: Int?

    var body: some View {
        HStack {
            ForEach(inputValues.indices, id: \.self) { index in
                TextField("", text: $inputValues[index])
                    .multilineTextAlignment(.center)
                    .frame(height: 72)
                    .overlay {
                        Rectangle()
                            .stroke(UIStyleConstants.Colors.foreground.value, lineWidth: 1)
                    }
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .focused($focusState, equals: index)
                    .tint(.brandPrimary)
                    .onChange(of: inputValues[index]) { _, newValue in
                        if inputValues[index].count > 1 {
                            inputValues[index] = String(inputValues[index].suffix(1))
                        }

                        if !newValue.isEmpty {
                            self.focusState = (self.focusState ?? 0) + 1
                        } else {
                            self.focusState = (self.focusState ?? 0) - 1
                        }
                    }
            }
        }
    }

    init() {
        self.focusState = 0
    }

    private func hasInputFilled(index: Int) -> Bool {
        guard let focusState else {
            return false
        }

        return focusState > index && !inputValues[index].isEmpty
    }
}

#Preview {
    EmailVerificationScreen()
        .environmentObject(NavigationRouter())
}
