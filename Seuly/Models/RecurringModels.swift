import Foundation

enum RecurringCadence: String, CaseIterable, Codable, Identifiable, Sendable {
    case weekly
    case monthly
    case yearly

    var id: String { rawValue }
    var displayName: String {
        L10n.text("recurring.cadence.\(rawValue)", table: .data)
    }
}

enum RecurringStatus: String, Codable, Sendable {
    case active
    case paused
    case completed
}

struct RecurringRule: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var kind: TransactionKind
    var merchant: String
    var note: String
    var cadence: RecurringCadence
    var nextRunOn: LocalDate
    var status: RecurringStatus
    var legs: [RecurringLeg]

    var nextRunDate: Date {
        get { nextRunOn.date() }
        set { nextRunOn = LocalDate(date: newValue) }
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

    var categoryID: UUID? {
        legs.first { $0.categoryID != nil }?.categoryID
    }

    var signedAmountMinor: Int64 {
        kind == .income ? amountMinor : -amountMinor
    }
}

struct RecurringLeg: Identifiable, Equatable, Sendable {
    let id: UUID
    let accountID: UUID
    let categoryID: UUID?
    let amountMinor: Int64
}
