import SwiftUI

struct Avatar: View {

    static private let url = "https://api.dicebear.com/9.x/adventurer-neutral/png"

    var size: CGFloat
    var seed: String

    init(size: CGFloat = 72, seed: String = UUID().uuidString) {
        self.size = size
        self.seed = seed
    }

    var body: some View {
        AsyncImage(url: URL(string: "\(Self.url)?size=\(size)&seed=\(seed)")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
        } placeholder: {
            Rectangle()
                .frame(width: size, height: size)
                .background(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    Avatar()
}
