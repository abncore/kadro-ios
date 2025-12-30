import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var store: PortfolioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    ForEach(store.categories) { cat in
                        NavigationLink {
                            CategoryDetailView(category: cat)
                        } label: {
                            Text(cat.name)
                        }
                    }
                }
            }
            .navigationTitle("Portfolio")
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}
