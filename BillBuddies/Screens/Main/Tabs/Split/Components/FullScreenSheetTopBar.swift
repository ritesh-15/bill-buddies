import SwiftUI

struct FullScreenSheetTopBar: View {

    let title: String
    let imageIcon: String
    @Binding var showCreate: Bool
    var trailingView: (() -> AnyView)? = nil

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                .onTapGesture {
                    showCreate = false
                }

            Spacer()

            trailingView?()
        }
        .frame(maxWidth: .infinity)
        .overlay {
            // Centered title overlay
            Text(title)
                .font(UIStyleConstants.Typography.subHeading.font)
                .bold()
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
        }
    }
}

#Preview {
    FullScreenSheetTopBar(title: "Split transaction", imageIcon: "xmark", showCreate: .constant(false))
}
