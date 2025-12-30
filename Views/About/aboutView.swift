import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 56))
                        VStack(alignment: .leading) {
                            Text("Your Name")
                                .font(.title.bold())
                            Text("Photographer • Videographer")
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    Text("Bio")
                        .font(.headline)
                    Text("Write a short bio here. Mention your style, niche (cars, weddings, portraits), and experience.")
                        .foregroundStyle(.secondary)

                    Text("Contact")
                        .font(.headline)
                        .padding(.top, 6)

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Instagram: @yourhandle", systemImage: "camera")
                        Label("Email: you@example.com", systemImage: "envelope")
                        Label("WhatsApp: +971 XX XXX XXXX", systemImage: "phone")
                    }
                    .foregroundStyle(.secondary)

                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("About")
        }
    }
}
