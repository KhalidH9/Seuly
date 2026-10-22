import Foundation

struct RecurringRow: Decodable {
    let id: UUID
    let userID: UUID
    let transactionKind: String
    let merchant: String?
    let memo: String?
    let cadence: String
    let nextRunOn: String
    let status: String
    let recurringRuleLegs: [RecurringLegRow]

    enum CodingKeys: String, CodingKey {
        case id, merchant, memo, cadence, status
        case userID = "user_id"
        case transactionKind = "transaction_kind"
        case nextRunOn = "next_run_on"
        case recurringRuleLegs = "recurring_rule_legs"
    }
}

struct RecurringLegRow: Decodable {
    let id: UUID
    let accountID: UUID
    let categoryID: UUID?
    let amountMinor: Int64

    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "account_id"
        case categoryID = "category_id"
        case amountMinor = "amount_minor"
    }
}
