import Foundation

enum UniversalSearchDestination: Equatable, Sendable {
    case transaction(UUID)
    case account(UUID)
    case category(UUID)
    case planning(kind: UniversalSearchKind, entityID: UUID)
}
