import SwiftUI

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
                VStack(spacing: UIStyleConstants.Spacing.xxl.rawValue) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select a group")
                            .font(UIStyleConstants.Typography.body.font)
                            .fontWeight(.semibold)
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                        if viewModel.isGroupSelected {
                            GroupRow()
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

                    // Split share
                    HStack {
                        SplitBy(imageIcon: "person.2", title: "Equally")

                        Spacer()

                        SplitBy(imageIcon: "indianrupeesign", title: "Amount")

                        Spacer()

                        SplitBy(imageIcon: "percent", title: "Percent")

                        Spacer()

                        SplitBy(imageIcon: "chart.pie", title: "Share")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
                    .padding(.vertical, UIStyleConstants.Spacing.lg.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        Rectangle()
                            .stroke(UIStyleConstants.Colors.foreground.value, lineWidth: 1)
                    }

                    LazyVStack {
                        ForEach(1..<8) { _ in
                            HStack(alignment: .center) {
                                HStack(alignment: .center) {
                                    Avatar(size: 42)

                                    Text("Ritesh Khore")
                                        .font(UIStyleConstants.Typography.body.font)
                                        .bold()
                                        .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                                }

                                Spacer()

                                Text("₹ 400")
                                    .font(UIStyleConstants.Typography.subHeading.font)
                                    .bold()
                                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                            }
                        }
                    }
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

    var body: some View {
        VStack(alignment: .center, spacing: UIStyleConstants.Spacing.s.rawValue) {
            Image(systemName: imageIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
                .foregroundStyle(UIStyleConstants.Colors.foreground.value.opacity(0.9))

            Text(title)
                .font(UIStyleConstants.Typography.body.font)
                .bold()
                .foregroundStyle(UIStyleConstants.Colors.foreground.value.opacity(0.9))
        }
    }
}

#Preview {
    ChooseGroupAndShare(viewModel: CreateSplitViewModel())
}
