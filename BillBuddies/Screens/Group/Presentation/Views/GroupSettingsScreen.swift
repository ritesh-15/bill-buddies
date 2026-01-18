import SwiftUI

struct GroupSettingsScreen: View {

    var groupId: String

    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel = GroupSettingsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Custom header to replace the system toolbar
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture { router.pop() }

                Spacer()

                Menu {
                    Button {

                    } label: {
                        Text("Get help")
                            .font(UIStyleConstants.Typography.body.font)
                    }

                    Button {

                    } label: {
                        Text("Send feedback")
                            .font(UIStyleConstants.Typography.body.font)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .tint(UIStyleConstants.Colors.foreground.value)
                }
            }
            .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            .padding(.vertical, UIStyleConstants.Spacing.md.rawValue)

            ScrollView {
                VStack(spacing: UIStyleConstants.Spacing.lg.rawValue) {
                    UserAvatars(viewModel: viewModel)

                    HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                        Text("\(viewModel.groupDetails?.name ?? "")")
                            .font(UIStyleConstants.Typography.subHeading.font)

                        Button {

                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .tint(UIStyleConstants.Colors.foreground.value)
                        }

                    }

                    VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.lg.rawValue) {
                        SettingsView(icon: "person.fill.badge.plus", name: "Add member") {

                        }

                        SettingsView(icon: "bell.slash", name: "Mute notifications") {

                        }

                        SettingsView(icon: "link", name: "Invite people via link") {

                        }

                        SettingsView(icon: "qrcode", name: "Invite people via QR code") {

                        }

                        SettingsView(icon: "iphone.and.arrow.right.outward", name: "Leave group") {

                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Group members (\(viewModel.groupDetails?.members.count ?? 0))")
                        .font(UIStyleConstants.Typography.body.font)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack {
                        ForEach(viewModel.groupDetails?.members ?? []) { member in
                            GroupMember(name: member.username, userName: member.documentId)
                        }
                    }
                }
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .scrollIndicators(.hidden)
        }
        .background(UIStyleConstants.Colors.background.value)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .tint(UIStyleConstants.Colors.foreground.value)
        .task {
            viewModel.fetchGroupMembers(groupId: groupId)
        }
    }
}

fileprivate struct GroupMember: View {

    let name: String
    let userName: String

    var body: some View {
        HStack(alignment: .center) {
            Avatar(size: 52)

            VStack(alignment: .leading) {
                Text(name)
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .bold()

                Text(userName)
                    .font(UIStyleConstants.Typography.caption.font)
            }

            Spacer()

            ImageButton(
                imageIcon: "minus",
                size: .init(width: 16, height: 16),
                foregroundStyle: UIStyleConstants.Colors.destructive.value) {

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

fileprivate struct SettingsView: View {

    let icon: String
    let name: String
    let action: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 28, height: 28)

            Text(name)
        }
        .onTapGesture {
            action()
        }
    }
}

fileprivate struct UserAvatars: View {

    @ObservedObject var viewModel: GroupSettingsViewModel

    private let avatarSize: CGFloat = 52
    private let overlap: CGFloat = 40

    var members: [GroupMembersModel.Member] {
        viewModel.groupDetails?.members ?? []
    }

    var body: some View {
        HStack {
            ZStack {
                let maxCount = min(5, members.count)
                let centerIndex = (maxCount - 1) / 2
                ForEach(members.indices.prefix(maxCount), id: \.self) { index in
                    let member = members[index]
                    let xOffset = CGFloat(index - centerIndex) * -overlap
                    Avatar(size: avatarSize, seed: member.documentId)
                        .offset(x: xOffset)
                        .zIndex(Double(index))
                }
            }
            .frame(
                width: avatarSize + CGFloat(max(0, members.count - 1)) * overlap,
                height: avatarSize
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 24)
    }
}

#Preview {
    GroupSettingsScreen(groupId: "")
        .environmentObject(NavigationRouter())
}
