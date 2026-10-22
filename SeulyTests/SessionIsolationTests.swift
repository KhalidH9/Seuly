import XCTest
@testable import Seuly

@MainActor
final class SessionIsolationTests: XCTestCase {
    func testUserTransitionClearsSessionPresentationState() throws {
        let app = makeApp()
        let firstUser = UUID()
        app.prepareForUserTransition(to: firstUser)
        let tabs = try XCTUnwrap(app.mainTabViewModel)
        let auth = try XCTUnwrap(app.authViewModel)
        let recovery = try XCTUnwrap(app.passwordRecoveryViewModel)
        let onboarding = try XCTUnwrap(app.onboardingViewModel)
        let firstPersistenceID = onboarding.persistenceID

        auth.email = "previous@example.com"
        recovery.password = "sensitive-password"
        onboarding.displayName = "Previous User"
        onboarding.step = 2
        tabs.selectedTab = .activity
        tabs.activeSheet = .settings
        tabs.activityViewModel.searchText = "private merchant"
        tabs.planningViewModel.selectedSection = .recurring
        tabs.insightsViewModel.moveMonth(by: -1)

        app.prepareForUserTransition(to: UUID())

        XCTAssertTrue(auth.email.isEmpty)
        XCTAssertTrue(recovery.password.isEmpty)
        XCTAssertTrue(onboarding.displayName.isEmpty)
        XCTAssertEqual(onboarding.step, 0)
        XCTAssertNotEqual(onboarding.persistenceID, firstPersistenceID)
        XCTAssertEqual(tabs.selectedTab, .overview)
        XCTAssertNil(tabs.activeSheet)
        XCTAssertTrue(tabs.activityViewModel.searchText.isEmpty)
        XCTAssertEqual(tabs.planningViewModel.selectedSection, .budgets)
        XCTAssertTrue(tabs.insightsViewModel.followsCurrentMonth)
    }

    func testRouteRejectsWorkspaceOwnedByAnotherUser() throws {
        let app = makeApp()
        let auth = try XCTUnwrap(app.authModel)
        let finance = try XCTUnwrap(app.financeModel)
        let signedInUser = AppUser(
            id: UUID(),
            email: "current@example.com"
        )
        auth.phase = .signedIn(signedInUser)
        finance.currentUserID = UUID()
        finance.loadState = .loaded

        XCTAssertEqual(app.route, .loadingWorkspace)
    }

    private func makeApp() -> AppViewModel {
        AppViewModel(
            configuration: SupabaseConfiguration(
                url: URL(string: "https://example.supabase.co")!,
                publishableKey: String(repeating: "a", count: 40)
            )
        )
    }
}
