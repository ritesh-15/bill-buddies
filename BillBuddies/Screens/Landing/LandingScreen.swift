import SwiftUI

struct LandingScreen: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { proxy in
                let screenHeight = proxy.size.height

                VStack(spacing: 0) {
                    Image("landing_page_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 350)
                        .padding(.bottom, 53)

                    VStack(alignment: .leading, spacing: 22) {
                        Text("Splits bills not friendships")
                            .foregroundStyle(.black)
                            .font(.custom("PlaypenSansThai-Bold", size: 42))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)

                        Text("We help group of people to split expenses and bills when they are sharing cost of particular event or activity")
                            .foregroundStyle(.black)
                            .font(.custom("PlaypenSansThai-Regular", size: 16))
                            .fixedSize(horizontal: false, vertical: true)

                        Button {
                            // Sign up action
                        } label: {
                            Text("Sign up")
                                .font(.custom("PlaypenSansThai-Bold", size: 16))
                                .frame(maxWidth: .infinity)
                                .padding(.all, 18)
                                .background(.black)
                                .foregroundStyle(.white)
                        }

                        HStack(alignment: .center) {
                            Text("Already have an account ?")
                                .font(.custom("PlaypenSansThai-Regular", size: 14))
                                .foregroundStyle(.black)

                            Button {
                                // Sign in action
                            } label: {
                                Text("Sign In")
                                    .font(.custom("PlaypenSansThai-Bold", size: 14))
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
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
        .background(.brandPrimary)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    LandingScreen()
}
