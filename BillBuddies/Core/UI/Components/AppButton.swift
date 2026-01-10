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
    @Binding var isLoading: Bool

    // Designated initializer
    init(style: ButtonStyle,
         @ViewBuilder content: @escaping () -> Content,
         action: @escaping () -> Void,
         isLoading: Binding<Bool> = .constant(false)) {
        self.style = style
        self.content = content
        self.action = action
        self._isLoading = isLoading
    }

    // Explicit convenience initializer matching call sites without isLoading.
    // This ensures the exact symbol exists even across module boundaries.
    init(style: ButtonStyle,
         @ViewBuilder content: @escaping () -> Content,
         action: @escaping () -> Void) {
        self.init(style: style, content: content, action: action, isLoading: .constant(false))
    }

    var body: some View {
        Button {
            action()
        } label: {
            if isLoading {
                Text("Please wait...")
                    .font(UIStyleConstants.Typography.body.font)
                    .frame(maxWidth: frameMaxWidth)
                    .padding(padding)
                    .foregroundStyle(foregroundColor)
                    .background(backgroundColor.opacity(0.8))
            } else {
                content()
                    .font(UIStyleConstants.Typography.body.font)
                    .frame(maxWidth: frameMaxWidth)
                    .padding(padding)
                    .foregroundStyle(foregroundColor)
                    .background(backgroundColor)
            }
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
