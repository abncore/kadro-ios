import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro: Bool = false

    var body: some View {
        if hasSeenIntro {
            MainTabView()
        } else {
            IntroView {
                hasSeenIntro = true
            }
        }
    }
}
