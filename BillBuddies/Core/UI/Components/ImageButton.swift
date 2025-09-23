import SwiftUI

struct ImageButton: View {

    let imageIcon: String
    var size: CGSize = .init(width: 24, height: 24)
    var foregroundStyle: Color = UIStyleConstants.Colors.brandPrimary.value
    var action: (() -> Void)

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: imageIcon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .padding(.all, size.width / 2)
                .foregroundStyle(foregroundStyle)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(foregroundStyle, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ImageButton(imageIcon: "plus") {

    }
}
