import SwiftUI

struct BoundedDatePickerField: View {
    @Environment(\.seulyTheme) private var theme
    let title: String
    @Binding var date: Date
    let range: ClosedRange<Date>

    var body: some View {
        LabeledFormField(title) {
            DatePicker(
                title,
                selection: $date,
                in: range,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .tint(theme.brandPrimary)
            .frame(
                maxWidth: .infinity,
                minHeight: SeulyLayout.fieldHeight,
                alignment: .leading
            )
            .padding(.horizontal, SeulyLayout.spacingM)
            .background(
                theme.inputBackground,
                in: RoundedRectangle(
                    cornerRadius: SeulyLayout.controlRadius,
                    style: .continuous
                )
            )
        }
    }
}
