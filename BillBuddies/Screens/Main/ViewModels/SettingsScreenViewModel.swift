import Combine
import Foundation
import SwiftUI

struct Setting: Identifiable {
    let id = UUID().uuidString
    let imageIcon: String
    let name: String
    let actionIcon: String?
    let actionView: (() -> AnyView)?
    let action: (() -> Void)?

    init(imageIcon: String,
         name: String,
         actionIcon: String? = nil,
         actionView: (() -> AnyView)? = nil,
         action: (() -> Void)? = nil) {
        self.imageIcon = imageIcon
        self.name = name
        self.actionIcon = actionIcon
        self.actionView = actionView
        self.action = action
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

    private var authManager: AuthManager?
    private var router: NavigationRouter?
    private let toastManager = DependencyContainer.shared.toastManager

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
                Setting(imageIcon: "iphone.and.arrow.right.outward", name: "Log out", action: {
                    self.authManager?.logout()
                    self.toastManager.show(message: "Logged out succesfully!", style: .success)
                    self.router?.resetAllPaths()
                }),
            ])
        ]
    }()

    var themeManager: ThemeManager? {
        didSet {
            darkModeToggle = themeManager?.selectedTheme == .dark
        }
    }

    // MARK: - Public methods

    func configure(authManager: AuthManager, router: NavigationRouter) {
        self.authManager = authManager
        self.router = router
    }

    func toggleDarkMode(isDarkMode: Bool) {
        withAnimation(.easeInOut(duration: 0.3)) {
            themeManager?.selectedTheme = isDarkMode ? .dark : .light
        }
    }
}
