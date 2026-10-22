import Foundation

struct CurrencyRow: Decodable {
    let code: String
    let name: String
    let symbol: String
    let minorUnit: Int
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case code, name, symbol
        case minorUnit = "minor_unit"
        case isActive = "is_active"
    }
}
