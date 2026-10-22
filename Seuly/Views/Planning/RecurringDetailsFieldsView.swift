import SwiftUI

struct RecurringDetailsFieldsView: View {
    @Bindable var viewModel: RecurringFormViewModel
    @FocusState private var focusesName: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            LabeledFormField(
                L10n.text("recurring.field.name", table: .planning)
            ) {
                TextField(
                    L10n.text(
                        "recurring.field.name_placeholder",
                        table: .planning
                    ),
                    text: $viewModel.entry.merchant
                )
                .submitLabel(.done)
                .focused($focusesName)
                .seulyField(isFocused: focusesName)
            }
            RecurringPartiesFieldsView(viewModel: viewModel)
            LabeledFormField(
                L10n.text("recurring.field.cadence", table: .planning)
            ) {
                SeulyPickerSurface {
                    Picker(
                        L10n.text("recurring.field.cadence", table: .planning),
                        selection: $viewModel.cadence
                    ) {
                        ForEach(RecurringCadence.allCases) { cadence in
                            Text(cadence.shortDescription).tag(cadence)
                        }
                    }
                }
            }
            BoundedDatePickerField(
                title: L10n.text(
                    "recurring.field.next_date",
                    table: .planning
                ),
                date: $viewModel.nextRunDate,
                range: viewModel.nextRunDateRange
            )
            LabeledFormField(
                L10n.text("recurring.field.note", table: .planning)
            ) {
                TextField(
                    L10n.text(
                        "recurring.field.note_placeholder",
                        table: .planning
                    ),
                    text: $viewModel.entry.note,
                    axis: .vertical
                )
                .lineLimit(2...4)
                .seulyField()
            }
            InfoCalloutView(
                message: L10n.text("recurring.forecast_help", table: .planning)
            )
        }
    }
}
