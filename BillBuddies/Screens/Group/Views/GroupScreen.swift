import SwiftUI

struct GroupScreen: View {

    @EnvironmentObject var router: NavigationRouter
    @State var message = ""

    var body: some View {
        VStack(spacing: UIStyleConstants.Spacing.sm.rawValue) {
            TopNavBar(router: router)

            Divider()

            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
                        ForEach(1..<10) { index in
                            GroupCard(cardType: .expense, isCreatedByMe: index % 3 == 0)
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
                .padding(.all, UIStyleConstants.Spacing.md.rawValue)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

fileprivate struct TopNavBar: View {
    @ObservedObject var router: NavigationRouter

    var body: some View {
        HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    router.pop()
                }

            HStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                Avatar(size: 46)

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Trip to kerala")
                        .font(UIStyleConstants.Typography.body.font)
                        .fontWeight(.bold)

                    LazyHStack {
                        ForEach(1..<5) { _ in
                            Text("Ritesh,")
                                .font(UIStyleConstants.Typography.caption.font)
                        }
                    }
                    .fixedSize()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GroupScreen()
        .environmentObject(NavigationRouter())
}

