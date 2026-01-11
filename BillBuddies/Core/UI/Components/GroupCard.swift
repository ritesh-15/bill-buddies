import SwiftUI

struct GroupCard: View {

    enum CardType {
        case expense
        case group
    }

    private let colors: [UIColor] = [
        UIColor(red: 251/255, green: 203/255, blue: 204/255, alpha: 1),
        UIColor(red: 154/255, green: 235/255, blue: 228/255, alpha: 1),
        UIColor(red: 241/255, green: 155/255, blue: 111/255, alpha: 1),
    ]

    var cardType: CardType = .expense
    var title: String
    var members: [MemberModel] = []
    var isCreatedByMe = false
    var shoudAddSpacer = true

    var body: some View {
        HStack {
            if cardType == .expense {
                if !isCreatedByMe {
                    // Card on left, space on right
                    cardContent

                    if shoudAddSpacer {
                        Spacer(minLength: UIStyleConstants.Spacing.xl.rawValue)
                    }
                } else {
                    // Space on left, card on right
                    if shoudAddSpacer {
                        Spacer(minLength: UIStyleConstants.Spacing.xl.rawValue)
                    }

                    cardContent
                }
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        VStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
            HStack(alignment: .center) {
                Text(title)
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .foregroundStyle(.black)
                    .bold()

                if cardType == .group {
                    Group {
                        Spacer()

                        Image(systemName: "ellipsis")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                            .frame(width: 16, height: 16)
                    }
                }
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Total")
                        .font(UIStyleConstants.Typography.body.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                    Text("₹ 4569")
                        .font(UIStyleConstants.Typography.subHeading.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                }

                Spacer()

                if cardType == .group {
                    SplitTo(members: members)
                } else {
                    VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xs.rawValue) {
                        Text("You owe")
                            .font(UIStyleConstants.Typography.body.font)
                            .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                        Text("₹ 960")
                            .font(UIStyleConstants.Typography.subHeading.font)
                            .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                    }
                }
            }

            if cardType == .group {
                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.sm.rawValue) {
                    HStack(alignment: .center) {
                        Text("Paid")
                            .font(UIStyleConstants.Typography.body.font)
                            .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                        Spacer()

                        Text("45%")
                            .font(UIStyleConstants.Typography.subHeading.font)
                            .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                    }

                    ProgressBar(progress: 40)
                }
            } else {
                HStack(alignment: .bottom) {
                    SplitTo()

                    Spacer()

                    AppButton(style: .secondary) {
                        Text("Pay now")
                            .bold()
                    } action: {

                    }.frame(width: 140)
                }
            }
        }
        .padding(.vertical, UIStyleConstants.Spacing.md.rawValue)
        .padding(.horizontal, UIStyleConstants.Spacing.lg.rawValue)
        .background(Color(uiColor: colors.randomElement() ?? .brandPrimary))
        .frame(minWidth: 350)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

fileprivate struct ProgressBar: View {
    var progress: CGFloat

    private var normalized: CGFloat {
        max(0, min(progress / 100.0, 1))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(.white)
                    .frame(height: 12)

                RoundedRectangle(cornerRadius: 0)
                    .fill(UIStyleConstants.Colors.secondary.value)
                    .frame(width: geo.size.width * normalized, height: 12)
            }
        }
        .frame(height: 12)
    }
}

fileprivate struct SplitTo: View {

    var members: [MemberModel] = []

    var body: some View {
        VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.sm.rawValue) {
            Text("Split to")
                .font(UIStyleConstants.Typography.body.font)
                .foregroundStyle(UIStyleConstants.Colors.secondary.value)

            HStack {
                ForEach(members.suffix(3)) { member in
                    Avatar(size: 42, seed: member.documentId)
                }
            }
        }
    }
}

#Preview {
    VStack {
        GroupCard(cardType: .expense, title: "Bus ticket", isCreatedByMe: false)
        GroupCard(cardType: .expense, title: "Bus ticket", isCreatedByMe: true)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
