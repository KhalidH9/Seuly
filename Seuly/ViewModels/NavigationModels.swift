import Foundation

enum MainTab: String, CaseIterable, Identifiable {
    case overview
    case activity
    case plan
    case insights
    case search

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview: localizedTitle("overview")
        case .activity: localizedTitle("activity")
        case .plan: localizedTitle("plan")
        case .insights: localizedTitle("insights")
        case .search: localizedTitle("search")
        }
    }

    private func localizedTitle(_ value: String) -> String {
        L10n.text("navigation.tab.\(value)", table: .data)
    }

    var systemImage: String {
        switch self {
        case .overview: "house.fill"
        case .activity: "list.bullet.rectangle.fill"
        case .plan: "target"
        case .insights: "chart.line.uptrend.xyaxis"
        case .search: "magnifyingglass"
        }
    }
}

enum AppSheetRoute: Identifiable {
    case transaction(TransactionKind, FinancialTransaction?)
    case account(FinancialAccount?)
    case budget
    case goal
    case goalContribution(SavingsGoal)
    case recurring
    case settings

    var id: String {
        switch self {
        case .transaction(let kind, let transaction):
            "transaction-\(kind.rawValue)-\(transaction?.id.uuidString ?? "new")"
        case .account(let account):
            "account-\(account?.id.uuidString ?? "new")"
        case .budget: "budget"
        case .goal: "goal"
        case .goalContribution(let goal): "contribution-\(goal.id)"
        case .recurring: "recurring"
        case .settings: "settings"
        }
    }
}
