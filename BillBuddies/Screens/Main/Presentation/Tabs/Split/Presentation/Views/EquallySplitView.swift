import SwiftUI

struct EquallySplitView: View {

    @EnvironmentObject var viewModel: CreateSplitViewModel

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("Split evenly")
                .font(UIStyleConstants.Typography.subHeading.font)
                .padding(.bottom, UIStyleConstants.Spacing.sm.rawValue)

            ForEach(viewModel.participants) { participant in
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

                    // Format amount to upto 2 decimals after
                    let formated = String(format: "%.2f", Double(truncating: participant.amount as NSNumber))
                    Text("₹ \(formated)")
                        .font(UIStyleConstants.Typography.subHeading.font)
                        .bold()
                        .foregroundStyle(UIStyleConstants.Colors.foreground.value)
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
    EquallySplitView()
        .environmentObject(CreateSplitViewModel())
}
