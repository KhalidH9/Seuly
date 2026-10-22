import Foundation

enum TransactionKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case expense
    case income
    case transfer

    var id: String { rawValue }
    var displayName: String {
        L10n.text("transaction.kind.\(rawValue)", table: .data)
    }
}

enum TransactionStatus: String, Codable, Sendable {
    case pending
    case posted
    case void
}

struct TransactionLeg: Identifiable, Equatable, Sendable {
    let id: UUID
    let transactionID: UUID
    let accountID: UUID
    let categoryID: UUID?
    let amountMinor: Int64
}

struct FinancialTransaction: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var kind: TransactionKind
    var status: TransactionStatus
    var effectiveOn: LocalDate
    var occurredAt: Date?
    var merchant: String
    var note: String
    var legs: [TransactionLeg]
    var createdAt: Date

    var effectiveDate: Date {
        get { effectiveOn.date() }
        set { effectiveOn = LocalDate(date: newValue) }
    }

    var amountMinor: Int64 {
        switch kind {
        case .income:
            legs.lazy.map { max($0.amountMinor, 0) }.sumClamped()
        case .expense:
            legs.lazy.map { min($0.amountMinor, 0) }
                .sumClamped().magnitudeClamped
        case .transfer:
            (legs.first { $0.amountMinor < 0 }?.amountMinor ?? 0)
                .magnitudeClamped
        }
    }

    var sourceAccountID: UUID? {
        legs.first { $0.amountMinor < 0 }?.accountID
    }

    var destinationAccountID: UUID? {
        legs.first { $0.amountMinor > 0 }?.accountID
    }

    var categoryID: UUID? {
        legs.first { $0.categoryID != nil }?.categoryID
    }

    var signedAmountMinor: Int64 {
        kind == .income ? amountMinor : -amountMinor
    }

    var displayAccountID: UUID? {
        kind == .income ? destinationAccountID : sourceAccountID
    }
}
