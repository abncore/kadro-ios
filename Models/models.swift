import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var coverPhotoId: UUID? = nil
}

struct Album: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var categoryId: UUID
    var title: String
    var description: String
    var date: Date = Date()
    var location: String = ""
    var coverPhotoId: UUID? = nil
    var isHidden: Bool = false
}

struct PhotoItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var albumId: UUID
    var filename: String
    var isFavorite: Bool = false
}
