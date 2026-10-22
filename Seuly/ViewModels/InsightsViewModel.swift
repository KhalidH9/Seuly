import Foundation
import Observation

@MainActor
@Observable
final class InsightsViewModel {
    private let model: FinanceModel
    private let preferences: PreferencesModel
    var followsCurrentMonth = true
    var selectedMonth = Date.now.startOfMonth()

    init(model: FinanceModel, preferences: PreferencesModel) {
        self.model = model
        self.preferences = preferences
    }

    var workspace: FinanceWorkspace { model.workspace }
    var analytics: FinanceAnalytics {
        FinanceAnalytics(
            workspace: workspace,
            referenceDate: analyticsReferenceDate
        )
    }
    var currency: CurrencyDefinition? { workspace.currency }
    var isPrivacyModeEnabled: Bool {
        preferences.isPrivacyModeEnabled
    }

    var storyHeadline: String {
        switch analytics.moneyPulse {
        case .calm: L10n.text("insights.headline.calm", table: .data)
        case .watch: L10n.text("insights.headline.watch", table: .data)
        case .tight: L10n.text("insights.headline.tight", table: .data)
        }
    }

    var monthTitle: String {
        AppFormatters.monthYear(selectedMonth)
    }

    var canMoveForward: Bool {
        !FinanceCalendar.current.isDate(
            selectedMonth,
            equalTo: .now,
            toGranularity: .month
        )
    }

    var canMoveBackward: Bool {
        selectedMonth > FinanceHistoryPolicy.earliestVisibleDate()
    }

    func moveMonth(by offset: Int) {
        guard
            let date = FinanceCalendar.current.date(
                byAdding: .month,
                value: offset,
                to: selectedMonth
            ),
            date >= FinanceHistoryPolicy.earliestVisibleDate(),
            offset < 0 || date <= Date.now
        else { return }
        selectedMonth = date.startOfMonth()
        followsCurrentMonth = FinanceCalendar.current.isDate(
            selectedMonth,
            equalTo: .now,
            toGranularity: .month
        )
    }

    func updateReferenceDate(_ date: Date) {
        guard followsCurrentMonth else { return }
        selectedMonth = date.startOfMonth()
    }

    private var analyticsReferenceDate: Date {
        if FinanceCalendar.current.isDate(
            selectedMonth,
            equalTo: .now,
            toGranularity: .month
        ) {
            return .now
        }
        return FinanceCalendar.current.date(
            byAdding: .second,
            value: -1,
            to: selectedMonth.endOfMonth()
        ) ?? selectedMonth
    }
}
