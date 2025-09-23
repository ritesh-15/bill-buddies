import SwiftUI

struct Groups: View {
    var body: some View {
        VStack {
            TopNavBar()

            ScrollView {
                LazyVStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
                    ForEach(1..<10) { _ in
                        GroupCard(visibleOn: .groups)
                    }
                }
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }
}

fileprivate struct TopNavBar: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                Text("Groups")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                Text("Make your group and split bills easily")
                    .font(UIStyleConstants.Typography.caption.font)
                    .fontWeight(.light)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            }

            Spacer()

            Image(systemName: "plus")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(.all, UIStyleConstants.Spacing.md.rawValue)
                .foregroundStyle(UIStyleConstants.Colors.brandPrimary.value)
                .clipShape(Circle())
                .overlay(
                        Circle()
                            .stroke(UIStyleConstants.Colors.brandPrimary.value, lineWidth: 1)
                    )
        }
    }
}

#Preview {
    Groups()
}
