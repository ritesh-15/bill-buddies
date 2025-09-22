import SwiftUI

struct AppButton<Content: View>: View {

    enum ButtonStyle {
        case primary
        case secondary
        case destructive
        case link
    }

    let style: ButtonStyle
    let content: () -> Content
    let action: () -> Void

    init(style: ButtonStyle,
         @ViewBuilder content: @escaping () -> Content,
         action: @escaping () -> Void) {
        self.style = style
        self.content = content
        self.action = action
    }

    var body: some View {
        Button {

        } label: {
            content()
                .font(UIStyleConstants.Typography.body.font)
                .frame(maxWidth: frameMaxWidth)
                .padding(padding)
                .background(backgroundColor)
                .foregroundStyle(foregroundColor)
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return UIStyleConstants.Colors.brandPrimary.value
        case .secondary: return UIStyleConstants.Colors.secondary.value
        case .destructive: return Color.red.opacity(0.9)
        case .link: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .black
        case .secondary: return .white
        case .destructive: return .white
        case .link: return .black
        }
    }

    private var padding: EdgeInsets {
        switch style {
        case .link:
            return EdgeInsets()
        default:
            return EdgeInsets(top: UIStyleConstants.Spacing.md.rawValue,
                              leading: UIStyleConstants.Spacing.lg.rawValue,
                              bottom: UIStyleConstants.Spacing.md.rawValue,
                              trailing: UIStyleConstants.Spacing.lg.rawValue)
        }
    }

    private var frameMaxWidth: CGFloat? {
        style == .link ? nil : .infinity
    }
}
