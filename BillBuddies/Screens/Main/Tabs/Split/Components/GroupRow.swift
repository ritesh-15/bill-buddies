import SwiftUI

struct GroupRow: View {
    var body: some View {
        HStack(alignment: .top) {
            Avatar(url: "https://api.dicebear.com/9.x/shapes/png?seed=\(UUID().uuidString)")

            VStack(alignment: .leading, spacing: 0) {
                Text("Kerala Trip")
                    .font(UIStyleConstants.Typography.body.font)
                    .fontWeight(.bold)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                LazyHStack {
                    Avatar(size: 24)
                    Avatar(size: 24)
                    Avatar(size: 24)
                }
            }
        }
        .padding(.top, UIStyleConstants.Spacing.md.rawValue)
    }
}

#Preview {
    GroupRow()
}
