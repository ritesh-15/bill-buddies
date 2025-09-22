import SwiftUI

struct CreateSplit: View {

    @State private var amount: String = ""
    @State private var descriptionText: String = ""
    @State private var paymentDate: Date = .now

    @Binding var showCreate: Bool

    var body: some View {
        VStack {
            TopBar(showCreate: $showCreate)

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
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(.black)
        .safeAreaInset(edge: .bottom) {
            AppButton(style: .primary) {
                Text("Next")
                    .font(UIStyleConstants.Typography.body.font.bold())
            } action: {

            }
            .padding(.bottom, UIStyleConstants.Spacing.s.rawValue)
            .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        }
    }
}

fileprivate struct TopBar: View {

    @Binding var showCreate: Bool

    var body: some View {
        HStack(alignment: .center) {
            Text("Split transaction")
                .font(UIStyleConstants.Typography.subHeading.font)
                .bold()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
            HStack {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.white)
                    .onTapGesture {
                        showCreate = false
                    }

                Spacer()
            }
        }
    }
}

fileprivate struct InputField<Value>: View {

    let title: String
    let placeHolder: String
    @Binding var value: Value
    var displayedComponents: DatePickerComponents?

    init(_ title: String,
         placeHolder: String,
         value: Binding<Value>,
         displayedComponents: DatePickerComponents? = nil) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.displayedComponents = displayedComponents
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(UIStyleConstants.Typography.body.font)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            field
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .padding(.vertical, UIStyleConstants.Spacing.sm.rawValue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            Rectangle()
                .stroke(.white, lineWidth: 1)
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
            .foregroundStyle(.white)
            .textInputAutocapitalization(.never)
        } else {
            EmptyView()
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
                .foregroundStyle(.white)

            HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                Text("Rs")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(.white)

                TextField(text: $amount, prompt: Text("0")) {

                }
                .multilineTextAlignment(.leading)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .textCase(.lowercase)
                .font(UIStyleConstants.Typography.heading1.font)
                .tint(.brandPrimary)
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .fixedSize()
        }
    }
}

#Preview {
    CreateSplit(showCreate: .constant(true))
}
