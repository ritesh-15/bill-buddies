import Foundation
import SwiftUI

enum UIStyleConstants {
    enum FontStyle {
        case light
        case regular
        case medium
        case semiBold
        case bold

        var value: String {
            switch self {
            case .light:
                return "PlaypenSansThai-Light"
            case .regular:
                return "PlaypenSansThai-Regular"
            case .medium:
                return "PlaypenSansThai-Medium"
            case .semiBold:
                return "PlaypenSansThai-SemiBold"
            case .bold:
                return "PlaypenSansThai-Bold"
            }
        }
    }

    enum FontSize: CGFloat {
        case heading1 = 42
        case heading2 = 32
        case subHeading = 24
        case regular = 16
        case caption = 14
    }

    enum Colors {
        case brandPrimary
        case secondary
        case destructive
        case background
        case foreground

        var value: Color {
            switch self {
            case .brandPrimary: return Color(.brandPrimary)
            case .secondary: return Color(.black)
            case .destructive: return Color(.red)
            case .background: return Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .black : .white
            })
            case .foreground: return Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .white : .black
            })
            }
        }
    }

    enum Spacing: CGFloat {
        case s = 2
        case xs = 4
        case sm = 8
        case md = 16
        case lg = 24
        case xl = 32
        case xxl = 42
        case xxxl = 64
    }

    enum Radius: CGFloat {
        case s = 2
        case xs = 4
        case sm = 8
        case md = 12
        case lg = 14
        case xl = 16
        case xxl = 22
        case xxxl = 24
    }

    enum Typography {
        case heading1
        case heading2
        case subHeading
        case body
        case caption

        var font: Font {
            switch self {
            case .heading1:
                return .custom(FontStyle.bold.value, size: FontSize.heading1.rawValue)
            case .heading2:
                return .custom(FontStyle.bold.value, size: FontSize.heading2.rawValue)
            case .subHeading:
                return .custom(FontStyle.bold.value, size: FontSize.subHeading.rawValue)
            case .body:
                return .custom(FontStyle.regular.value, size: FontSize.regular.rawValue)
            case .caption:
                return .custom(FontStyle.light.value, size: FontSize.caption.rawValue)
            }
        }
    }
}
