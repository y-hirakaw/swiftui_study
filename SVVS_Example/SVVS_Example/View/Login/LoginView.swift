import SwiftUI

struct LoginView<State: LoginViewStateProtocol & ObservableObject>: View {
    @StateObject private var state: State

    init(state: State = LoginViewState()) {
        self._state = StateObject(wrappedValue: state)
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("ID:")
                        .frame(width: 100)
                    TextField("IDを入力してください", text: self.$state.userId)
                        .keyboardType(.emailAddress)
                }
                HStack {
                    Text("Password:")
                        .frame(width: 100)
                    SecureField("パスワードを入力してください", text: self.$state.password)
                        .keyboardType(.asciiCapable)
                }
                Spacer()
                    .frame(height: 40)
                if self.state.loginState == .notLoggedIn {
                    Button(action: {
                        Task {
                            await self.state.didTapLoginButton()
                        }
                    }, label: {
                        Text("ログイン")
                    })
                } else if self.state.loginState == .loggingIn {
                    ProgressView("ログイン中...")
                } else if self.state.loginState == .loggedIn {
                    EmptyView()
                }
            }
            .padding()
            .navigationDestination(isPresented: self.$state.shouldNavigateHome) {
                HomeView()
            }
            .task {
                Task {
                    await self.state.didAppear()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
