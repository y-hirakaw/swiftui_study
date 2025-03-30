import Foundation
import SwiftUI

struct AlertState: Identifiable {
    let id = UUID()
    var title = "メッセージ"
    var message: String
    @State var isPresented: Bool = false
    let error: Error?
    let info: InfoType?

    enum InfoType {
        case postSuccess

        var message: String {
            switch self {
            case .postSuccess:
                return "投稿が完了しました!"
            }
        }
    }

    init(error: Error?) {
        self.info = nil
        if let error = error {
            self.isPresented = true
            self.error = error
            self.message = "エラーが発生しました: \(error.localizedDescription)"
        } else {
            self.isPresented = false
            self.error = nil
            self.message = ""
        }
    }

    init(info: InfoType) {
        self.info = info
        self.message = info.message
        self.isPresented = true
        self.error = nil
    }
}
