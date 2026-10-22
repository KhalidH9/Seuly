import SwiftUI

/// Filter rail. Period is a menu because its options are dates; kind is a set
/// of chips because they are peers the eye should compare.
struct ActivityFiltersView: View {
    @Environment(\.seulyTheme) private var theme
    @Bindable var viewModel: ActivityViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: SeulyLayout.spacingS) {
                periodMenu
                FilterChip(
                    title: L10n.text("filter.all", table: .activity),
                    isSelected: viewModel.selectedKind == nil
                ) {
                    viewModel.selectKind(nil)
                }
                ForEach(TransactionKind.allCases) { kind in
                    FilterChip(
                        title: kind.displayName,
                        systemImage: kind.systemImage,
                        isSelected: viewModel.selectedKind == kind
                    ) {
                        viewModel.selectKind(kind)
                    }
                }
                if let category = viewModel.selectedCategory {
                    FilterChip(
                        title: category.localizedName,
                        systemImage: UniversalSearchSymbol.sanitized(
                            category.iconKey,
                            fallback: UniversalSearchKind.category.systemImage
                        ),
                        isSelected: true
                    ) {
                        viewModel.selectedCategoryID = nil
                    }
                }
            }
            .padding(.horizontal, SeulyLayout.spacingL)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .accessibilityElement(children: .contain)
    }

    private var periodMenu: some View {
        Menu {
            Picker(
                L10n.text("filter.period", table: .activity),
                selection: $viewModel.period
            ) {
                ForEach(ActivityViewModel.Period.allCases) { period in
                    Text(period.displayName).tag(period)
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "calendar")
                    .font(SeulyFont.caption.weight(.semibold))
                Text(viewModel.period.displayName)
                    .font(SeulyFont.subheadlineEmphasized)
                Image(systemName: "chevron.down")
                    .font(SeulyFont.caption2.weight(.bold))
            }
            .foregroundStyle(theme.textSecondary)
            .padding(.horizontal, SeulyLayout.spacingM)
            .frame(minHeight: SeulyLayout.minimumTapTarget)
            .background(theme.fillTertiary, in: Capsule())
        }
        .accessibilityLabel(L10n.text("filter.period", table: .activity))
    }
}
