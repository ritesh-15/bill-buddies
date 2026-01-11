import SwiftUI

struct GroupScreen: View {

    var groupId: String

    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = GroupDetailsViewModel()

    var body: some View {
        let spacingSM = UIStyleConstants.Spacing.sm.rawValue
        let spacingMD = UIStyleConstants.Spacing.md.rawValue
        let bgColor = UIStyleConstants.Colors.background.value

        VStack(spacing: spacingSM) {
            TopNavBar(viewModel: viewModel)

            Divider()

            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: spacingMD) {
                        let currentUserId = authManager.me()?.id
                        ForEach(viewModel.groupDetails?.expenses ?? []) { expense in
                            GroupExpenseRow(expense: expense, currentUserId: currentUserId)
                        }
                    }
                }

                // Floating Action Button
                Button(action: {
                    router.presentFullScreen(.split)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: UIStyleConstants.FontSize.subHeading.rawValue))
                        .foregroundStyle(.black)
                        .frame(width: 74, height: 74)
                        .background(UIStyleConstants.Colors.brandPrimary.value)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.23), radius: 6, x: 0, y: 4)
                        .accessibilityLabel("Add Expense")
                }
                .padding(.all, spacingMD)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(bgColor)
        .task {
            viewModel.fetchGroupDetails(groupId: groupId)
        }
    }
}

fileprivate struct GroupExpenseRow: View {
    let expense: GroupDetailResponseModel.Expense
    let currentUserId: String?

    init(expense: GroupDetailResponseModel.Expense, currentUserId: String?) {
        self.expense = expense
        self.currentUserId = currentUserId
    }

    var body: some View {
        let isCreatedByMe = expense.paidBy.documentId == currentUserId
        GroupCard(
            cardType: .expense,
            title: expense.description,
            members: expense.splitShares.map({ share in
                return share.ownedBy
            }),
            total: expense.amount,
            isCreatedByMe: isCreatedByMe,
        )
    }
}

fileprivate struct TopNavBar: View {

    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: GroupDetailsViewModel

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    router.pop()
                }

            HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                Avatar(size: 46)

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text(viewModel.groupDetails?.name ?? "")
                        .font(UIStyleConstants.Typography.body.font)
                        .fontWeight(.bold)

                    Text("\(viewModel.groupDetails?.members.count ?? 0) members")
                        .font(UIStyleConstants.Typography.caption.font)
                }
            }
            .onTapGesture {
                router.navigate(to: .groupSetting)
            }

            Spacer()

            Menu {
                Button {

                } label: {
                    Text("Refresh")
                        .font(UIStyleConstants.Typography.body.font)
                }

                Button {
                    router.navigate(to: .groupSetting)
                } label: {
                    Text("Group Settings")
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GroupScreen(groupId: "12")
        .environmentObject(NavigationRouter())
}

