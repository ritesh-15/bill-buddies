import SwiftUI

struct InputField<Value>: View {

    let title: String
    let placeHolder: String
    @Binding var value: Value
    var displayedComponents: DatePickerComponents?
    var textInputType: UITextContentType = .name
    var keyboardType: UIKeyboardType = .default
    @Binding var errorMessage: String

    init(_ title: String,
         placeHolder: String,
         value: Binding<Value>,
         displayedComponents: DatePickerComponents? = nil,
         textInputType: UITextContentType = .name,
         keyboardType: UIKeyboardType = .default,
         errorMessage: Binding<String> = .constant("")) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.displayedComponents = displayedComponents
        self.textInputType = textInputType
        self.keyboardType = keyboardType
        self._errorMessage = errorMessage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(UIStyleConstants.Typography.body.font)
                .fontWeight(.semibold)
                .foregroundStyle(!hasErrorMessage() ? UIStyleConstants.Colors.foreground.value : UIStyleConstants.Colors.destructive.value)

            field

            if hasErrorMessage() {
                Text(errorMessage)
                    .font(UIStyleConstants.Typography.caption.font)
                    .fontWeight(.light)
                    .foregroundStyle(UIStyleConstants.Colors.destructive.value)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .padding(.vertical, UIStyleConstants.Spacing.sm.rawValue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            Rectangle()
                .stroke(!hasErrorMessage() ? UIStyleConstants.Colors.foreground.value : UIStyleConstants.Colors.destructive.value,
                        lineWidth: 1)
        }
    }

    @ViewBuilder
    private var field: some View {
        if Value.self == Date.self, let displayedComponents {
            DatePicker(
                title,
                selection: Binding<Date>(
                    get: { value as! Date },
                    set: { value = $0 as! Value }
                ),
                displayedComponents: displayedComponents)
            .labelsHidden()
            .datePickerStyle(.compact)
            .font(UIStyleConstants.Typography.subHeading.font)
            .tint(UIStyleConstants.Colors.brandPrimary.value)
        } else if Value.self == String.self {
            TextField(text: Binding<String>(
                get: { value as! String },
                set: { value = $0 as! Value }
            ), prompt: Text(placeHolder)) {

            }
            .tint(UIStyleConstants.Colors.brandPrimary.value)
            .font(UIStyleConstants.Typography.subHeading.font)
            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            .textInputAutocapitalization(.never)
            .textContentType(textInputType)
            .keyboardType(keyboardType)
        } else {
            EmptyView()
        }
    }

    private func hasErrorMessage() -> Bool {
        return errorMessage == nil || !errorMessage.isEmpty
    }
}
