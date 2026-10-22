import Foundation

struct CreateRecurringPayload: Encodable {
    let ruleID: UUID
    let kind: String
    let amountMinor: Int64
    let sourceAccountID: UUID
    let destinationAccountID: UUID?
    let categoryID: UUID?
    let merchant: String
    let memo: String
    let cadence: String
    let nextRunOn: String
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case ruleID = "p_rule_id"
        case kind = "p_kind"
        case amountMinor = "p_amount_minor"
        case sourceAccountID = "p_source_account_id"
        case destinationAccountID = "p_destination_account_id"
        case categoryID = "p_category_id"
        case merchant = "p_merchant"
        case memo = "p_memo"
        case cadence = "p_cadence"
        case nextRunOn = "p_next_run_on"
        case localDate = "p_local_date"
    }
}
