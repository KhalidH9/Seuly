import XCTest
@testable import Seuly

final class ComputedLocalizationTests: XCTestCase {
    func testModelComputedKeysResolve() {
        assertLocalized(AppearancePreference.allCases.map(\.displayName))
        assertLocalized(AccountKind.allCases.map(\.displayName))
        assertLocalized(GoalKind.allCases.map(\.displayName))
        assertLocalized(RecurringCadence.allCases.map(\.displayName))
        assertLocalized(RecurringCadence.allCases.map(\.shortDescription))
        assertLocalized(TransactionKind.allCases.map(\.displayName))
        assertLocalized(ColorRole.allCases.map(\.displayName))
        assertLocalized(MainTab.allCases.map(\.title))
    }

    @MainActor
    func testViewModelComputedKeysResolve() {
        assertLocalized(AuthViewModel.Mode.allCases.map(\.displayName))
        assertLocalized(ActivityViewModel.Period.allCases.map(\.displayName))
        assertLocalized(PlanningViewModel.Section.allCases.map(\.displayName))
    }

    func testVariableKeyFamiliesResolve() {
        let keys: [(String, L10nTable)] = [
            ("story.calm", .insights),
            ("story.watch", .insights),
            ("story.tight", .insights),
            ("greeting.morning", .dashboard),
            ("greeting.afternoon", .dashboard),
            ("greeting.evening", .dashboard),
            ("recurring.cadence.weekly", .dashboard),
            ("recurring.cadence.monthly", .dashboard),
            ("recurring.cadence.yearly", .dashboard),
            ("field.to_account", .transactions),
            ("field.from_account", .transactions),
            ("trend.up", .shared),
            ("trend.down", .shared),
            ("number.compact.thousand", .data),
            ("number.compact.million", .data),
            ("number.compact.billion", .data)
        ]
        assertLocalized(keys.map { L10n.text($0.0, table: $0.1) })
        let pluralKeys = ["zero", "one", "two", "few", "many", "other"]
        assertLocalized(pluralKeys.map {
            L10n.text("budget.utilization.\($0)", table: .planning)
        })
        let contexts: [ErrorPresentationContext] = [
            .signIn, .signUp, .signOut, .passwordReset,
            .passwordUpdate, .authenticationLink, .workspaceLoad, .mutation
        ]
        assertLocalized(contexts.map {
            L10n.text(ErrorPresenter.key(for: $0), table: .errors)
        })
    }

    private func assertLocalized(_ values: [String]) {
        XCTAssertFalse(values.isEmpty)
        XCTAssertFalse(values.contains(where: \.isEmpty))
    }
}
