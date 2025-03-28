# リポジトリの説明

* SVVSアーキテクチャを利用したリポジトリです。
  * SVVS_Example
    * SVVSアーキテクチャのサンプルコードです。
  * SwiftUIStudy
    * SVVSアーキテクチャを利用してGitHubAPIを利用してユーザ検索するアプリです。

# SVVSアーキテクチャについて

* SVVSは主にView, ViewState, Storeに分かれておりそれぞれ以下の責務があります。
  * View: SwiftUIを利用してUIコンポーネント表示を担当します。1つのViewStateを持ち、ViewStateのプロパティを購読してViewに反映します。
  * ViewState: Viewのプレゼンテーションロジックを担当します。Storeのデータを購読し表示用に加工します。複数のStoreを持ちます。
  * Store: シングルトンで、APIやDBなどから取得した値を信頼できる唯一の情報源のプロパティとして持ちます。
* View->ViewState->Store->(バインディング)ViewState->(バインディング)Viewという流れでデータが流れ単方向データフローを実現します。
* ViewStateが3つ以上のStoreを持つ必要がある時、UseCaseを間に挟みViewState->UseCase->Storeという流れになります。
  * これによりViewStateで購読しなければいけないのがUseCaseの数だけになります。
  * UseCaseはViewStateに必要な情報だけ渡す。
    * 一覧表示のレスポンスオブジェクト->そのままViewStateに渡す
    * レスポンスを受け取ったら画面遷移->shouldNavigateだけViewStateに渡す
    * エラーレスポンスを受け取ったらエラーアラート表示->アラート表示用のオブジェクトをViewStateに渡す
  * UseCaseはドメインロジックも必要に応じて持ちます
    * 20歳以上かつ1000ポイント以上保持ならSランク会員など
  * 表示用の加工はViewStateが持ちます。
    * 名字と名前を連結した文字列を返すなど
* UseCase, Store, Repositoryはprotocolを持ちます。

# SVVS_Exampleについて

## 
