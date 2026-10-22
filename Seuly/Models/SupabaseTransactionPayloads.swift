import Foundation

struct SaveTransactionPayload: Encodable {
    let transactionID: UUID
    let kind: String
    let effectiveOn: String
    let merchant: String
    let memo: String
    let amountMinor: Int64
    let sourceAccountID: UUID?
    let destinationAccountID: UUID?
    let categoryID: UUID?
    let localDate: String

    enum CodingKeys: String, CodingKey {
        case transactionID = "p_transaction_id"
        case kind = "p_kind"
        case effectiveOn = "p_effective_on"
        case merchant = "p_merchant"
        case memo = "p_memo"
        case amountMinor = "p_amount_minor"
        case sourceAccountID = "p_source_account_id"
        case destinationAccountID = "p_destination_account_id"
        case categoryID = "p_category_id"
        case localDate = "p_local_date"
    }
}

struct VoidTransactionPayload: Encodable {
    let transactionID: UUID

    enum CodingKeys: String, CodingKey {
        case transactionID = "p_transaction_id"
    }
}
