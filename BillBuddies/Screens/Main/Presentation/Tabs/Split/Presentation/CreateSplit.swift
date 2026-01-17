import SwiftUI

struct CreateSplit: View {

    @ObservedObject var viewModel: CreateSplitViewModel
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Split transaction",
                imageIcon: "xmark")

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.lg.rawValue) {
                    // Enter amount
                    EnterAmountField(amount: $viewModel.amount)

                    // Description
                    InputField(
                        "Description (optional)",
                        placeHolder: "Describe your transaction",
                        value: $viewModel.description)

                    // Date
                    InputField(
                        "Payment date",
                        placeHolder: "Pick payment date",
                        value: $viewModel.paymentDate,
                        displayedComponents: .date)

                    Spacer()
                }
                .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .safeAreaInset(edge: .bottom) {
            Group {
                AppButton(style: .primary) {
                    Text("Next")
                        .font(UIStyleConstants.Typography.body.font.bold())
                } action: {
                    viewModel.nextStep()
                }
                .padding(.vertical, UIStyleConstants.Spacing.s.rawValue)
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .background(UIStyleConstants.Colors.background.value)
        }
        .onAppear {
            viewModel.configure(authManager: authManager, router: router)
        }
    }
}

fileprivate struct EnterAmountField: View {

    @Binding var amount: String

    var body: some View {
        VStack(alignment: .center) {
            Text("Enter amount to split")
                .font(UIStyleConstants.Typography.body.font)
                .bold()
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                Text("Rs")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                TextField(text: $amount, prompt: Text("0")) {

                }
                .multilineTextAlignment(.leading)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .textCase(.lowercase)
                .font(UIStyleConstants.Typography.heading1.font)
                .tint(.brandPrimary)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .fixedSize()
        }
    }
}

#Preview {
    CreateSplit(viewModel: CreateSplitViewModel())
}
