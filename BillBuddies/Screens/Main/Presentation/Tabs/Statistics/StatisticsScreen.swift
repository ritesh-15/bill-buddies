import SwiftUI
import Charts

// TODO: Move this model to its correct folder
// Dummy expense data model
struct Expense: Identifiable {
    var id = UUID()
    var category: String
    var amount: Double
    var date: Date
}

// TODO: Replace this dummy data once the api is ready
// Dummy data for several months and categories
let expenseDummyData: [Expense] = [
    Expense(category: "Groceries", amount: 230, date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 10))!),
    Expense(category: "Rent", amount: 1200, date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!),
    Expense(category: "Utilities", amount: 150, date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!),
    Expense(category: "Dining", amount: 100, date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 20))!),
    Expense(category: "Groceries", amount: 250, date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 12))!),
    Expense(category: "Rent", amount: 1200, date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 1))!),
    Expense(category: "Utilities", amount: 160, date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 18))!),
    Expense(category: "Dining", amount: 120, date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 24))!),
    Expense(category: "Groceries", amount: 200, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 9))!),
    Expense(category: "Rent", amount: 1200, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!),
    Expense(category: "Utilities", amount: 165, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 16))!),
    Expense(category: "Dining", amount: 140, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 22))!),
    // Add more if desired
]

// Helper to format month names
extension Date {
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}

struct StatisticsScreen: View {

    @State private var selectedMonth: String
    private let availableMonths: [String]

    // Prepare available months list from data
    init() {
        let months = Set(expenseDummyData.map { Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: $0.date))! })
        let sortedMonths = months.sorted()
        self.availableMonths = sortedMonths.map { $0.monthYearString() }
        _selectedMonth = State(initialValue: self.availableMonths.last ?? "")
    }

    var body: some View {
        VStack {
            TopNavBar(selectedMonth: $selectedMonth, months: availableMonths)

            ScrollView {
                if let filteredAndSummed = expensesByCategoryForSelectedMonth() {
                    if filteredAndSummed.isEmpty {
                        Text("No expenses for this month")
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                            .padding()
                    } else {
                        // TODO: For now keeping bar chart as both the chart on the screen give screen freez.
                        BarChartView(filteredAndSummed: filteredAndSummed)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, UIStyleConstants.Spacing.md.rawValue)
        .background(UIStyleConstants.Colors.background.value)
    }

    // Group and sum expenses by category for the selected month
    private func expensesByCategoryForSelectedMonth() -> [(category: String, total: Double)]? {
        guard let monthDate = availableMonths
                .first(where: { $0 == selectedMonth })
                .flatMap({ monthString in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM yyyy"
                    return formatter.date(from: monthString)
                }) else {
            return nil
        }

        let comps = Calendar.current.dateComponents([.year, .month], from: monthDate)
        let filtered = expenseDummyData.filter {
            let c = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return c.year == comps.year && c.month == comps.month
        }

        let grouped = Dictionary(grouping: filtered, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }

        return grouped.map { (category: $0.key, total: $0.value) }
            .sorted { $0.category < $1.category }
    }
}

fileprivate struct BarChartView: View {

    var filteredAndSummed: [(category: String, total: Double)]

    var body: some View {
        // Bar Chart
        Text("Expenses by Category")
            .font(UIStyleConstants.Typography.body.font)
            .bold()
            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, UIStyleConstants.Spacing.sm.rawValue)

        Chart {
            ForEach(filteredAndSummed, id: \.category) { (category, total) in
                BarMark(
                    x: .value("Category", category),
                    y: .value("Total", total)
                )
                .foregroundStyle(UIStyleConstants.Colors.brandPrimary.value)
            }
        }
        .frame(height: 320)
        .padding(.bottom, UIStyleConstants.Spacing.lg.rawValue)
    }
}

fileprivate struct PieChartView: View {
    // Color palette for pie chart slices
    private let colorPalette: [Color] = [
        .blue,
        .green,
        .orange,
        .purple,
        .pink,
        .mint
    ]

    var filteredAndSummed: [(category: String, total: Double)]

    private var uniqueDomain: [String] {
        // Stable, unique, sorted domain
        Array(Set(filteredAndSummed.map { $0.category })).sorted()
    }

    private var colorRange: [Color] {
        // Ensure range count matches domain count (repeat colors if needed)
        let count = uniqueDomain.count
        guard count > 0 else { return [] }
        return (0..<count).map { index in
            colorPalette[index % colorPalette.count]
        }
    }

    var body: some View {
        // Pie Chart
        Text("Category Share (Pie Chart)")
            .font(UIStyleConstants.Typography.body.font)
            .bold()
            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, UIStyleConstants.Spacing.sm.rawValue)

        Chart {
            let totalSum = filteredAndSummed.reduce(0) { $0 + $1.total }
            ForEach(filteredAndSummed.indices, id: \.self) { index in
                let category = filteredAndSummed[index].category
                let total = filteredAndSummed[index].total
                SectorMark(
                    angle: .value("Amount", total),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Category", category))
                .annotation(position: .overlay, alignment: .center) {
                    if totalSum > 0, total / totalSum > 0.10 {
                        Text(category)
                            .font(UIStyleConstants.Typography.caption.font)
                            .foregroundStyle(UIStyleConstants.Colors.foreground.value)
                    }
                }
            }
        }
        .chartForegroundStyleScale(
            domain: uniqueDomain,
            range: colorRange
        )
        .frame(height: 300)
        .padding(.bottom, UIStyleConstants.Spacing.lg.rawValue)
    }
}

fileprivate struct TopNavBar: View {
    @EnvironmentObject var router: NavigationRouter
    @Binding var selectedMonth: String
    let months: [String]

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIStyleConstants.Spacing.s.rawValue) {
                Text("Statistics")
                    .font(UIStyleConstants.Typography.subHeading.font)
                    .bold()
                    .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                HStack(alignment: .center) {
                    Text("Track your spending here")
                        .font(UIStyleConstants.Typography.caption.font)
                        .fontWeight(.light)
                        .foregroundStyle(UIStyleConstants.Colors.foreground.value)

                    Spacer()

                    Picker("Month", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { option in
                            Text(option)
                                .font(UIStyleConstants.Typography.body.font)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(UIStyleConstants.Colors.foreground.value)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    StatisticsScreen()
        .environmentObject(NavigationRouter())
}
