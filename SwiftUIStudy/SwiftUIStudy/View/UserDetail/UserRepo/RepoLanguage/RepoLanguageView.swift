import SwiftUI

struct RepoLanguageView: View {
    @StateObject private var state: RepoLanguageViewState
    let userName: String
    let repositoryName: String

    init(_ userName: String, _ repositoryName: String) {
        self._state = .init(wrappedValue: .init())
        self.userName = userName
        self.repositoryName = repositoryName
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {  // 横スクロール可能にする
            HStack {
                if let languages = self.state.languages {
                    ForEach(languages.languages, id: \.self) { item in
                        Text(item)
                            .padding(.horizontal, 4)  // 言語間のスペースを少し追加
                            .background(Color.gray.opacity(0.1))  // 見やすいように背景色を追加
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding(4)
        }
        .frame(height: 30)  // 高さを固定することで、無駄なスペースを避ける
        .task {
            Task {
                await self.state.onAppear(self.userName, self.repositoryName)
            }
        }
    }
}
