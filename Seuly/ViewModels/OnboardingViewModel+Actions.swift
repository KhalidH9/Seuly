import Foundation

extension OnboardingViewModel {
    func goBack() {
        guard canGoBack else { return }
        step -= 1
        errorMessage = nil
    }

    func continueFlow() async {
        guard canContinue else {
            errorMessage = L10n.text(
                "validation.onboarding.incomplete",
                table: .errors
            )
            return
        }
        guard isLastStep else {
            step += 1
            errorMessage = nil
            return
        }
        guard let openingBalance else {
            errorMessage = L10n.text(
                "validation.account.opening_balance",
                table: .errors
            )
            return
        }
        isSaving = true
        defer { isSaving = false }
        let request = beginPersistenceRequest()
        let succeeded = await model.completeOnboarding(
            OnboardingDraft(
                id: request.id,
                displayName: displayName,
                currencyCode: currencyCode,
                accountName: accountName,
                accountKind: accountKind,
                openingBalanceMinor: accountKind.isLiability
                    ? normalizedLiability(openingBalance)
                    : openingBalance,
                monthlyBudgetMinor: monthlyBudgetText.isEmpty
                    ? nil
                    : monthlyBudget,
                monthlyBudgetCategoryName: monthlyBudgetText.isEmpty
                    ? nil
                    : selectedBudgetCategory?.name,
                localDate: request.localDate
            )
        )
        if
            succeeded,
            model.workspace.profile?.onboardingCompleted == true
        {
            errorMessage = nil
        } else {
            errorMessage = model.errorMessage
                ?? L10n.text(
                    "error.onboarding.not_confirmed",
                    table: .errors
                )
        }
    }

    private func normalizedLiability(_ balance: Int64) -> Int64 {
        balance > 0 ? -balance : balance
    }
}
