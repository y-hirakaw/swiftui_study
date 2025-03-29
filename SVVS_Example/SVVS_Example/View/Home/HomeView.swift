import SwiftUI

struct HomeView: View {
    @StateObject private var state: HomeViewState

    init(state: HomeViewState = HomeViewState()) {
        self._state = .init(wrappedValue: state)
    }

    var body: some View {
        VStack {
            Text(self.state.userGreeting)
            Spacer().frame(height: 20)
            Button("ログアウト", action: {
                Task {
                    await self.state.onLogoutTapped()
                }
            })
            Spacer().frame(height: 20)
            Button("ポスト", action: {
                Task {
                    await self.state.onPostTapped()
                }
            })
            Spacer().frame(height: 20)
            Button("天気", action: {
                Task {
                    await self.state.onWeatherTapped()
                }
            })
        }
        .alert(item: self.$state.alertMessage) { message in
            Alert(title: Text("通知"), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
}
