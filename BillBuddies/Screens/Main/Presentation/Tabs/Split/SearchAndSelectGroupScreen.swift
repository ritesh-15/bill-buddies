import SwiftUI

struct SearchAndSelectGroupScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: CreateSplitViewModel

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Select group",
                imageIcon: "xmark",
                overrideBackAction: {
                    viewModel.showChooseGroupScreen = false
                })

            ScrollView {
                VStack {
                    InputField(
                        "Search group",
                        placeHolder: "Enter name of a group",
                        value: $viewModel.groupNameSearchText)

                    ForEach(1..<10) { _ in
                        HStack {
                            GroupRow()

                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.isGroupSelected = true
                            viewModel.showChooseGroupScreen = false
                        }
                    }
                }
            }
            .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
        }
        .padding(UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

#Preview {
    SearchAndSelectGroupScreen()
        .environmentObject(CreateSplitViewModel())
}
