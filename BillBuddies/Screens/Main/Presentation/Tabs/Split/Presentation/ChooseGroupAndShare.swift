import SwiftUI

enum SplitMethod: CaseIterable {
    case equally, amount, percent, share

    var label: String {
        switch self {
        case .equally: return "Equally"
        case .amount: return "Amount"
        case .percent: return "Percent"
        case .share: return "Share"
        }
    }

    var systemImage: String {
        switch self {
        case .equally: return "person.2"
        case .amount: return "indianrupeesign"
        case .percent: return "percent"
        case .share: return "chart.pie"
        }
    }
}

// MARK: - Participant Model

struct Participant: Identifiable, Hashable {
    var id: String
    var name: String
    var avatarSeed: String
    var avatarUrl: String
    var amount: String

    init(id: String, name: String, avatarSeed: String = UUID().uuidString, avatarUrl: String = "https://api.dicebear.com/9.x/adventurer-neutral/png") {
        self.id = id
        self.name = name
        self.avatarSeed = avatarSeed
        self.avatarUrl = avatarUrl
        self.amount = ""
    }
}

struct ChooseGroupAndShare: View {

    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: CreateSplitViewModel

    var body: some View {
        VStack {
            FullScreenSheetTopBar(
                title: "Split transaction",
                imageIcon: "chevron.backward",
                overrideBackAction: {
                    viewModel.previousStep()
                })

            ScrollView {
                VStack(spacing: UIStyleConstants.Spacing.md.rawValue) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select a group")
                            .font(UIStyleConstants.Typography.body.font)
                            .fontWeight(.semibold)
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                        if let group = viewModel.selectedGroup {
                            GroupRow(groupId: group.documentId, groupName: group.name)
                        }
                    }
                    .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
                    .padding(.vertical, UIStyleConstants.Spacing.lg.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        Rectangle()
                            .stroke(.white, lineWidth: 1)
                    }
                    .onTapGesture {
                        viewModel.showChooseGroupScreen = true
                    }

                    // Split share selection row
                    HStack {
                        ForEach(SplitMethod.allCases, id: \.self) { method in
                            SplitBy(
                                imageIcon: method.systemImage,
                                title: method.label,
                                isSelected: viewModel.selectedSplitMethod == method
                            )
                            .onTapGesture {
                                viewModel.selectedSplitMethod = method
                            }
                            if method != SplitMethod.allCases.last {
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
                    .padding(.vertical, UIStyleConstants.Spacing.lg.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        Rectangle()
                            .stroke(UIStyleConstants.Colors.foreground.value, lineWidth: 1)
                    }

                    // Render the appropriate view below based on selection
                    Group {
                        switch viewModel.selectedSplitMethod {
                        case .equally:
                            EquallySplitView()
                        case .amount:
                            AmountSplitView()
                        case .percent:
                            PercentSplitView()
                        case .share:
                            ShareSplitView()
                        }
                    }
                    .environmentObject(viewModel)
                }
                .padding(.top, UIStyleConstants.Spacing.lg.rawValue)
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .safeAreaInset(edge: .bottom) {
            Group {
                AppButton(style: .primary) {
                    Text("Split")
                        .font(UIStyleConstants.Typography.body.font.bold())
                } action: {

                }
                .padding(.vertical, UIStyleConstants.Spacing.s.rawValue)
                .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
            }
            .background(UIStyleConstants.Colors.background.value)
        }
        .fullScreenCover(isPresented: $viewModel.showChooseGroupScreen) {
            SearchAndSelectGroupScreen()
                .environmentObject(viewModel)
        }
        .environmentObject(viewModel)
    }
}

fileprivate struct SplitBy: View {

    let imageIcon: String
    let title: String
    var isSelected: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
            Image(systemName: imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
                .foregroundStyle(
                    isSelected
                    ? UIStyleConstants.Colors.brandPrimary.value
                    : UIStyleConstants.Colors.foreground.value.opacity(0.9)
                )

            Text(title)
                .font(UIStyleConstants.Typography.body.font)
                .bold()
                .foregroundStyle(
                    isSelected
                    ? UIStyleConstants.Colors.brandPrimary.value
                    : UIStyleConstants.Colors.foreground.value.opacity(0.9)
                )
        }
        .padding(6)
        .background(
            isSelected
            ? UIStyleConstants.Colors.brandPrimary.value.opacity(0.12)
            : Color.clear
        )
        .foregroundStyle(
            isSelected
            ? UIStyleConstants.Colors.brandPrimary.value.opacity(0.12)
            : UIStyleConstants.Colors.foreground.value.opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let viewModel = CreateSplitViewModel()
    viewModel.participants = [
        Participant(id: "d", name: "Test")
    ]
    viewModel.selectedParticipantIDs = [viewModel.participants.first!.id]
    return ChooseGroupAndShare(viewModel: viewModel)
}

