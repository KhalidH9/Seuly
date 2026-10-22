import Foundation

struct CompleteOnboardingPayload: Encodable {
    let requestID: UUID
    let displayName: String
    let currencyCode: String
    let accountName: String
    let accountKind: String
    let openingBalanceMinor: Int64
    let monthlyBudgetMinor: Int64?
    let monthlyBudgetCategoryName: String?
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case requestID = "p_request_id"
        case displayName = "p_display_name"
        case currencyCode = "p_currency_code"
        case accountName = "p_account_name"
        case accountKind = "p_account_kind"
        case openingBalanceMinor = "p_opening_balance_minor"
        case monthlyBudgetMinor = "p_monthly_budget_minor"
        case monthlyBudgetCategoryName = "p_monthly_budget_category_name"
        case localDate = "p_local_date"
    }
}

struct SaveAccountPayload: Encodable {
    let accountID: UUID
    let name: String
    let kind: String
    let openingBalanceMinor: Int64
    let institutionName: String?
    let iconKey: String
    let colorRole: String

    enum CodingKeys: String, CodingKey {
        case accountID = "p_account_id"
        case name = "p_name"
        case kind = "p_kind"
        case openingBalanceMinor = "p_opening_balance_minor"
        case institutionName = "p_institution_name"
        case iconKey = "p_icon_key"
        case colorRole = "p_color_role"
    }
}
