import SwiftUI
import SwiftData

struct ContentView: View {

    @StateObject var router = NavigationRouter()
    @StateObject var authManager = AuthManager()
    @StateObject var toastManager = DependencyContainer.shared.toastManager

    // For now creatign a signup view model at global level, in future plan to move it in a better place
    @StateObject var signupViewModel = DependencyContainer.shared.singupViewModel

    init() {
        DependencyContainer.shared.configure(container: modelContainer)
    }

    var body: some View {
        NavigationStack(path: $router.globalPath) {
            Group {
                if authManager.isAuthenticated {
                    MainScreen()
                } else {
                    LandingScreen()
                }
            }
            .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                route.destinationView
            }
        }
        .id(authManager.isAuthenticated) 
        .environmentObject(router)
        .environmentObject(authManager)
        .environmentObject(signupViewModel)
        .sheet(item: $router.presentedSheet) { route in
            route.sheetView
                .environmentObject(router)
                .environmentObject(authManager)
                .toast(
                    isPresented: $toastManager.isShowing,
                    message: toastManager.message,
                    icon: toastManager.style.icon,
                    iconColor: toastManager.style.color)
        }
        .fullScreenCover(item: $router.presentedFullScreen) { route in
            route.fullScreenView
                .environmentObject(router)
                .environmentObject(authManager)
                .toast(
                    isPresented: $toastManager.isShowing,
                    message: toastManager.message,
                    icon: toastManager.style.icon,
                    iconColor: toastManager.style.color)
        }
        .toast(
            isPresented: $toastManager.isShowing,
            message: toastManager.message,
            icon: toastManager.style.icon,
            iconColor: toastManager.style.color)
        .modelContainer(modelContainer)
    }

    var modelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: SDExpenseEntity.self,
                SDGroupEntity.self,
                SDSplitShareEntity.self,
                SDMemberEntity.self,
            )
        } catch let error {
            fatalError("Failed to register model: \(error)")
        }
    }()
}

#Preview {
    ContentView()
}
