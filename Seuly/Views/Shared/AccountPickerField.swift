import SwiftUI

struct AccountPickerField: View {
    let title: String
    @Binding var selection: UUID?
    let accounts: [FinancialAccount]
    var onChange: (() -> Void)?

    var body: some View {
        LabeledFormField(title) {
            SeulyPickerSurface {
                Picker(title, selection: $selection) {
                    ForEach(accounts) { account in
                        Label(
                            account.name,
                            systemImage: account.iconKey
                        )
                        .tag(Optional(account.id))
                    }
                }
                .onChange(of: selection) {
                    onChange?()
                }
            }
        }
    }
}
