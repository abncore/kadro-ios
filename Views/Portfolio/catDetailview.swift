import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject var store: PortfolioStore
    let category: Category

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(category.name)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                let albums = store.albumsForCategory(category.id)

                if albums.isEmpty {
                    ContentUnavailableView("No albums yet", systemImage: "photo.on.rectangle",
                                           description: Text("Go to Manage tab to add your first album."))
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
                        ForEach(albums) { album in
                            NavigationLink {
                                AlbumDetailView(album: album)
                            } label: {
                                AlbumCard(album: album)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 10)
        }
        .navigationTitle("Albums")
        .navigationBarTitleDisplayMode(.inline)
    }
}
