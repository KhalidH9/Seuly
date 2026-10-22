import Foundation
import Observation

@MainActor
@Observable
final class RecurringFormViewModel {
    let model: FinanceModel
    var entry: LedgerEntryViewModel
    private var requestContext = PersistenceRequestContext()
    var cadence: RecurringCadence = .monthly
    var nextRunDate = FinanceCalendar.current.date(
        byAdding: .day,
        value: 7,
        to: .now
    ) ?? .now
    var isSaving = false
    var errorMessage: String?

    init(model: FinanceModel) {
        self.model = model
        entry = LedgerEntryViewModel(model: model, kind: .expense)
    }

    var nextRunDateRange: ClosedRange<Date> {
        FinanceCalendar.futureDateRange()
    }
    var canSave: Bool {
        !isSaving
            && entry.hasValidLedger
            && nextRunDateRange.contains(nextRunDate)
            && !entry.merchant
                .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func beginPersistenceRequest() -> (id: UUID, localDate: LocalDate) {
        requestContext.begin()
    }
}
