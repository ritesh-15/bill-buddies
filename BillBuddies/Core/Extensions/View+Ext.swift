import SwiftUI

extension View {
    func toast(isPresented: Binding<Bool>, message: String, icon: String, iconColor: Color, duration: Double = 3.0) -> some View {
        self.modifier(
            ToastModifier(
                isPresented: isPresented,
                message: message,
                icon: icon,
                iconColor: iconColor,
                duration: duration)
        )
    }
}
