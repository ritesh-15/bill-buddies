import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var isPresented: Bool
    let message: String
    let icon: String
    let iconColor: Color
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    // Make the toast span the full available width
                    ToastView(message: message, icon: icon, iconColor: iconColor)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: []) // keep within safe area; change to .bottom for edge-to-edge if desired
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}
