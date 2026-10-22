import Foundation

extension Int64 {
    func addingClamped(_ value: Int64) -> Int64 {
        let (result, overflow) = addingReportingOverflow(value)
        guard overflow else { return result }
        return value >= 0 ? .max : .min
    }

    func subtractingClamped(_ value: Int64) -> Int64 {
        let (result, overflow) = subtractingReportingOverflow(value)
        guard overflow else { return result }
        return value >= 0 ? .min : .max
    }

    var magnitudeClamped: Int64 {
        self == .min ? .max : Swift.abs(self)
    }
}

extension Sequence where Element == Int64 {
    func sumClamped() -> Int64 {
        reduce(0) { $0.addingClamped($1) }
    }
}
