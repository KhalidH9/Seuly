import SwiftUI

/// Password input with a reveal toggle.
///
/// Both the secure and plain variants are declared so revealing does not
/// destroy and rebuild the field, which would drop focus and the caret.
struct SeulyPasswordField: View {
    @Environment(\.seulyTheme) private var theme
    @Binding var text: String
    var placeholder: String = L10n.text(
        "field.password_placeholder",
        table: .auth
    )
    var textContentType: UITextContentType = .password
    var isFocused: Bool = false
    var hasError: Bool = false
    var submitLabel: SubmitLabel = .go
    var onSubmit: () -> Void = {}
    @State private var isRevealed = false

    var body: some View {
        // Pinned left-to-right: a password is Latin text, and secure entry
        // renders that way regardless, so the reveal button has to sit on the
        // same side the caret does -- matching the email field above it.
        SeulyNumeralText {
            HStack(spacing: SeulyLayout.spacingS) {
                Group {
                    if isRevealed {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .textContentType(textContentType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
                .onSubmit(onSubmit)
                .accessibilityLabel(L10n.text("field.password", table: .auth))
                revealButton
            }
        }
        .seulyField(isFocused: isFocused, hasError: hasError)
    }

    private var revealButton: some View {
        Button {
            isRevealed.toggle()
        } label: {
            Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                .font(SeulyFont.subheadline)
                .foregroundStyle(theme.textSecondary)
                .frame(width: 32, height: SeulyLayout.fieldHeight)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            L10n.text(
                isRevealed ? "password.hide" : "password.show",
                table: .auth
            )
        )
    }
}
