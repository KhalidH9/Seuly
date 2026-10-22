import Foundation

struct SaveBudgetLinePayload: Encodable {
    let budgetID: UUID?
    let categoryID: UUID
    let limitMinor: Int64
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case budgetID = "p_budget_id"
        case categoryID = "p_category_id"
        case limitMinor = "p_limit_minor"
        case localDate = "p_local_date"
    }
}

struct CreateGoalPayload: Encodable {
    let goalID: UUID
    let name: String
    let kind: String
    let targetMinor: Int64
    let targetOn: String?
    let iconKey: String
    let colorRole: String
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case goalID = "p_goal_id"
        case name = "p_name"
        case kind = "p_kind"
        case targetMinor = "p_target_minor"
        case targetOn = "p_target_on"
        case iconKey = "p_icon_key"
        case colorRole = "p_color_role"
        case localDate = "p_local_date"
    }
}

struct GoalContributionPayload: Encodable {
    let eventID: UUID
    let goalID: UUID
    let amountMinor: Int64
    let note: String
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case eventID = "p_event_id"
        case goalID = "p_goal_id"
        case amountMinor = "p_amount_minor"
        case note = "p_note"
        case localDate = "p_local_date"
    }
}
