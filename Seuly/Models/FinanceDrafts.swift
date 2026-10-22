import Foundation

struct AccountDraft: Equatable, Sendable {
    var id: UUID
    var name: String
    var kind: AccountKind
    var openingBalanceMinor: Int64
    var institutionName: String
    var iconKey: String
    var colorRole: ColorRole

    var normalizedInstitutionName: String? {
        let value = institutionName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        return value.isEmpty ? nil : value
    }
}

struct TransactionDraft: Equatable, Sendable {
    var id: UUID
    var kind: TransactionKind
    var amountMinor: Int64
    var sourceAccountID: UUID?
    var destinationAccountID: UUID?
    var categoryID: UUID?
    var merchant: String
    var note: String
    var effectiveDate: Date
    var localDate: LocalDate
}

struct BudgetLineDraft: Equatable, Sendable {
    var budgetID: UUID?
    var categoryID: UUID
    var limitMinor: Int64
    var localDate: LocalDate
}

struct GoalDraft: Equatable, Sendable {
    var id: UUID
    var name: String
    var kind: GoalKind
    var targetMinor: Int64
    var targetDate: Date?
    var iconKey: String
    var colorRole: ColorRole
    var localDate: LocalDate
}

struct GoalContributionDraft: Equatable, Sendable {
    var id: UUID
    var goalID: UUID
    var amountMinor: Int64
    var note: String
    var localDate: LocalDate
}

struct RecurringRuleDraft: Equatable, Sendable {
    var id: UUID
    var kind: TransactionKind
    var amountMinor: Int64
    var sourceAccountID: UUID
    var destinationAccountID: UUID?
    var categoryID: UUID?
    var merchant: String
    var note: String
    var cadence: RecurringCadence
    var nextRunDate: Date
    var localDate: LocalDate
}

struct OnboardingDraft: Equatable, Sendable {
    var id: UUID
    var displayName: String
    var currencyCode: String
    var accountName: String
    var accountKind: AccountKind
    var openingBalanceMinor: Int64
    var monthlyBudgetMinor: Int64?
    var monthlyBudgetCategoryName: String?
    var localDate: LocalDate
}
