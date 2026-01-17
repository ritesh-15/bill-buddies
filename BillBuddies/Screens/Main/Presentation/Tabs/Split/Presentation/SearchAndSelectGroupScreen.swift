import SwiftUI

struct SearchAndSelectGroupScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: CreateSplitViewModel
    @EnvironmentObject var authManager: AuthManager

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

                    ForEach(viewModel.searchGroups) { group in
                        HStack {
                            GroupRow(groupId: group.documentId, groupName: group.name)

                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.selectGroup(group: group)
                            viewModel.showChooseGroupScreen = false
                        }
                    }
                }
            }
            .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
        }
        .padding(UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .task {
            viewModel.configure(authManager: authManager)
            viewModel.fetchSelectGroups()
        }
    }
}

#Preview {
    SearchAndSelectGroupScreen()
        .environmentObject(CreateSplitViewModel())
}
