import SwiftUI

struct ContentView: View {

    @StateObject var router = NavigationRouter()

    var body: some View {
        MainScreen()
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
