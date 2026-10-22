import SwiftUI

/// Three exclusive peers, so this is a segmented control rather than a custom
/// track: it inherits selection semantics, keyboard focus, and VoiceOver.
struct PlanningSectionPicker: View {
    @Bindable var viewModel: PlanningViewModel

    var body: some View {
        Picker(
            L10n.text("section.accessibility", table: .planning),
            selection: $viewModel.selectedSection
        ) {
            ForEach(PlanningViewModel.Section.allCases) { section in
                Text(section.displayName).tag(section)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}
