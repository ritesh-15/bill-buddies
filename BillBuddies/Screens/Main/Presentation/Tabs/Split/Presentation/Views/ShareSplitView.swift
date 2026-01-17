import SwiftUI

struct ShareSplitView: View {

    @EnvironmentObject var viewModel: CreateSplitViewModel

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("Split by shares")
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

                    if viewModel.selectedParticipantIDs.contains(participant.id) {
                        SplitShareField(share: $participant.share)
                    }
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

struct SplitShareField: View {

    @Binding var share: Int

    var body: some View {
        HStack {
            Button {
                share = max(0, share - 1)
            } label: {
                Image(systemName: "minus")
                    .frame(width: 32, height: 32)
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .background(UIStyleConstants.Colors.foreground.value.opacity(0.1))
                    .clipShape(Circle())
            }

            Text("\(share)")
                .font(UIStyleConstants.Typography.subHeading.font)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            Button {
                share = share + 1
            } label: {
                Image(systemName: "plus")
                    .frame(width: 32, height: 32)
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .background(UIStyleConstants.Colors.foreground.value.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    ShareSplitView()
        .environmentObject(CreateSplitViewModel())
}
