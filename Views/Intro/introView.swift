import SwiftUI

struct IntroView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()

                Image(systemName: "camera.aperture")
                    .font(.system(size: 70, weight: .semibold))
                    .foregroundStyle(.white)

                Text("My Portfolio")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)

                Text("A clean, editable iPad portfolio for client meetings.\nAdd albums, import photos, and present offline.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 10) {
                    FeatureRow(icon: "square.grid.2x2", text: "Create categories & albums")
                    FeatureRow(icon: "photo.on.rectangle", text: "Import photos from Photos / Files")
                    FeatureRow(icon: "lock.fill", text: "Client Mode to hide private albums")
                }
                .padding()
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Spacer()

                Button(action: onContinue) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 28)
            Text(text)
                .foregroundStyle(.white.opacity(0.9))
            Spacer()
        }
        .font(.system(size: 16, weight: .medium))
    }
}
