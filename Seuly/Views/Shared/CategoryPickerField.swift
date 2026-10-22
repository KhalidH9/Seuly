import SwiftUI

struct CategoryPickerField: View {
    let title: String
    @Binding var selection: UUID?
    let categories: [FinanceCategory]
    var onChange: (() -> Void)?

    var body: some View {
        LabeledFormField(title) {
            SeulyPickerSurface {
                Picker(title, selection: $selection) {
                    ForEach(categories) { category in
                        Label(
                            category.localizedName,
                            systemImage: category.iconKey
                        )
                        .tag(Optional(category.id))
                    }
                }
                .onChange(of: selection) {
                    onChange?()
                }
            }
        }
    }
}
