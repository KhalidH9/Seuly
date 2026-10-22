import Foundation

struct BudgetRow: Decodable {
    let id: UUID
    let userID: UUID
    let name: String
    let currencyCode: String
    let startsOn: String
    let endsOn: String
    let budgetLines: [BudgetLineRow]

    enum CodingKeys: String, CodingKey {
        case id, name
        case userID = "user_id"
        case currencyCode = "currency_code"
        case startsOn = "starts_on"
        case endsOn = "ends_on"
        case budgetLines = "budget_lines"
    }
}

struct BudgetLineRow: Decodable {
    let id: UUID
    let budgetID: UUID
    let categoryID: UUID
    let limitMinor: Int64

    enum CodingKeys: String, CodingKey {
        case id
        case budgetID = "budget_id"
        case categoryID = "category_id"
        case limitMinor = "limit_minor"
    }
}

struct GoalOverviewRow: Decodable {
    let id: UUID
    let userID: UUID
    let name: String
    let kind: String
    let currencyCode: String
    let targetMinor: Int64
    let targetOn: String?
    let status: String
    let iconKey: String?
    let colorRole: String?
    let progressMinor: Int64

    enum CodingKeys: String, CodingKey {
        case id, name, kind, status
        case userID = "user_id"
        case currencyCode = "currency_code"
        case targetMinor = "target_minor"
        case targetOn = "target_on"
        case iconKey = "icon_key"
        case colorRole = "color_role"
        case progressMinor = "progress_minor"
    }
}
