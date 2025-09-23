import SwiftUI

struct Groups: View {

    @StateObject var viewModel = GroupsViewModel()

    var body: some View {
        VStack {
            TopNavBar(viewModel: viewModel)

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
                    ForEach(1..<10) { _ in
                        GroupCard(visibleOn: .groups)
                    }
                }
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .fullScreenCover(isPresented: $viewModel.showCreateGroup) {
            CreateGroupScreen(showCreateGroup: $viewModel.showCreateGroup)
        }
    }
}

fileprivate struct TopNavBar: View {

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
                viewModel.showCreateGroup.toggle()
            }
        }
    }
}

#Preview {
    Groups()
}
