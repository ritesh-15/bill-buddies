import SwiftUI

struct MemberView: View {

    @ObservedObject var viewModel: CreateGroupViewModel
    @Binding var member: MembersModel
    var shouldShowCheckBox: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            Avatar(size: 52, seed: member.documentId)

            VStack(alignment: .leading) {
                Text("\(member.username)")
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .bold()

                Text("\(member.documentId)")
                    .font(UIStyleConstants.Typography.caption.font)
            }

            Spacer()

            if shouldShowCheckBox {
                CheckBox(isChecked: viewModel.isMemberSelected(member: member))
            } else {
                ImageButton(
                    imageIcon: "minus",
                    size: .init(width: 16, height: 16),
                    foregroundStyle: UIStyleConstants.Colors.destructive.value) {
                        viewModel.toggleMemember(member: member)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MemberView(
        viewModel: CreateGroupViewModel(),
        member: .constant(.init(id: 1, username: "df", documentId: "dfd")))
}
