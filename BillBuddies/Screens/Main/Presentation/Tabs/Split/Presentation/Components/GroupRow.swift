import SwiftUI

struct GroupRow: View {

    var groupId: String
    var groupName: String
    var members: [MemberModel] = []

    var body: some View {
        HStack(alignment: .top) {
            Avatar(url: "https://api.dicebear.com/9.x/shapes/png?seed=\(groupId)")

            VStack(alignment: .leading, spacing: 0) {
                Text(groupName)
                    .font(UIStyleConstants.Typography.body.font)
                    .fontWeight(.bold)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                LazyHStack {
                    ForEach(members) { member in
                        Avatar(size: 24, seed: member.documentId)
                    }
                }
            }
        }
        .padding(.top, UIStyleConstants.Spacing.md.rawValue)
    }
}

#Preview {
    GroupRow(groupId: "dfdf", groupName: "Kerala Coders")
}
