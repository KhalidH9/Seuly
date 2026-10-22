import Foundation
import Observation

@MainActor
@Observable
final class TransactionFormViewModel {
    let model: FinanceModel
    var entry: LedgerEntryViewModel
    let existingTransaction: FinancialTransaction?
    private var requestContext: PersistenceRequestContext
    var effectiveDate = Date.now
    var isSaving = false
    var errorMessage: String?

    init(
        model: FinanceModel,
        kind: TransactionKind,
        transaction: FinancialTransaction?
    ) {
        self.model = model
        existingTransaction = transaction
        requestContext = PersistenceRequestContext(
            id: transaction?.id ?? UUID()
        )
        entry = LedgerEntryViewModel(
            model: model,
            kind: transaction?.kind ?? kind
        )
        if let transaction {
            entry.populate(from: transaction)
            effectiveDate = transaction.effectiveDate
        }
    }

    var allowedDateRange: ClosedRange<Date> {
        FinanceHistoryPolicy.earliestVisibleDate()...Date.now
    }
    var canSave: Bool {
        !isSaving && entry.hasValidLedger
    }

    func beginPersistenceRequest() -> (id: UUID, localDate: LocalDate) {
        requestContext.begin()
    }
}
