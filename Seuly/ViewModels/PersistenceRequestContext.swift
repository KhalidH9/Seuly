import Foundation

struct PersistenceRequestContext: Equatable, Sendable {
    let id: UUID
    private(set) var localDate: LocalDate?

    init(id: UUID = UUID()) {
        self.id = id
    }

    mutating func begin(
        referenceDate: Date = .now,
        timeZone: TimeZone = .current
    ) -> (id: UUID, localDate: LocalDate) {
        let submittedOn = localDate
            ?? LocalDate(date: referenceDate, timeZone: timeZone)
        localDate = submittedOn
        return (id, submittedOn)
    }
}
