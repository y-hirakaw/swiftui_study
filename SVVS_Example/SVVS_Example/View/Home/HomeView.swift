import SwiftUI

struct HomeView: View {
    @StateObject private var state: HomeViewState

    init(state: HomeViewState = HomeViewState()) {
        self._state = .init(wrappedValue: state)
    }

    var body: some View {
        VStack {
            Text(self.state.userGreeting)
        }
    }
}
