import SwiftUI

struct MainScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = MainScreenViewModel()

    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house", value: NavigationRouter.Tab.home) {
                NavigationStack(path: router.currentPath) {
                    HomeScreen()
                        .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                            route.destinationView
                        }
                }
            }

            Tab("Groups", systemImage: "person.3", value: NavigationRouter.Tab.groups) {
                NavigationStack(path: router.currentPath) {
                    Groups()
                        .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                            route.destinationView
                        }
                }
            }

            Tab("Split", systemImage: "plus.circle", value: NavigationRouter.Tab.split) {
                Color.clear
            }

            Tab("Statistics", systemImage: "chart.bar", value: NavigationRouter.Tab.stats) {
                NavigationStack(path: router.currentPath) {
                    Text("Statistics")
                        .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                            route.destinationView
                        }
                }
            }

            Tab("Settings", systemImage: "gearshape", value: NavigationRouter.Tab.settings) {
                NavigationStack(path: router.currentPath) {
                    SettingsScreen()
                        .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                            route.destinationView
                        }
                }
            }
        }
        .tint(UIStyleConstants.Colors.brandPrimary.value)
        .onChange(of: router.selectedTab) { previousTab, newTab in
            if newTab == .split {
                router.previousTab = previousTab
                router.presentFullScreen(.split)
            }
        }
    }
}

#Preview {
    MainScreen()
}
