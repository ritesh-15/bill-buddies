import SwiftUI

struct CreateGroupScreen: View {

    @StateObject var viewModel = CreateGroupViewModel()

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Create group",
                imageIcon: "xmark")

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.xl.rawValue) {
                    // Group name
                    InputField(
                        "Group name",
                        placeHolder: "Identify your group by",
                        value: $viewModel.groupName)

                    HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                        VStack(alignment: .leading) {
                            Text("Add members")
                                .font(UIStyleConstants.Typography.body.font)
                                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                .bold()

                            Text("You can add friends with whom you want split expenses")
                                .font(UIStyleConstants.Typography.caption.font)
                                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                .fontWeight(.light)
                        }

                        Spacer()

                        ImageButton(imageIcon: "plus") {
                            viewModel.shouldShowAddMembersScreen = true
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVStack {
                        ForEach($viewModel.selectedMembers) { $member in
                            MemberView(viewModel: viewModel, member: $member)
                        }

                        if $viewModel.selectedMembers.isEmpty {
                            Text("No member selected")
                                .font(UIStyleConstants.Typography.body.font)
                        }
                    }
                }
                .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .safeAreaInset(edge: .bottom) {
            Group {
                AppButton(style: .primary) {
                    Text("Create")
                        .font(UIStyleConstants.Typography.body.font.bold())
                } action: {

                }
                .padding(.vertical, UIStyleConstants.Spacing.s.rawValue)
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .background(UIStyleConstants.Colors.background.value)
        }
        .fullScreenCover(isPresented: $viewModel.shouldShowAddMembersScreen) {
            AddMembersScreen()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    CreateGroupScreen()
}
