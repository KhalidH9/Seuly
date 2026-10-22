import Foundation

enum UniversalSearchMatcher {
    static func score(
        query: String,
        result: UniversalSearchResult,
        includesSensitiveTerms: Bool = true
    ) -> Int? {
        score(
            normalizedQuery: normalize(query),
            result: result,
            includesSensitiveTerms: includesSensitiveTerms
        )
    }

    static func score(
        normalizedQuery: String,
        result: UniversalSearchResult,
        includesSensitiveTerms: Bool = true
    ) -> Int? {
        guard !normalizedQuery.isEmpty else { return nil }
        let title = result.normalizedTitle
        let subtitle = result.normalizedSubtitle
        let privateTerms = includesSensitiveTerms
            ? " " + result.normalizedSensitiveTerms
            : ""
        let supporting = result.normalizedMetadata + " "
            + result.normalizedSearchTerms + privateTerms
        let tokens = normalizedQuery.split(separator: " ").map(String.init)
        guard tokens.allSatisfy({ token in
            contains(token, in: title)
                || contains(token, in: subtitle)
                || contains(token, in: supporting)
        }) else { return nil }
        var value = phraseScore(normalizedQuery, in: title, weight: 1_200)
        value += phraseScore(normalizedQuery, in: subtitle, weight: 450)
        value += phraseScore(normalizedQuery, in: supporting, weight: 180)
        value += tokens.reduce(0) { score, token in
            score + tokenScore(token, title: title, supporting: subtitle)
        }
        return value
    }

    static func normalize(_ value: String) -> String {
        UniversalSearchNormalizer.normalize(value)
    }

    private static func contains(_ token: String, in value: String) -> Bool {
        guard token.allSatisfy(\.isNumber) else {
            return value.contains(token)
        }
        return value.split(separator: " ").contains(Substring(token))
    }

    private static func phraseScore(
        _ query: String,
        in value: String,
        weight: Int
    ) -> Int {
        if value == query { return weight }
        if value.hasPrefix(query) { return weight * 3 / 4 }
        return value.contains(query) ? weight / 2 : 0
    }

    private static func tokenScore(
        _ token: String,
        title: String,
        supporting: String
    ) -> Int {
        if title.split(separator: " ").contains(where: { $0.hasPrefix(token) }) {
            return 180
        }
        if title.contains(token) { return 100 }
        return supporting.contains(token) ? 40 : 0
    }
}
