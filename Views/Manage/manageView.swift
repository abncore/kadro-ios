import SwiftUI

struct ManageView: View {
    @EnvironmentObject var store: PortfolioStore

    @State private var newCategoryName: String = ""
    @State private var showAddAlbum: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Add Category") {
                    TextField("Category name (e.g., Cars)", text: $newCategoryName)
                    Button("Add Category") {
                        let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else { return }
                        store.addCategory(name: name)
                        newCategoryName = ""
                    }
                }

                Section("Albums") {
                    Button("Add Album") { showAddAlbum = true }

                    ForEach(store.categories) { cat in
                        let list = store.albumsForCategory(cat.id)
                        if !list.isEmpty || !store.clientModeEnabled {
                            DisclosureGroup(cat.name) {
                                ForEach(store.albums.filter { $0.categoryId == cat.id }) { album in
                                    NavigationLink {
                                        EditAlbumView(album: album)
                                    } label: {
                                        HStack {
                                            Text(album.title)
                                            Spacer()
                                            if album.isHidden { Image(systemName: "lock.fill") }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Section("Settings") {
                    NavigationLink("Client Mode & Passcode") { SettingsView() }
                }
            }
            .navigationTitle("Manage")
            .sheet(isPresented: $showAddAlbum) {
                AddAlbumView()
            }
        }
    }
}
