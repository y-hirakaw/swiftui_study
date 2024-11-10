import SwiftUI

struct LoginView: View {
    @StateObject private var state: LoginViewState

    init(state: LoginViewState = LoginViewState()) {
        self._state = .init(wrappedValue: state)
    }

    var body: some View {
        VStack {
            HStack {
                Text("ID:")
                    .frame(width: 100)
                TextField("IDを入力してください", text: self.$state.userId)
            }
            HStack {
                Text("Password:")
                    .frame(width: 100)
                TextField("パスワードを入力してください", text: self.$state.password)
            }
            Spacer()
                .frame(height: 40)
            Button(action: {
                Task {
                    await self.state.didTapLoginButton()
                }
            }) {
                Text("ログイン")
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
