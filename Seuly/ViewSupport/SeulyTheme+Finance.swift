import SwiftUI

/// Maps domain semantics onto palette tokens. One label token per family
/// serves both page backgrounds and soft chips because every token adapts.
extension SeulyTheme {
    func color(for role: ColorRole) -> Color {
        switch role {
        case .income: income
        case .expense: expense
        case .savings: savings
        case .investment: investment
        case .debt: debt
        case .transfer: transfer
        case .information: information
        case .warning: warning
        case .teal: brandPrimary
        case .neutral: neutral
        }
    }

    func softColor(for role: ColorRole) -> Color {
        switch role {
        case .income: incomeLight
        case .expense: expenseLight
        case .savings: savingsLight
        case .investment: investmentLight
        case .debt: debtLight
        case .transfer: transferLight
        case .information: informationBackground
        case .warning: warningBackground
        case .teal: brandPrimarySoft
        case .neutral: neutralBackground
        }
    }

    func color(for kind: TransactionKind) -> Color {
        switch kind {
        case .expense: expense
        case .income: income
        case .transfer: transfer
        }
    }

    func softColor(for kind: TransactionKind) -> Color {
        switch kind {
        case .expense: expenseLight
        case .income: incomeLight
        case .transfer: transferLight
        }
    }

    func textColor(for kind: TransactionKind) -> Color {
        textColorOnSoftBackground(for: kind)
    }

    func textColorOnSoftBackground(for kind: TransactionKind) -> Color {
        switch kind {
        case .expense: expenseText
        case .income: incomeText
        case .transfer: transferText
        }
    }

    func color(for pulse: MoneyPulse) -> Color {
        switch pulse {
        case .calm: success
        case .watch: warning
        case .tight: expense
        }
    }

    func softColor(for pulse: MoneyPulse) -> Color {
        switch pulse {
        case .calm: successBackground
        case .watch: warningBackground
        case .tight: errorBackground
        }
    }

    func textColor(for pulse: MoneyPulse) -> Color {
        switch pulse {
        case .calm: successText
        case .watch: warningText
        case .tight: errorText
        }
    }
}
