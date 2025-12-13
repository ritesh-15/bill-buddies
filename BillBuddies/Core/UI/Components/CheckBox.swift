import SwiftUI

struct CheckBox: View {

    var isChecked: Bool

    var body: some View {
        Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(isChecked ? UIStyleConstants.Colors.brandPrimary.value : .gray)
            .padding(.trailing, 8)
    }
}

#Preview {
    CheckBox(isChecked: true)
}
