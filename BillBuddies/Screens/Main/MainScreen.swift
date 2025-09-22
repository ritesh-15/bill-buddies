import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeScreen()
            }

            Tab("Groups", systemImage: "person.3") {
                Groups()
            }

            Tab("Split", systemImage: "plus.circle") {
                Text("Add split")
            }

            Tab("Statistics", systemImage: "chart.bar") {
                Text("Statistics")
            }

            Tab("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
        .tint(UIStyleConstants.Colors.brandPrimary.value)
    }
}

#Preview {
    MainScreen()
}
