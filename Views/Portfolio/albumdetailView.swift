import SwiftUI
import PhotosUI

struct AlbumDetailView: View {
    @EnvironmentObject var store: PortfolioStore
    let album: Album

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isSelectMode: Bool = false
    @State private var selectedPhotoIDs: Set<UUID> = []

    var body: some View {
        let photos = store.photosForAlbum(album.id)

        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header

                if photos.isEmpty {
                    ContentUnavailableView("No photos", systemImage: "plus",
                                           description: Text("Tap Import to add photos to this album."))
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 10)], spacing: 10) {
                        ForEach(photos) { p in
                            let uiImage = store.loadUIImage(filename: p.filename)
                            ZStack(alignment: .topTrailing) {
                                NavigationLink {
                                    PhotoViewerView(albumId: album.id, startPhotoId: p.id)
                                } label: {
                                    PhotoThumb(image: uiImage)
                                }
                                .disabled(isSelectMode)

                                if isSelectMode {
                                    Button {
                                        toggleSelect(p.id)
                                    } label: {
                                        Image(systemName: selectedPhotoIDs.contains(p.id) ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .padding(8)
                                    }
                                }

                                if p.isFavorite {
                                    Image(systemName: "star.fill")
                                        .padding(8)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(album.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    Image(systemName: "square.and.arrow.down")
                }
                Button {
                    isSelectMode.toggle()
                    if !isSelectMode { selectedPhotoIDs.removeAll() }
                } label: {
                    Image(systemName: isSelectMode ? "xmark.circle" : "checklist")
                }
            }
            if isSelectMode {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Delete") { deleteSelected() }
                    Spacer()
                    Button("Favorite") { favoriteSelected() }
                    Spacer()
                    Button("Set Cover") { setCoverFromSelected() }
                }
            }
        }
        .onChange(of: selectedItems) { _, newItems in
            Task { await importPhotos(newItems) }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(album.description)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                if !album.location.isEmpty { Label(album.location, systemImage: "mappin.and.ellipse") }
                Label(album.date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private func toggleSelect(_ id: UUID) {
        if selectedPhotoIDs.contains(id) {
            selectedPhotoIDs.remove(id)
        } else {
            selectedPhotoIDs.insert(id)
        }
    }

    private func deleteSelected() {
        let items = store.photosForAlbum(album.id).filter { selectedPhotoIDs.contains($0.id) }
        items.forEach { store.deletePhoto($0) }
        selectedPhotoIDs.removeAll()
        isSelectMode = false
    }

    private func favoriteSelected() {
        let items = store.photosForAlbum(album.id).filter { selectedPhotoIDs.contains($0.id) }
        items.forEach { store.toggleFavorite($0) }
        selectedPhotoIDs.removeAll()
        isSelectMode = false
    }

    private func setCoverFromSelected() {
        guard let first = selectedPhotoIDs.first else { return }
        store.setAlbumCover(albumId: album.id, photoId: first)
        selectedPhotoIDs.removeAll()
        isSelectMode = false
    }

    private func importPhotos(_ items: [PhotosPickerItem]) async {
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                store.addPhoto(albumId: album.id, imageData: data)
            }
        }
        selectedItems.removeAll()
    }
}

private struct PhotoThumb: View {
    let image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "photo")
                }
            }
        }
        .frame(height: 140)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
