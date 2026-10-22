import Foundation

struct UniversalSearchSection: Identifiable, Equatable, Sendable {
    let id: UniversalSearchKind
    let results: [UniversalSearchResult]

    var title: String { id.displayName }
}
