import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: PortfolioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    header

                    Text("Categories")
                        .font(.title2.bold())
                        .padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
                        ForEach(store.categories) { cat in
                            NavigationLink {
                                CategoryDetailView(category: cat)
                            } label: {
                                CategoryCard(category: cat)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Text("Quick Actions")
                        .font(.title2.bold())
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        NavigationLink {
                            ManageView()
                        } label: {
                            QuickActionCard(title: "Add Album", icon: "plus.circle.fill")
                        }

                        NavigationLink {
                            SettingsView()
                        } label: {
                            QuickActionCard(title: "Client Mode", icon: "lock.fill")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hi 👋")
                .font(.title3.weight(.semibold))
            Text("Ready to show your best work?")
                .font(.largeTitle.bold())
        }
        .padding(.horizontal)
    }
}

private struct QuickActionCard: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
