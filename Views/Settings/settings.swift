import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: PortfolioStore
    @AppStorage("hasSeenIntro") private var hasSeenIntro: Bool = true

    @State private var passcode: String = ""

    var body: some View {
        Form {
            Section("Client Mode 🔒") {
                Toggle("Enable Client Mode", isOn: $store.clientModeEnabled)
                SecureField("Passcode (default 1234)", text: $passcode)
                Button("Update Passcode") {
                    let p = passcode.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !p.isEmpty else { return }
                    store.clientPasscode = p
                    passcode = ""
                }
            }

            Section("Intro") {
                Button("Show Intro Again") {
                    hasSeenIntro = false
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear { passcode = "" }
    }
}
