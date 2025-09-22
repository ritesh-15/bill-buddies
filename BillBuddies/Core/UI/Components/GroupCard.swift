import SwiftUI

struct GroupCard: View {

    enum VisibleOn {
        case home
        case groups
    }

    var visibleOn: VisibleOn = .home

    var body: some View {
        VStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
            HStack(alignment: .center) {
                Text("Tickets for mueseum")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .foregroundStyle(.black)
                    .bold()

                if visibleOn == .groups {
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

                if visibleOn == .groups {
                    SplitTo()
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

            if visibleOn == .groups {
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
        .background(.brandPrimary)
        .frame(minWidth: 350)
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
    var body: some View {
        VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.sm.rawValue) {
            Text("Split to")
                .font(UIStyleConstants.Typography.body.font)
                .foregroundStyle(UIStyleConstants.Colors.secondary.value)

            HStack {
                Avatar(size: 42)
                Avatar(size: 42)
            }
        }
    }
}

#Preview {
    GroupCard(visibleOn: .groups)
}
