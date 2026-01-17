import SwiftUI

struct ToastView: View {

    let message: String
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .foregroundStyle(iconColor)

            Text(message)
                .font(UIStyleConstants.Typography.caption.font)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .padding(.vertical, UIStyleConstants.Spacing.md.rawValue)
        .frame(maxWidth: .infinity, alignment: .leading) // expand to full width
        .background(UIStyleConstants.Colors.backgroundSecondary.value)
        .clipShape(RoundedRectangle(cornerRadius: UIStyleConstants.Radius.sm.rawValue))
        .shadow(radius: 5)
    }
}

#Preview {
    ToastView(message: "Something went wrong", icon: "info.circle.fill", iconColor: Color.blue)
}
