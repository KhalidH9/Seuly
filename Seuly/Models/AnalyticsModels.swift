import Foundation

struct AccountBalance: Identifiable, Equatable, Sendable {
    let account: FinancialAccount
    let balanceMinor: Int64
    var id: UUID { account.id }
}

struct BudgetProgress: Identifiable, Equatable, Sendable {
    let line: BudgetLine
    let category: FinanceCategory
    let spentMinor: Int64
    var id: UUID { line.id }
    var remainingMinor: Int64 {
        line.limitMinor.subtractingClamped(spentMinor)
    }
    var fraction: Double {
        guard line.limitMinor > 0 else { return 0 }
        return Double(spentMinor) / Double(line.limitMinor)
    }
}

enum MoneyPulse: Equatable, Sendable {
    case calm(reason: String)
    case watch(reason: String)
    case tight(reason: String)

    var title: String {
        switch self {
        case .calm: L10n.text("money_pulse.calm", table: .data)
        case .watch: L10n.text("money_pulse.watch", table: .data)
        case .tight: L10n.text("money_pulse.tight", table: .data)
        }
    }

    var reason: String {
        switch self {
        case .calm(let reason), .watch(let reason), .tight(let reason): reason
        }
    }
}

struct CategorySpend: Identifiable, Equatable, Sendable {
    let category: FinanceCategory
    let amountMinor: Int64
    var id: UUID { category.id }
}

struct DailySpend: Identifiable, Equatable, Sendable {
    let date: Date
    let amountMinor: Int64
    var id: Date { date }
}

struct RecurringOccurrence: Identifiable, Equatable, Sendable {
    struct ID: Hashable, Sendable {
        let ruleID: UUID
        let dueDate: Date
    }

    let rule: RecurringRule
    let dueDate: Date
    var id: ID { ID(ruleID: rule.id, dueDate: dueDate) }
}

struct TransactionDayGroup: Identifiable {
    let date: Date
    let transactions: [FinancialTransaction]
    var id: Date { date }
}

struct BudgetOverview {
    let progress: [BudgetProgress]
    let limitMinor: Int64
    let utilization: Double
    var categoryCount: Int { progress.count }
}
