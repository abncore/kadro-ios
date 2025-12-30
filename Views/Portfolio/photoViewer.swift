import SwiftUI

struct PhotoViewerView: View {
    @EnvironmentObject var store: PortfolioStore
    let albumId: UUID
    let startPhotoId: UUID

    @State private var selection: UUID?

    var body: some View {
        let items = store.photosForAlbum(albumId)

        TabView(selection: $selection) {
            ForEach(items) { item in
                ZoomableImage(uiImage: store.loadUIImage(filename: item.filename))
                    .tag(item.id)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .onAppear { selection = startPhotoId }
        .background(.black)
    }
}

private struct ZoomableImage: View {
    let uiImage: UIImage?

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(1, lastScale * value)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation { scale = (scale == 1 ? 2 : 1); lastScale = scale }
                        }
                } else {
                    Image(systemName: "photo")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.system(size: 60))
                }
            }
        }
    }
}
