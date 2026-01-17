import Foundation

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
