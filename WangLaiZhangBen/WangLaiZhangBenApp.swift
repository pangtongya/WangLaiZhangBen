import SwiftUI

@main
struct WangLaiZhangBenApp: App {
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
