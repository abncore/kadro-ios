import SwiftUI

struct AddAlbumView: View {
    @EnvironmentObject var store: PortfolioStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategoryId: UUID?
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var location: String = ""
    @State private var date: Date = Date()
    @State private var isHidden: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Select", selection: $selectedCategoryId) {
                        ForEach(store.categories) { cat in
                            Text(cat.name).tag(Optional(cat.id))
                        }
                    }
                }

                Section("Album Info") {
                    TextField("Title", text: $title)
                    TextField("Location (optional)", text: $location)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Toggle("Hidden in Client Mode", isOn: $isHidden)
                }

                Section("Description") {
                    TextEditor(text: $desc)
                        .frame(height: 120)
                }

                Button("Create Album") {
                    guard let cid = selectedCategoryId else { return }
                    let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !t.isEmpty else { return }
                    store.addAlbum(categoryId: cid, title: t, description: desc, location: location, date: date, isHidden: isHidden)
                    dismiss()
                }
            }
            .navigationTitle("Add Album")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                if selectedCategoryId == nil { selectedCategoryId = store.categories.first?.id }
            }
        }
    }
}
