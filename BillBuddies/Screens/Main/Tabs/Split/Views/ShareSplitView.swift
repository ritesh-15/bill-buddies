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

                    SplitShareField()
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

    var body: some View {
        HStack {
            Button {

            } label: {
                Image(systemName: "minus")
                    .frame(width: 32, height: 32)
                    .font(UIStyleConstants.Typography.body.font)
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    .background(UIStyleConstants.Colors.foreground.value.opacity(0.1))
                    .clipShape(Circle())
            }

            Text("2")
                .font(UIStyleConstants.Typography.subHeading.font)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value)

            Button {

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
