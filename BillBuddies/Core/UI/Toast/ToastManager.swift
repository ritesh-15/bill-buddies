import Foundation
import Combine
import SwiftUI

enum ToastStyle {
    case info, success, error, warning

    var icon: String {
        switch self {
        case .info:
            "info.circle.fill"
        case .success:
            "checkmark.seal.fill"
        case .error:
            "x.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .info:
            Color.blue
        case .success:
            Color.green
        case .error:
            Color.red
        case .warning:
            Color.yellow
        }
    }
}

class ToastManager: ObservableObject {

    @Published var isShowing = false
    @Published var message = ""
    var style: ToastStyle = .info

    func show(message: String, style: ToastStyle = .info, duration: Double = 3.0) {
        self.message = message
        self.style = style

        withAnimation {
            isShowing = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            withAnimation {
                self?.isShowing = false
            }
        }
    }
}
