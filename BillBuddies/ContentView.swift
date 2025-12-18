import SwiftUI

struct ContentView: View {

    @StateObject var router = NavigationRouter()
    private var isAuthenticated = true

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
