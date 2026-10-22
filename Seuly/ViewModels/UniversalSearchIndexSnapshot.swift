import Foundation

struct UniversalSearchIndexSnapshot {
    let workspaceRevision: UInt
    let referenceDay: LocalDate
    let results: [UniversalSearchResult]

    func matches(revision: UInt, day: LocalDate) -> Bool {
        workspaceRevision == revision && referenceDay == day
    }
}
