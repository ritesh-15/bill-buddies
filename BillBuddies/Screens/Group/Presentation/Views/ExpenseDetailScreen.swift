import SwiftUI

struct ExpenseDetailScreen: View {

    var expenseId: String

    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel: ExpenseDetailsViewModel = ExpenseDetailsViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: UIStyleConstants.Spacing.md.rawValue) {
                    Text("\(viewModel.expenseDetail?.description ?? "")")
                        .font(UIStyleConstants.Typography.heading2.font)
                        .multilineTextAlignment(.center)

                    Avatar()

                    Text("\(viewModel.expenseDetail?.paidBy.username ?? "") requested Rs \(formatTwoDecimals(viewModel.expenseDetail?.amount))")
                        .font(UIStyleConstants.Typography.body.font)
                }

                Divider()

                HStack(alignment: .center) {
                    Text("0 of \(viewModel.expenseDetail?.splitShares.count ?? 0) paid")
                        .font(UIStyleConstants.Typography.body.font)
                        .bold()

                    Spacer()

                    // Rounded to 2 decimal places
                    Text("Total: Rs \(formatTwoDecimals(viewModel.expenseDetail?.amount))")
                        .font(UIStyleConstants.Typography.body.font)
                        .fontWeight(.light)
                }

                LazyVStack {
                    ForEach(viewModel.expenseDetail?.splitShares ?? []) { expense in
                        HStack {
                            HStack {
                                Avatar(size: 42)

                                VStack(alignment: .leading) {
                                    Text("\(expense.ownedBy.username)")
                                        .font(UIStyleConstants.Typography.body.font)

                                    Text("Sent this request")
                                        .font(UIStyleConstants.Typography.body.font)
                                        .fontWeight(.light)
                                }
                            }

                            Spacer()

                            Text("Rs \(formatTwoDecimals(expense.amount))")
                                .font(UIStyleConstants.Typography.subHeading.font)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
        .task {
            viewModel.configure(router: router)
            await viewModel.fetchExpenseDetails(expenseId: expenseId)
        }
        .refreshable {
            await viewModel.fetchExpenseDetails(expenseId: expenseId, fetchForce: true)
        }
    }
}

extension ExpenseDetailScreen {
    // MARK: - Formatting helpers

    // For Int totals (e.g., 123 -> "123.00")
    private func formatTwoDecimals(_ value: Int?) -> String {
        let double = Double(value ?? 0)
        return double.formatted(.number.precision(.fractionLength(2)))
    }

    // For Double split amounts (e.g., 12.3 -> "12.30")
    private func formatTwoDecimals(_ value: Double?) -> String {
        let double = value ?? 0
        return double.formatted(.number.precision(.fractionLength(2)))
    }
}

#Preview {
    ExpenseDetailScreen(expenseId: "")
}
