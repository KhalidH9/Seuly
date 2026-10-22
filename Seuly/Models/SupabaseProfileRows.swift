import Foundation

struct ProfileRow: Decodable {
    let id: UUID
    let displayName: String
    let currencyCode: String
    let onboardingCompleted: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case currencyCode = "currency_code"
        case onboardingCompleted = "onboarding_completed"
        case createdAt = "created_at"
    }
}

struct AccountRow: Decodable {
    let id: UUID
    let userID: UUID
    let name: String
    let kind: String
    let currencyCode: String
    let openingBalanceMinor: Int64
    let balanceMinor: Int64
    let institutionName: String?
    let iconKey: String?
    let colorRole: String?
    let includeInNetWorth: Bool
    let sortOrder: Int
    let archivedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, kind
        case userID = "user_id"
        case currencyCode = "currency_code"
        case openingBalanceMinor = "opening_balance_minor"
        case balanceMinor = "balance_minor"
        case institutionName = "institution_name"
        case iconKey = "icon_key"
        case colorRole = "color_role"
        case includeInNetWorth = "include_in_net_worth"
        case sortOrder = "sort_order"
        case archivedAt = "archived_at"
    }
}

struct CategoryRow: Decodable {
    let id: UUID
    let userID: UUID
    let parentID: UUID?
    let kind: String
    let name: String
    let iconKey: String?
    let colorRole: String?
    let sortOrder: Int
    let archivedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, kind, name
        case userID = "user_id"
        case parentID = "parent_id"
        case iconKey = "icon_key"
        case colorRole = "color_role"
        case sortOrder = "sort_order"
        case archivedAt = "archived_at"
    }
}
