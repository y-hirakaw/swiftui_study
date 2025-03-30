import Combine
import Foundation

extension ObservableObject {
    
    /// 指定された Publisher を購読し、メインスレッドで値を受け取り、自身のプロパティに代入します。
    ///
    /// - Parameters:
    ///   - publisher: 購読対象の Publisher（`Failure` が `Never` である必要があります）
    ///   - keyPath: 値を代入する先のプロパティへの `ReferenceWritableKeyPath`
    ///   - cancellables: 購読を保持するための `Set<AnyCancellable>`
    ///
    /// 使用例:
    /// ```
    /// self.bind(userPublisher, to: \.user, storeIn: &cancellables)
    /// ```
    func bind<P: Publisher>(
        _ publisher: P,
        to keyPath: ReferenceWritableKeyPath<Self, P.Output>,
        storeIn cancellables: inout Set<AnyCancellable>
    ) where P.Failure == Never {
        publisher
            .receive(on: DispatchQueue.main)
            .assign(to: keyPath, on: self)
            .store(in: &cancellables)
    }

    /// 指定された Publisher を購読し、メインスレッドで値を受け取り、クロージャで任意の処理を実行します。
    ///
    /// - Parameters:
    ///   - publisher: 購読対象の Publisher（`Failure` が `Never` である必要があります）
    ///   - cancellables: 購読を保持するための `Set<AnyCancellable>`
    ///   - receiveValue: 値を受け取った際に実行されるクロージャ。`[weak self]` の使用は呼び出し元で管理してください。
    ///
    /// 使用例:
    /// ```
    /// self.bind(weatherPublisher, storeIn: &cancellables) { [weak self] weather in
    ///     self?.weather = weather
    /// }
    /// ```
    func bind<P: Publisher>(
        _ publisher: P,
        storeIn cancellables: inout Set<AnyCancellable>,
        receiveValue: @escaping (P.Output) -> Void
    ) where P.Failure == Never {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
            .store(in: &cancellables)
    }

    /// Optional な Publisher の値を `compactMap` でスキップし、メインスレッドで処理します。
    ///
    /// - Parameters:
    ///   - publisher: Optional を出力する Publisher（`Output` が `Optional`）
    ///   - cancellables: 購読を保持するための `Set<AnyCancellable>`
    ///   - receiveValue: 非 nil 値を受け取った際に実行されるクロージャ
    ///
    /// 使用例:
    /// ```
    /// self.bindSkippingNil(optionalPublisher, storeIn: &cancellables) { value in
    ///     self.value = value
    /// }
    /// ```
    func bindSkippingNil<Wrapped, P: Publisher>(
        _ publisher: P,
        storeIn cancellables: inout Set<AnyCancellable>,
        receiveValue: @escaping (Wrapped) -> Void
    ) where P.Output == Wrapped?, P.Failure == Never {
        publisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
            .store(in: &cancellables)
    }
}
