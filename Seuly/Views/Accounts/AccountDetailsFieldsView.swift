import SwiftUI

struct AccountDetailsFieldsView: View {
    @Bindable var viewModel: AccountFormViewModel
    @FocusState private var focusesName: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            LabeledFormField(
                L10n.text("account.field.name", table: .settings)
            ) {
                TextField(
                    L10n.text(
                        "account.field.name_placeholder",
                        table: .settings
                    ),
                    text: $viewModel.name
                )
                .submitLabel(.done)
                .focused($focusesName)
                .seulyField(isFocused: focusesName)
            }
            LabeledFormField(
                L10n.text("account.field.institution", table: .settings)
            ) {
                TextField(
                    L10n.text(
                        "account.field.institution_placeholder",
                        table: .settings
                    ),
                    text: $viewModel.institutionName
                )
                .submitLabel(.done)
                .seulyField()
            }
            LabeledFormField(
                L10n.text("account.field.type", table: .settings)
            ) {
                SeulyPickerSurface {
                    Picker(
                        L10n.text("account.field.type", table: .settings),
                        selection: $viewModel.kind
                    ) {
                        ForEach(AccountKind.allCases) { kind in
                            Label(
                                kind.displayName,
                                systemImage: kind.systemImage
                            )
                            .tag(kind)
                        }
                    }
                    .onChange(of: viewModel.kind) {
                        viewModel.kindChanged()
                    }
                }
            }
        }
    }
}
