import Combine
import Foundation
import SwiftUI

@MainActor
final class NavigationRouter: ObservableObject {

    // MARK: - Navigation Destinations

    enum AppRoute: Hashable, Identifiable {
        // Tab-specific routes
        case groupDetail(id: String)
        case expenseDetail(id: String)
        case addExpense
        case settleUp(groupId: String)
        case activityDetail(id: String)
        case profile
        case settings
        case editProfile
        case groupSetting

        // Global routes
        case signup
        case signin
        case emailVerification
        case createPassword

        // Modal routes
        case split
        case createGroup

        var id: String {
            switch self {
            case .groupDetail(let id): return "groupDetail:\(id)"
            case .expenseDetail(let id): return "expenseDetail:\(id)"
            case .addExpense: return "addExpense"
            case .settleUp(let groupId): return "settleUp:\(groupId)"
            case .activityDetail(let id): return "activityDetail:\(id)"
            case .profile: return "profile"
            case .settings: return "settings"
            case .editProfile: return "editProfile"
            case .split: return "split"
            case .createGroup: return "createGroup"
            case .groupSetting: return "groupSetting"
            case .signup: return "signup"
            case .signin: return "signin"
            case .emailVerification: return "emailVerification"
            case .createPassword: return "createPassword"
            }
        }

        var isGlobalRoute: Bool {
            switch self {
            case .signup, .signin, .emailVerification, .createPassword:
                return true
            default:
                return false
            }
        }

        @ViewBuilder
        var destinationView: some View {
            Group {
                switch self {
                case .groupDetail(_):
                    GroupScreen()
                case .signup:
                    SignUpScreen()
                case .signin:
                    SignInScreen()
                case .emailVerification:
                    EmailVerificationScreen()
                case .createPassword:
                    CreatePasswordSCreen()
                case .groupSetting:
                    GroupSettingsScreen()
                default:
                    Text("View not configured")
                }
            }
            .toolbarVisibility(.hidden, for: .tabBar)
        }

        @ViewBuilder
        var sheetView: some View {
            NavigationStack {
                switch self {
                default:
                    Text("Sheet not configured")
                }
            }
        }

        @ViewBuilder
        var fullScreenView: some View {
            NavigationStack {
                switch self {
                case .split:
                    SplitContainerScreen()
                case .createGroup:
                    CreateGroupScreen()
                default:
                    Text("Full screen not configured")
                }
            }
        }
    }

    // MARK: - Tab Selection

    enum Tab: Hashable {
        case home
        case groups
        case split
        case stats
        case settings
    }

    @Published var navigationPath = NavigationPath()

    // Tab selection
    @Published var selectedTab: Tab = .home
    var previousTab: Tab = .home

    // Navigation paths for each tab
    @Published var homePath = NavigationPath()
    @Published var groupsPath = NavigationPath()
    @Published var statsPath = NavigationPath()
    @Published var settingsPath = NavigationPath()

    //  Navigation path for global routes (e.g Signup)
    @Published var globalPath = NavigationPath()

    // Modal presentation
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreen: AppRoute?

    private func pathBinding(for route: AppRoute) -> Binding<NavigationPath> {
        if route.isGlobalRoute {
            return Binding(
                get: { self.globalPath },
                set: { self.globalPath = $0 }
            )
        }

        return currentPath
    }

    // Get the current path based on selected tab
    var currentPath: Binding<NavigationPath> {
        switch selectedTab {
        case .home:
            return Binding(
                get: { self.homePath },
                set: { self.homePath = $0 }
            )
        case .groups:
            return Binding(
                get: { self.groupsPath },
                set: { self.groupsPath = $0 }
            )
        case .stats:
            return Binding(
                get: { self.statsPath },
                set: { self.statsPath = $0 }
            )
        case .settings:
            return Binding(
                get: { self.settingsPath },
                set: { self.settingsPath = $0 }
            )
        case .split:
            // Split doesn't have a path since it's full screen
            return Binding(
                get: { NavigationPath() },
                set: { _ in }
            )
        }
    }

    // MARK: - Navigation Methods

    func navigate(to route: AppRoute) {
        let path = pathBinding(for: route)
        path.wrappedValue.append(route)
    }

    func navigateToRoot() {
        if !globalPath.isEmpty {
            globalPath = NavigationPath()
        } else {
            currentPath.wrappedValue = NavigationPath()
        }
    }

    func pop() {
        // Pop from global path if it has items, otherwise from current tab
        if !globalPath.isEmpty {
            globalPath.removeLast()
        } else if !currentPath.wrappedValue.isEmpty {
            currentPath.wrappedValue.removeLast()
        }
    }

    func switchTab(to tab: Tab, andNavigateTo route: AppRoute? = nil) {
        if tab == .split {
            // Store current tab before opening split
            previousTab = selectedTab
            presentFullScreen(.split)
            return
        }

        selectedTab = tab
        if let route {
            // Delay slightly to ensure tab switch completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.navigate(to: route)
            }
        }
    }

    func presentSheet(_ route: AppRoute) {
        presentedSheet = route
    }

    func presentFullScreen(_ route: AppRoute) {
        presentedFullScreen = route
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func dismissFullScreen() {
        // Restore previous tab when dismissing split
        if presentedFullScreen == .split {
            selectedTab = previousTab
        }

        presentedFullScreen = nil
    }

    func resetAllPaths() {
        homePath = NavigationPath()
        groupsPath = NavigationPath()
        statsPath = NavigationPath()
        settingsPath = NavigationPath()
        globalPath = NavigationPath()

        // Reset to home tab
        selectedTab = .home
        previousTab = .home

        // Dismiss any presented sheets or full screens
        presentedSheet = nil
        presentedFullScreen = nil
    }
}

