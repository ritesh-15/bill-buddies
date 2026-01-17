import SwiftUI

struct SplitAmountInputField: View {

    enum FieldInput {
        case amount
        case percentage
    }

    @Binding var amount: Double
    var inputType: FieldInput = .amount
    var onFocusChange: ((Bool) -> Void)? = nil

    @FocusState private var isFocused: Bool

    // Bridge a Double binding to a String binding for TextField
    private var amountStringBinding: Binding<String> {
        Binding<String>(
            get: {
                // Show empty when zero to encourage input, or format value
                if amount == 0 { return "" }
                return String(format: "%.2f", Double(truncating: amount as NSNumber))
            },
            set: { newValue in
                // Normalize decimal separator to dot
                let normalized = newValue.replacingOccurrences(of: ",", with: ".")
                if let number = Double(normalized) {
                    amount = number
                } else if newValue.isEmpty {
                    amount = 0
                }
                // If invalid input, we simply ignore and keep the last valid amount
            }
        )
    }

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            if inputType == .amount {
                Text("Rs")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .fontWeight(.semibold)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }

            TextField(text: amountStringBinding, prompt: Text("0")) { }
                .multilineTextAlignment(.leading)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .textCase(.lowercase)
                .font(UIStyleConstants.Typography.subHeading.font)
                .tint(.brandPrimary)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                .focused($isFocused)
                .onChange(of: isFocused) { _, newValue in
                    onFocusChange?(newValue)
                }

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
    SplitAmountInputField(amount: .constant(0))
}

