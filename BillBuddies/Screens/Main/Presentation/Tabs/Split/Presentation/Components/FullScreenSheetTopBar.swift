import SwiftUI

struct FullScreenSheetTopBar: View {

    @EnvironmentObject var router: NavigationRouter

    let title: String
    let imageIcon: String
    var trailingView: (() -> AnyView)? = nil
    var overrideBackAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                .onTapGesture {
                    if let overrideBackAction {
                        overrideBackAction()
                    } else {
                        router.dismissFullScreen()
                    }
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
    FullScreenSheetTopBar(title: "Split transaction", imageIcon: "xmark")
}
