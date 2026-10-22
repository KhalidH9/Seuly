import SwiftUI

/// Field label above its control. Secondary weight on the label keeps the
/// value the loudest thing in the row.
struct LabeledFormField<Content: View>: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    private let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(SeulyFont.footnoteEmphasized)
                .foregroundStyle(theme.textSecondary)
            content
        }
    }
}
