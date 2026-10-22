import SwiftUI

struct LocalizedInlineValue<Content: View>: View {
    private let prefix: String
    private let suffix: String
    private let content: Content

    init(
        _ key: String,
        table: L10nTable,
        @ViewBuilder content: () -> Content
    ) {
        let template = L10n.text(key, table: table)
        let parts = template.components(separatedBy: "%@")
        assert(parts.count == 2, "Expected one inline placeholder: \(key)")
        prefix = parts.first ?? template
        suffix = parts.count == 2 ? parts[1] : ""
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(prefix)
            content
            Text(suffix)
        }
    }
}
