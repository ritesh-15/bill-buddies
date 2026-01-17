import SwiftUI

struct PercentSplitView: View {

    @EnvironmentObject var viewModel: CreateSplitViewModel

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("Split by percent")
                .font(UIStyleConstants.Typography.subHeading.font)
                .padding(.bottom, UIStyleConstants.Spacing.sm.rawValue)

            ForEach($viewModel.participants) { $participant in
                HStack(alignment: .center) {
                    Button(action: {
                        viewModel.toggleParticipantSelection(participant: participant)
                    }) {
                        CheckBox(isChecked: viewModel.selectedParticipantIDs.contains(participant.id))
                    }
                    Avatar(url: participant.avatarUrl, size: 42, seed: participant.avatarSeed)
                    Text(participant.name)
                        .font(UIStyleConstants.Typography.body.font)
                        .bold()
                        .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                    Spacer()

                    SplitAmountInputField(amount: $participant.percentage, inputType: .percentage, onFocusChange: { isFocused in
                        if isFocused && !viewModel.selectedParticipantIDs.contains(participant.id) {
                            viewModel.toggleParticipantSelection(participant: participant)
                        }
                    })
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleParticipantSelection(participant: participant)
                }
            }

            if viewModel.participants.isEmpty {
                Text("No participants to display.")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    PercentSplitView()
        .environmentObject(CreateSplitViewModel())
}
