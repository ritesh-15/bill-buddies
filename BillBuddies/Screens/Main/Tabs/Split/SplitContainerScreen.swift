import SwiftUI

struct SplitContainerScreen: View {

    @StateObject var viewModel = CreateSplitViewModel()

    var body: some View {
        VStack {
            viewModel.currentComponent()
        }
    }
}

#Preview {
    SplitContainerScreen()
}
