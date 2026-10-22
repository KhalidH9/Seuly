import SwiftUI

/// Shared chrome for every sheet-presented form: inline title, cancel and
/// confirm in their platform slots, and dismissal blocked while saving.
struct ModalFormScaffold<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.seulyTheme) private var theme
    let title: String
    var saveTitle: String
    let canSave: Bool
    let isSaving: Bool
    let save: () async -> Bool
    private let content: Content

    init(
        title: String,
        saveTitle: String? = nil,
        canSave: Bool,
        isSaving: Bool,
        save: @escaping () async -> Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.saveTitle = saveTitle ?? L10n.text("save", table: .shared)
        self.canSave = canSave
        self.isSaving = isSaving
        self.save = save
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            SeulyScreen {
                content.padding(.top, SeulyLayout.spacingS)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.text("cancel", table: .shared)) {
                        dismiss()
                    }
                    .disabled(isSaving)
                }
                ToolbarItem(placement: .confirmationAction) {
                    confirmButton
                }
            }
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(isSaving)
    }

    private var confirmButton: some View {
        Button {
            Task { if await save() { dismiss() } }
        } label: {
            if isSaving {
                SeulyActivityIndicator(size: 22)
            } else {
                Text(saveTitle).fontWeight(.semibold)
            }
        }
        .disabled(!canSave || isSaving)
    }
}
