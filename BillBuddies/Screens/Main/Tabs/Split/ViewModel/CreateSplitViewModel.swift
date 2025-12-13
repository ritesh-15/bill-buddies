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

    // New: Track the selected split method
    @Published var selectedSplitMethod: SplitMethod = .equally

    // Participants for splitting
    @Published var participants: [Participant] = [
        Participant(name: "Ritesh Khore"),
        Participant(name: "Alex Smith"),
        Participant(name: "Jamie Doe"),
        Participant(name: "Kaustubh Gade"),
        Participant(name: "Ronit Khalate"),
        Participant(name: "Yash Bankar"),
        Participant(name: "Pratik Ghadge"),
        Participant(name: "Aditya Jadhav"),
    ]
    @Published var selectedParticipantIDs: Set<UUID> = []

    lazy var steps: [AnyView] = [
        AnyView(CreateSplit(viewModel: self)),
        AnyView(ChooseGroupAndShare(viewModel: self))
    ]

    func toggleParticipantSelection(participant: Participant) {
        if selectedParticipantIDs.contains(participant.id) {
            selectedParticipantIDs.remove(participant.id)
        } else {
            selectedParticipantIDs.insert(participant.id)
        }
    }

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
