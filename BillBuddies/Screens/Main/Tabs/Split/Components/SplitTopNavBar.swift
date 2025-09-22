import SwiftUI

struct SplitTopNavBar: View {

    let title: String
    let imageIcon: String

    @Binding var showCreate: Bool

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundStyle(.white)
                .onTapGesture {
                    showCreate = false
                }

            Spacer()

            Text("2/3")
                .font(UIStyleConstants.Typography.body.font)
                .padding(.horizontal, UIStyleConstants.Spacing.sm.rawValue)
                .padding(.vertical, UIStyleConstants.Spacing.xs.rawValue)
                .background(.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .overlay {
            // Centered title overlay
            Text(title)
                .font(UIStyleConstants.Typography.subHeading.font)
                .bold()
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    SplitTopNavBar(title: "Split transaction", imageIcon: "xmark", showCreate: .constant(false))
}
