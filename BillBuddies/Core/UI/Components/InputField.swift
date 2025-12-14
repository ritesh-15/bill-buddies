import SwiftUI

struct InputField<Value>: View {

    let title: String
    let placeHolder: String
    @Binding var value: Value
    var displayedComponents: DatePickerComponents?
    var textInputType: UITextContentType = .name
    var keyboardType: UIKeyboardType = .default

    init(_ title: String,
         placeHolder: String,
         value: Binding<Value>,
         displayedComponents: DatePickerComponents? = nil,
         textInputType: UITextContentType = .name,
         keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.displayedComponents = displayedComponents
        self.textInputType = textInputType
        self.keyboardType = keyboardType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(UIStyleConstants.Typography.body.font)
                .fontWeight(.semibold)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            field
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .padding(.vertical, UIStyleConstants.Spacing.sm.rawValue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            Rectangle()
                .stroke(UIStyleConstants.Colors.foreground.value, lineWidth: 1)
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
}
