import SwiftUI

struct MainScreen: View {

    @StateObject private var viewModel = MainScreenViewModel()

    var body: some View {
        TabView(selection: $viewModel.selection) {
            Tab("Home", systemImage: "house", value: MainScreenViewModel.TabItem.home) {
                HomeScreen()
            }

            Tab("Groups", systemImage: "person.3", value: MainScreenViewModel.TabItem.groups) {
                Groups()
            }

            Tab("Split", systemImage: "plus.circle", value: MainScreenViewModel.TabItem.split) {
                Color.clear
            }

            Tab("Statistics", systemImage: "chart.bar", value: MainScreenViewModel.TabItem.stats) {
                Text("Statistics")
            }

            Tab("Settings", systemImage: "gearshape", value: MainScreenViewModel.TabItem.settings) {
                Text("Settings")
            }
        }
        .tint(UIStyleConstants.Colors.brandPrimary.value)
        .onChange(of: viewModel.selection) { _, newValue in
            viewModel.onTabChange(newValue)
        }
        .fullScreenCover(isPresented: $viewModel.showCreate, onDismiss: {
            viewModel.switchToPreviousTab()
        }) {
            CreateSplit(showCreate: $viewModel.showCreate)
        }
    }
}

#Preview {
    MainScreen()
}
