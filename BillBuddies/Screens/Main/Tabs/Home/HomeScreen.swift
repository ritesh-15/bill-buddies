import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            TopNavBar()

            ScrollView {
                RecentBillSplits()

                Friends()

                RecentActivity()
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

fileprivate struct RecentActivity: View {
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Recent activity") {

            }

            LazyVStack {
                ForEach(1..<10) { _ in
                    HStack(alignment: .top) {
                        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                            Image(systemName: "mug.fill")
                                .frame(width: 54, height: 54)
                                .padding(.all, 12)
                                .foregroundStyle(.brandPrimary)
                                .background(.brandPrimary.opacity(0.7))
                                .clipShape(Circle())
                                .clipped()

                            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                                Text("Coffe shop")
                                    .font(UIStyleConstants.Typography.body.font)
                                    .bold()
                                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                                Text("Apr 2025 . 6:44 pm")
                                    .font(UIStyleConstants.Typography.caption.font)
                                    .fontWeight(.light)
                                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                            }
                        }

                        Spacer()

                        Text("+₹450")
                            .font(UIStyleConstants.Typography.subHeading.font)
                            .bold()
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    }
                    .padding(.bottom, UIStyleConstants.Spacing.sm.rawValue)
                }
            }

        }
    }
}

fileprivate struct Friends: View {
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Friends") {

            }

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(1..<10) { _ in
                        Avatar()
                    }
                }
            }
        }
    }
}

fileprivate struct RecentBillSplits: View {
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Recent bill splits") {

            }

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(1..<4) { _ in
                        GroupCard(cardType: .expense, shoudAddSpacer: false)
                    }
                }
            }
        }
    }
}

fileprivate struct SectionHeader: View {
    let sectionTitle: String
    let seeAllAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Text(sectionTitle)
                .font(UIStyleConstants.Typography.subHeading.font)
                .fontWeight(.bold)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            Spacer()

            AppButton(style: .link) {
                Text("See all")
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.brandPrimary.value)
            } action: {
                seeAllAction()
            }

        }
    }
}

fileprivate struct TopNavBar: View {

    @EnvironmentObject var authManager: AuthManager
    // Retrieve the stored user JSON as Data and decode it to User
    private var user: User? {
        authManager.me()
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xs.rawValue) {
                Text("Hey \(user?.username ?? "there")!")
                    .font(UIStyleConstants.Typography.heading2.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .bold()

                Text("Split your bill with your friends")
                    .font(UIStyleConstants.Typography.body.font)
                    .fontWeight(.light)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }

            Spacer()

            Avatar()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    HomeScreen()
}
