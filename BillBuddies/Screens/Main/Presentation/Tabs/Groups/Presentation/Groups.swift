import SwiftUI

struct Groups: View {

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var authManager: AuthManager

    @StateObject var viewModel = GroupsViewModel()

    var body: some View {
        VStack {
            TopNavBar(viewModel: viewModel)

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
                    if viewModel.groups.count > 0 {
                        ForEach(viewModel.groups) { group in
                            GroupCard(cardType: .group, title: group.name, members: group.members)
                            .onTapGesture {
                                router.navigate(to: .groupDetail(id: group.documentId))
                                }
                        }
                    } else {
                        Text("No groups found, you can create one!")
                            .font(UIStyleConstants.Typography.body.font)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .task {
            // For now adding temprory fix for the issue
            // Issue is that when redirects to group settings page somehow task get called again and again which causes multiple fetch group request at a point
            if viewModel.groups.isEmpty {
                viewModel.configure(authManager: authManager)
                viewModel.fetchGroups()
            }
        }
        .refreshable {
            viewModel.fetchGroups()
        }
    }
}

fileprivate struct TopNavBar: View {

    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: GroupsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                Text("Groups")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                Text("Make your group and split bills easily")
                    .font(UIStyleConstants.Typography.caption.font)
                    .fontWeight(.light)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }

            Spacer()

            ImageButton(imageIcon: "plus") {
                router.presentFullScreen(.createGroup)
            }
        }
    }
}

#Preview {
    Groups()
}
