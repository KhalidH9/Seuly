import SwiftUI

struct GoalFieldsView: View {
    @Bindable var viewModel: GoalFormViewModel
    @FocusState private var focusesName: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: SeulyLayout.spacingL) {
            LabeledFormField(
                L10n.text("goal.field.name", table: .planning)
            ) {
                TextField(
                    L10n.text("goal.field.name_placeholder", table: .planning),
                    text: $viewModel.name
                )
                .submitLabel(.done)
                .focused($focusesName)
                .seulyField(isFocused: focusesName)
            }
            LabeledFormField(
                L10n.text("goal.field.type", table: .planning)
            ) {
                SeulyPickerSurface {
                    Picker(
                        L10n.text("goal.field.type", table: .planning),
                        selection: $viewModel.kind
                    ) {
                        ForEach(GoalKind.allCases) { kind in
                            Label(
                                kind.displayName,
                                systemImage: kind.systemImage
                            )
                            .tag(kind)
                        }
                    }
                    .onChange(of: viewModel.kind) {
                        viewModel.kindChanged()
                    }
                }
            }
            GoalTargetDateToggleView(viewModel: viewModel)
            if viewModel.hasTargetDate {
                BoundedDatePickerField(
                    title: L10n.text("goal.field.date", table: .planning),
                    date: $viewModel.targetDate,
                    range: viewModel.targetDateRange
                )
            }
        }
    }
}
