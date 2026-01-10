import SwiftUI

struct ThirdPartyButton: View {

    let logo: String
    let text: String
    var isSystemLogo: Bool = false

    var body: some View {
        AppButton(style: .secondary) {
            HStack {
                if isSystemLogo {
                    Image(systemName: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                } else {
                    Image(logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Text(text)
                    .font(UIStyleConstants.Typography.body.font)

                Spacer()
            }
        } action: {

        }
        .overlay {
            Rectangle()
                .stroke(lineWidth: 1)
        }
    }
}

#Preview {
    ThirdPartyButton(logo: "apple.logo", text: "Apple", isSystemLogo: true)
}
