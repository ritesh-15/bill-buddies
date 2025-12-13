import Foundation
import Combine
import SwiftUI

class CreateSplitViewModel: ObservableObject {

    @Published var currentStep = 0

    @Published var amount: String = ""
    @Published var description: String = ""
    @Published var paymentDate: Date = Date()

    // Choose group
    @Published var showChooseGroupScreen = false
    @Published var groupNameSearchText: String = ""

    // TODO: Update this with model data later
    @Published var isGroupSelected: Bool = false

    lazy var steps: [AnyView] = [
        AnyView(CreateSplit(viewModel: self)),
        AnyView(ChooseGroupAndShare(viewModel: self))
    ]

    func nextStep() {
        if currentStep >= steps.count - 1 {
            return
        }

        currentStep += 1
    }

    func previousStep() {
        if currentStep == 0 {
            return
        }

        currentStep -= 1
    }

    func currentComponent() -> AnyView {
        return steps[currentStep]
    }
}
