import Foundation

extension FinanceModel {
    func completeOnboarding(_ draft: OnboardingDraft) async -> Bool {
        await performMutation(refreshing: .workspace) {
            try await client.rpc(
                "complete_onboarding",
                params: CompleteOnboardingPayload(
                    requestID: draft.id,
                    displayName: draft.displayName,
                    currencyCode: draft.currencyCode,
                    accountName: draft.accountName,
                    accountKind: draft.accountKind.rawValue,
                    openingBalanceMinor: draft.openingBalanceMinor,
                    monthlyBudgetMinor: draft.monthlyBudgetMinor,
                    monthlyBudgetCategoryName: draft.monthlyBudgetCategoryName,
                    localDate: draft.localDate.databaseValue
                )
            ).execute()
        }
    }

    func saveAccount(_ draft: AccountDraft) async -> Bool {
        await performMutation(refreshing: .accounts) {
            try await client.rpc(
                "save_account",
                params: SaveAccountPayload(
                    accountID: draft.id,
                    name: draft.name,
                    kind: draft.kind.rawValue,
                    openingBalanceMinor: draft.openingBalanceMinor,
                    institutionName: draft.normalizedInstitutionName,
                    iconKey: draft.iconKey,
                    colorRole: draft.colorRole.rawValue
                )
            ).execute()
        }
    }
}
