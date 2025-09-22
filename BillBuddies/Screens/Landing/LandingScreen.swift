import SwiftUI

struct LandingScreen: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { proxy in
                let screenHeight = proxy.size.height

                VStack {
                    Image("landing_page_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 350)
                        .padding(.bottom, UIStyleConstants.Spacing.xxxl.rawValue)

                    VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.lg.rawValue) {
                        Text("Splits bills not friendships")
                            .foregroundStyle(.black)
                            .font(UIStyleConstants.Typography.heading1.font)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)

                        Text("We help group of people to split expenses and bills when they are sharing cost of particular event or activity")
                            .foregroundStyle(.black)
                            .font(UIStyleConstants.Typography.body.font)
                            .fixedSize(horizontal: false, vertical: true)

                        AppButton(style: .secondary) {
                            Text("Sign up")
                                .bold()
                        } action: {

                        }

                        HStack(alignment: .center) {
                            Text("Already have an account ?")
                                .font(UIStyleConstants.Typography.caption.font)
                                .foregroundStyle(.black)

                            AppButton(style: .link) {
                                Text("Sign in")
                                    .bold()
                            } action: {

                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(minHeight: screenHeight)
                .frame(maxWidth: .infinity)
            }
            .frame(height: UIScreen.main.bounds.height)
        }
        .frame(maxWidth: .infinity)
        .background(UIStyleConstants.Colors.brandPrimary.value)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    LandingScreen()
}
