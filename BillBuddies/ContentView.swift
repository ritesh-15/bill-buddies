import SwiftUI

struct ContentView: View {

    @StateObject var router = NavigationRouter()

    // For now creatign a signup view model at global level, in future plan to move it in a better place
    @StateObject var signupViewModel = DependencyContainer.shared.singupViewModel
    @AppStorage(KeychainStorage.accessToken) var accessToken: String?
    @AppStorage(KeychainStorage.refreshToken) var refreshToken: String?

    // We can make it better 🙈
    private var isAuthenticated: Bool {
        accessToken != nil && refreshToken != nil
    }

    var body: some View {
        NavigationStack(path: $router.globalPath) {
            Group {
                if isAuthenticated {
                    MainScreen()
                } else {
                    LandingScreen()
                }
            }
            .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                route.destinationView
            }
        }
        .environmentObject(router)
        .environmentObject(signupViewModel)
        .sheet(item: $router.presentedSheet) { route in
            route.sheetView
                .environmentObject(router)
        }
        .fullScreenCover(item: $router.presentedFullScreen) { route in
            route.fullScreenView
                .environmentObject(router)
        }
    }
}

#Preview {
    ContentView()
}
