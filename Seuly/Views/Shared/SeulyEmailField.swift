import SwiftUI

/// Email input. Carries the email content type and keyboard so autofill and
/// the @ key are available, and pins the value left-to-right because an
/// address is Latin text inside a right-to-left page.
struct SeulyEmailField: View {
    @Binding var text: String
    var isFocused: Bool = false
    var hasError: Bool = false
    var submitLabel: SubmitLabel = .next
    var onSubmit: () -> Void = {}

    var body: some View {
        TextField(
            L10n.text("field.email_placeholder", table: .auth),
            text: $text
        )
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .submitLabel(submitLabel)
        .environment(\.layoutDirection, .leftToRight)
        .multilineTextAlignment(.leading)
        .seulyField(isFocused: isFocused, hasError: hasError)
        .onSubmit(onSubmit)
        .accessibilityLabel(L10n.text("field.email", table: .auth))
    }
}
