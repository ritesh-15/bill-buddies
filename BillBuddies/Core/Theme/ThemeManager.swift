import Combine
import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

final class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = AppTheme.dark.rawValue

    @Published var selectedTheme: AppTheme {
        didSet { selectedThemeRawValue = selectedTheme.rawValue }
    }

    init() {
        self.selectedTheme = .dark
    }

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system: return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        case .light: return .light
        case .dark: return .dark
        }
    }
}
