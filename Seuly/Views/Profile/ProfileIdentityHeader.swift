import SwiftUI

/// Who the account belongs to: monogram, name, sign-in address, tenure, and
/// the base currency every amount in the app is expressed in.
struct ProfileIdentityHeader: View {
    @Environment(\.seulyTheme) private var theme
    let viewModel: SettingsViewModel

    var body: some View {
        SeulyCard {
            VStack(spacing: SeulyLayout.spacingM) {
                ProfileAvatarView(initials: viewModel.initials, size: 76)
                VStack(spacing: SeulyLayout.spacingXS) {
                    Text(viewModel.displayName)
                        .font(SeulyFont.heroTitle)
                        .foregroundStyle(theme.textPrimary)
                        .multilineTextAlignment(.center)
                    if !viewModel.email.isEmpty {
                        SeulyNumeralText {
                            Text(viewModel.email)
                                .font(SeulyFont.subheadline)
                                .foregroundStyle(theme.textSecondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                }
                badges
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SeulyLayout.spacingS)
        }
        .accessibilityElement(children: .combine)
    }

    private var badges: some View {
        HStack(spacing: SeulyLayout.spacingS) {
            StatusPill(
                title: viewModel.currencyName,
                kind: .information,
                systemImage: "banknote"
            )
            if let memberSince = viewModel.memberSinceText {
                StatusPill(
                    title: memberSince,
                    kind: .neutral,
                    systemImage: "calendar"
                )
            }
        }
    }
}
