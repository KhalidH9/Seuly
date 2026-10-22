import SwiftUI

@main
struct SeulyApp: App {
    @State private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ThemeHostView(viewModel: viewModel)
        }
    }
}
