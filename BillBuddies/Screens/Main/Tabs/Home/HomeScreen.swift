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
        .background(.black)
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
                                    .foregroundStyle(.white)

                                Text("Apr 2025 . 6:44 pm")
                                    .font(UIStyleConstants.Typography.caption.font)
                                    .fontWeight(.light)
                                    .foregroundStyle(.white)
                            }
                        }

                        Spacer()

                        Text("+₹450")
                            .font(UIStyleConstants.Typography.subHeading.font)
                            .bold()
                            .foregroundStyle(.white)
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
                        GroupCard()
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
                .foregroundStyle(.white)

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
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xs.rawValue) {
                Text("Hey Tom!")
                    .font(UIStyleConstants.Typography.heading2.font)
                    .foregroundStyle(.white)
                    .bold()

                Text("Split your bill with your friends")
                    .font(UIStyleConstants.Typography.body.font)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
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
