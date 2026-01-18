import SwiftUI
import Kingfisher

struct Avatar: View {

    var url: String
    var size: CGFloat
    var seed: String

    init(url: String = "https://api.dicebear.com/9.x/adventurer-neutral/png",
         size: CGFloat = 72,
         seed: String = UUID().uuidString) {
        self.size = size
        self.seed = seed
        self.url = url
    }

    var body: some View {
        KFImage(URL(string: "\(url)?size=\(size)&seed=\(seed)"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .clipped()
    }
}

#Preview {
    Avatar()
}
