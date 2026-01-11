import SwiftUI

struct AddMembersScreen: View {

    @EnvironmentObject var viewModel: CreateGroupViewModel

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Add members",
                imageIcon: "xmark",
                overrideBackAction: {
                    viewModel.shouldShowAddMembersScreen = false
                })

            ScrollView {
                VStack {
                    InputField(
                        "Search members",
                        placeHolder: "Enter name of a member",
                        value: $viewModel.memberSearchText)
                    .padding(.bottom, UIStyleConstants.Spacing.lg.rawValue)

                    ForEach($viewModel.members) { $member in
                        HStack {
                            MemberView(viewModel: viewModel, member: $member, shouldShowCheckBox: true)
                        }
                        .onTapGesture {
                            viewModel.toggleMemember(member: member)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
        }
        .padding(UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .task {
            viewModel.fetchMembers()
        }
    }
}

#Preview {
    AddMembersScreen()
        .environmentObject(CreateGroupViewModel())
}
