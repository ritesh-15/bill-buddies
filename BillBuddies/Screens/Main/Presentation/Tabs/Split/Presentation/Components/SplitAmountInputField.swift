import SwiftUI

struct SplitAmountInputField: View {

    enum FieldInput {
        case amount
        case percentage
    }

    @Binding var amount: String
    var inputType: FieldInput = .amount

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            if inputType == .amount {
                Text("Rs")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .fontWeight(.semibold)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }

            TextField(text: $amount, prompt: Text("0")) {

            }
            .multilineTextAlignment(.leading)
            .keyboardType(.numberPad)
            .textInputAutocapitalization(.never)
            .textCase(.lowercase)
            .font(UIStyleConstants.Typography.subHeading.font)
            .tint(.brandPrimary)
            .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            if inputType == .percentage {
                Text("%")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .fontWeight(.semibold)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .fixedSize()
    }
}


#Preview {
    SplitAmountInputField(amount: .constant(""))
}
