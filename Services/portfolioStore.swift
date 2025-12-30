import SwiftUI
import Foundation
import UIKit

final class PortfolioStore: ObservableObject {
    @Published var categories: [Category] = []
    @Published var albums: [Album] = []
    @Published var photos: [PhotoItem] = []

    @AppStorage("clientModeEnabled") var clientModeEnabled: Bool = false
    @AppStorage("clientPasscode") var clientPasscode: String = "1234" // change later

    private let dataURL: URL

    init() {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.dataURL = doc.appendingPathComponent("portfolio_data.json")
        load()
        seedIfNeeded()
    }

    // MARK: - CRUD Category
    func addCategory(name: String) {
        categories.append(Category(name: name))
        save()
    }

    func deleteCategory(_ category: Category) {
        // delete albums + photos in that category
        let albumIds = albums.filter { $0.categoryId == category.id }.map { $0.id }
        for aid in albumIds {
            deleteAlbumById(aid)
        }
        categories.removeAll { $0.id == category.id }
        save()
    }

    // MARK: - CRUD Album
    func addAlbum(categoryId: UUID, title: String, description: String, location: String, date: Date, isHidden: Bool) {
        albums.append(Album(categoryId: categoryId, title: title, description: description, date: date, location: location, isHidden: isHidden))
        save()
    }

    func updateAlbum(_ album: Album) {
        if let idx = albums.firstIndex(where: { $0.id == album.id }) {
            albums[idx] = album
            save()
        }
    }

    func deleteAlbum(_ album: Album) {
        deleteAlbumById(album.id)
        save()
    }

    private func deleteAlbumById(_ albumId: UUID) {
        // delete photos files
        let toDelete = photos.filter { $0.albumId == albumId }
        for p in toDelete { deleteImageFile(filename: p.filename) }
        photos.removeAll { $0.albumId == albumId }
        albums.removeAll { $0.id == albumId }
    }

    // MARK: - Photos
    func addPhoto(albumId: UUID, imageData: Data) {
        let filename = "\(UUID().uuidString).jpg"
        saveImageFile(data: imageData, filename: filename)
        photos.append(PhotoItem(albumId: albumId, filename: filename))
        save()
    }

    func deletePhoto(_ photo: PhotoItem) {
        deleteImageFile(filename: photo.filename)
        photos.removeAll { $0.id == photo.id }
        // if album cover points to this photo, clear it
        if let aIdx = albums.firstIndex(where: { $0.coverPhotoId == photo.id }) {
            albums[aIdx].coverPhotoId = nil
        }
        save()
    }

    func toggleFavorite(_ photo: PhotoItem) {
        if let idx = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[idx].isFavorite.toggle()
            save()
        }
    }

    func setAlbumCover(albumId: UUID, photoId: UUID) {
        if let idx = albums.firstIndex(where: { $0.id == albumId }) {
            albums[idx].coverPhotoId = photoId
            save()
        }
    }

    // MARK: - Helpers
    func albumsForCategory(_ categoryId: UUID) -> [Album] {
        let list = albums.filter { $0.categoryId == categoryId }
        if clientModeEnabled { return list.filter { !$0.isHidden } }
        return list
    }

    func photosForAlbum(_ albumId: UUID) -> [PhotoItem] {
        photos.filter { $0.albumId == albumId }
    }

    // MARK: - Image Load
    func loadUIImage(filename: String) -> UIImage? {
        let url = imagesFolder().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    private func imagesFolder() -> URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = doc.appendingPathComponent("Images", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    private func saveImageFile(data: Data, filename: String) {
        let url = imagesFolder().appendingPathComponent(filename)
        try? data.write(to: url)
    }

    private func deleteImageFile(filename: String) {
        let url = imagesFolder().appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    // MARK: - Persistence
    private struct Payload: Codable {
        var categories: [Category]
        var albums: [Album]
        var photos: [PhotoItem]
    }

    func save() {
        let payload = Payload(categories: categories, albums: albums, photos: photos)
        do {
            let data = try JSONEncoder().encode(payload)
            try data.write(to: dataURL)
        } catch {
            print("Save error:", error)
        }
    }

    func load() {
        guard FileManager.default.fileExists(atPath: dataURL.path) else { return }
        do {
            let data = try Data(contentsOf: dataURL)
            let payload = try JSONDecoder().decode(Payload.self, from: data)
            categories = payload.categories
            albums = payload.albums
            photos = payload.photos
        } catch {
            print("Load error:", error)
        }
    }

    private func seedIfNeeded() {
        guard categories.isEmpty else { return }
        categories = [
            Category(name: "Cars"),
            Category(name: "Portraits"),
            Category(name: "Events")
        ]
        save()
    }
}
