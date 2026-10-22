import Foundation

struct MoneyPresentation: Equatable, Sendable {
    let sign: String
    let amountText: String
    let plainText: String
    let accessibilityText: String
    let usesSaudiRiyalSymbol: Bool
}
