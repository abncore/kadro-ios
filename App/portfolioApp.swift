import SwiftUI

@main
struct PhotographerPortfolioApp: App {
    @StateObject private var store = PortfolioStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}