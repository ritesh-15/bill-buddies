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
            }
        }

        @ViewBuilder
        var destinationView: some View {
            switch self {
            default:
                Text("View not configured")
            }
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
                    CreateSplit()
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

    // Modal presentation
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreen: AppRoute?

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
        currentPath.wrappedValue.append(route)
    }

    func navigateToRoot() {
        currentPath.wrappedValue = NavigationPath()
    }

    func pop() {
        guard !currentPath.wrappedValue.isEmpty else { return }
        currentPath.wrappedValue.removeLast()
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
        presentedFullScreen = nil
        selectedTab = previousTab
    }
}

