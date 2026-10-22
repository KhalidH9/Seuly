import Foundation

enum UniversalSearchID: Hashable, Sendable {
    case transaction(UUID)
    case account(UUID)
    case budget(UUID)
    case category(UUID)
    case goal(UUID)
    case recurring(UUID)
}

struct UniversalSearchResult: Identifiable, Equatable, Sendable {
    let id: UniversalSearchID
    let kind: UniversalSearchKind
    let title: String
    let subtitle: String
    let metadata: String
    let systemImage: String
    let amountMinor: Int64?
    let currencyCode: String?
    let destination: UniversalSearchDestination
    let searchTerms: String
    let sensitiveSearchTerms: String
    let sortDate: Date?
    let normalizedTitle: String
    let normalizedSubtitle: String
    let normalizedMetadata: String
    let normalizedSearchTerms: String
    let normalizedSensitiveTerms: String

    init(
        id: UniversalSearchID,
        kind: UniversalSearchKind,
        title: String,
        subtitle: String,
        metadata: String = "",
        systemImage: String? = nil,
        amountMinor: Int64? = nil,
        currencyCode: String? = nil,
        destination: UniversalSearchDestination,
        searchTerms: String = "",
        sensitiveSearchTerms: String = "",
        sortDate: Date? = nil
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.metadata = metadata
        self.systemImage = systemImage ?? kind.systemImage
        self.amountMinor = amountMinor
        self.currencyCode = currencyCode
        self.destination = destination
        self.searchTerms = searchTerms
        self.sensitiveSearchTerms = sensitiveSearchTerms
        self.sortDate = sortDate
        normalizedTitle = UniversalSearchNormalizer.normalize(title)
        normalizedSubtitle = UniversalSearchNormalizer.normalize(subtitle)
        normalizedMetadata = UniversalSearchNormalizer.normalize(metadata)
        normalizedSearchTerms = UniversalSearchNormalizer.normalize(searchTerms)
        normalizedSensitiveTerms = UniversalSearchNormalizer.normalize(
            sensitiveSearchTerms
        )
    }
}
