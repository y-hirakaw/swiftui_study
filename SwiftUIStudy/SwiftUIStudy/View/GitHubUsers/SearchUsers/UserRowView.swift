import SwiftUI

struct UserRowView: View {
    let userName: String
    let avatarURL: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: self.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 40, height: 40)
            }
            Text(self.userName)
                .font(.headline)
                .padding(.leading, 8)
        }
    }
}
