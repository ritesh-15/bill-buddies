import Combine
import Foundation
import SwiftUI

struct Setting: Identifiable {
    let id = UUID().uuidString
    let imageIcon: String
    let name: String
    let actionIcon: String?
    let actionView: (() -> AnyView)?

    init(imageIcon: String, name: String, actionIcon: String? = nil, actionView: (() -> AnyView)? = nil) {
        self.imageIcon = imageIcon
        self.name = name
        self.actionIcon = actionIcon
        self.actionView = actionView
    }
}

struct SettingSection: Identifiable {
    let id = UUID().uuidString
    let name: String
    let items: [Setting]
}

final class SettingsScreenViewModel: ObservableObject {

    // MARK: - Observable properties

    @Published var darkModeToggle: Bool = false

    // MARK: - Properites

    lazy var sections: [SettingSection] = {
        return [
            SettingSection(name: "Account", items: [
                Setting(imageIcon: "person", name: "Profile", actionIcon: "chevron.right"),
                Setting(imageIcon: "lock", name: "Password", actionIcon: "chevron.right"),
                Setting(imageIcon: "bell", name: "Notification", actionIcon: "chevron.right"),
                Setting(imageIcon: "moon", name: "Dark mode", actionView: {
                    AnyView(
                        Toggle("", isOn: Binding(
                            get: { self.darkModeToggle },
                            set: { newValue in
                                self.darkModeToggle = newValue
                                self.toggleDarkMode(isDarkMode: newValue)
                            }
                        ))
                        .labelsHidden()
                    )
                }),
            ]),
            SettingSection(name: "Other", items: [
                Setting(imageIcon: "phone", name: "Support", actionIcon: "chevron.right"),
                Setting(imageIcon: "info.circle", name: "Report an issue", actionIcon: "chevron.right"),
                Setting(imageIcon: "globe", name: "Language", actionIcon: "chevron.right"),
                Setting(imageIcon: "iphone.and.arrow.right.outward", name: "Log out"),
            ])
        ]
    }()

    var themeManager: ThemeManager? {
        didSet {
            darkModeToggle = themeManager?.selectedTheme == .dark
        }
    }

    // MARK: - Public methods

    func toggleDarkMode(isDarkMode: Bool) {
        withAnimation(.easeInOut(duration: 0.3)) {
            themeManager?.selectedTheme = isDarkMode ? .dark : .light
        }
    }
}
