import Foundation

enum GoalKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case savings
    case debt
    case investment
    case other

    var id: String { rawValue }
    var displayName: String {
        L10n.text("goal.kind.\(rawValue)", table: .data)
    }
}

enum GoalStatus: String, Codable, Sendable {
    case active
    case paused
    case completed
    case cancelled
}

struct SavingsGoal: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var name: String
    var kind: GoalKind
    var currencyCode: String
    var targetMinor: Int64
    var targetOn: LocalDate?
    var status: GoalStatus
    var iconKey: String
    var colorRole: ColorRole
    var progressMinor: Int64

    var targetDate: Date? {
        get { targetOn?.date() }
        set { targetOn = newValue.map { LocalDate(date: $0) } }
    }

    var progress: Double {
        guard targetMinor > 0 else { return 0 }
        return min(Double(progressMinor) / Double(targetMinor), 1)
    }
}
