import SwiftUI

/// Account home. An inset-grouped list so tenure, standing, accounts,
/// preferences, security, and sign-out sit in the order the platform trains
/// people to look for them.
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.seulyTheme) private var theme
    @State private var viewModel: SettingsViewModel
    let onPresentAccount: (FinancialAccount?) -> Void

    init(
        viewModel: SettingsViewModel,
        onPresentAccount: @escaping (FinancialAccount?) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onPresentAccount = onPresentAccount
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ProfileIdentityHeader(viewModel: viewModel)
                        .seulyPlainListRow()
                }
                Section {
                    ProfileSnapshotSection(viewModel: viewModel)
                        .seulyPlainListRow()
                } header: {
                    Text(L10n.text("profile.snapshot", table: .settings))
                }
                ProfileAccountsSection(
                    viewModel: viewModel,
                    onPresentAccount: onPresentAccount
                )
                ProfilePreferencesSection(viewModel: viewModel)
                ProfileSupportSection(viewModel: viewModel)
                ProfileSignOutSection(viewModel: viewModel) {
                    Task { if await viewModel.signOut() { dismiss() } }
                }
                if let error = viewModel.errorMessage {
                    Section {
                        ErrorBanner(message: error).seulyPlainListRow()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(L10n.text("profile.title", table: .settings))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.text("done", table: .settings)) { dismiss() }
                }
            }
            .toolbarBackground(
                theme.navigationBackground,
                for: .navigationBar
            )
        }
    }
}
