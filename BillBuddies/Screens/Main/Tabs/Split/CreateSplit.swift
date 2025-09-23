import SwiftUI

struct CreateSplit: View {

    @State private var amount: String = ""
    @State private var descriptionText: String = ""
    @State private var paymentDate: Date = .now

    @Binding var showCreate: Bool

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Split transaction",
                imageIcon: "xmark",
                showCreate: $showCreate) {
                    AnyView(
                        Text("2/3")
                            .font(UIStyleConstants.Typography.body.font)
                            .padding(.horizontal, UIStyleConstants.Spacing.sm.rawValue)
                            .padding(.vertical, UIStyleConstants.Spacing.xs.rawValue)
                            .background(.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    )
                }

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.lg.rawValue) {
                    // Enter amount
                    EnterAmountField(amount: $amount)

                    // Description
                    InputField(
                        "Description (optional)",
                        placeHolder: "Describe your transaction",
                        value: $descriptionText)

                    // Date
                    InputField(
                        "Payment date",
                        placeHolder: "Pick payment date",
                        value: $paymentDate,
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

                }
                .padding(.vertical, UIStyleConstants.Spacing.s.rawValue)
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .background(UIStyleConstants.Colors.background.value)
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
    CreateSplit(showCreate: .constant(true))
}
