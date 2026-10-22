import Foundation

enum ArabicPlural {
    static func suffix(for count: Int) -> String {
        if count == 0 { return "zero" }
        if count == 1 { return "one" }
        if count == 2 { return "two" }
        let moduloHundred = count % 100
        if (3...10).contains(moduloHundred) { return "few" }
        if (11...99).contains(moduloHundred) { return "many" }
        return "other"
    }
}
