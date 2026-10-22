import Foundation

struct TransactionCursor {
    let createdAt: String
    let id: UUID
}

struct TransactionRecord: Decodable {
    let id: UUID
    let userID: UUID
    let kind: String
    let status: String
    let effectiveOn: String
    let occurredAt: String?
    let merchant: String?
    let memo: String?
    let createdAt: String
    let transactionLegs: [TransactionLegRow]

    enum CodingKeys: String, CodingKey {
        case id, kind, status, merchant, memo
        case userID = "user_id"
        case effectiveOn = "effective_on"
        case occurredAt = "occurred_at"
        case createdAt = "created_at"
        case transactionLegs = "transaction_legs"
    }
}

struct TransactionLegRow: Decodable {
    let id: UUID
    let transactionID: UUID
    let accountID: UUID
    let categoryID: UUID?
    let amountMinor: Int64

    enum CodingKeys: String, CodingKey {
        case id
        case transactionID = "transaction_id"
        case accountID = "account_id"
        case categoryID = "category_id"
        case amountMinor = "amount_minor"
    }
}
