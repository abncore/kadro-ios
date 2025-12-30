import SwiftUI

struct CategoryCard: View {
    @EnvironmentObject var store: PortfolioStore
    let category: Category

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.thinMaterial)
                    .frame(height: 120)

                Text(category.name.prefix(1))
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.secondary)
            }

            Text(category.name)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("\(store.albumsForCategory(category.id).count) albums")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct AlbumCard: View {
    @EnvironmentObject var store: PortfolioStore
    let album: Album

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.thinMaterial)
                    .frame(height: 140)

                if let coverId = album.coverPhotoId,
                   let p = store.photos.first(where: { $0.id == coverId }),
                   let img = store.loadUIImage(filename: p.filename) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 38))
                        .foregroundStyle(.secondary)
                }
            }

            Text(album.title)
                .font(.headline)

            Text(album.location.isEmpty ? album.date.formatted(date: .abbreviated, time: .omitted)
                                       : "\(album.location) • \(album.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if album.isHidden {
                Label("Hidden in Client Mode", systemImage: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
