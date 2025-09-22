import SwiftUI

struct GroupCard: View {
    var body: some View {
        VStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
            Text("Tickets for mueseum")
                .font(UIStyleConstants.Typography.subHeading.font)
                .foregroundStyle(.black)
                .bold()

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                    Text("Total")
                        .font(UIStyleConstants.Typography.body.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                    Text("₹ 4569,89")
                        .font(UIStyleConstants.Typography.subHeading.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                }

                Spacer()

                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.xs.rawValue) {
                    Text("You owe")
                        .font(UIStyleConstants.Typography.body.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                    Text("₹ 960")
                        .font(UIStyleConstants.Typography.subHeading.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)
                }
            }

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.sm.rawValue) {
                    Text("Split to")
                        .font(UIStyleConstants.Typography.body.font)
                        .foregroundStyle(UIStyleConstants.Colors.secondary.value)

                    HStack {
                        Avatar(size: 42)
                        Avatar(size: 42)
                    }
                }

                Spacer()

                AppButton(style: .secondary) {
                    Text("Pay now")
                        .bold()
                } action: {

                }.frame(width: 140)
            }
        }
        .padding(.vertical, UIStyleConstants.Spacing.md.rawValue)
        .padding(.horizontal, UIStyleConstants.Spacing.lg.rawValue)
        .background(.brandPrimary)
        .frame(minWidth: 350)
    }
}

#Preview {
    GroupCard()
}
