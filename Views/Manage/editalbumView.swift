import SwiftUI

struct EditAlbumView: View {
    @EnvironmentObject var store: PortfolioStore
    @Environment(\.dismiss) private var dismiss

    @State var album: Album
    @State private var showDeleteConfirm = false

    var body: some View {
        Form {
            Section("Album Info") {
                TextField("Title", text: $album.title)
                TextField("Location", text: $album.location)
                DatePicker("Date", selection: $album.date, displayedComponents: .date)
                Toggle("Hidden in Client Mode", isOn: $album.isHidden)
            }

            Section("Description") {
                TextEditor(text: $album.description)
                    .frame(height: 140)
            }

            Section {
                Button("Save Changes") {
                    store.updateAlbum(album)
                    dismiss()
                }

                Button("Delete Album", role: .destructive) {
                    showDeleteConfirm = true
                }
            }
        }
        .navigationTitle("Edit Album")
        .confirmationDialog("Delete this album?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                store.deleteAlbum(album)
                dismiss()
            }
        }
    }
}
