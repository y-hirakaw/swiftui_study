# swiftui_study
SwiftUI学習用

GitHub APIを使ったユーザ検索ができるアプリです。

## 技術周り(目標)

* Xcode16.1
* 下限OS16.6
* SVVS
* swift-dependencies
* swift-testing

## 仕様

* GitHubユーザ検索が出来る
* ユーザをタップするとユーザ情報とリポジトリ一覧が見れる
* リポジトリの詳細はSafariViewで閲覧できる

## 詳細

### ユーザ検索画面

* SearchUsersStore
  * 検索したユーザ一覧データを持つ
* SearchUsersViewState
  * 検索窓の値を持つ
  * Storeで検索したユーザデータを購読し、View表示用データに修正して自身のプロパティに反映する
* SearchUsersView
  * 検索窓
    * 文字入力するとViewStateを呼び出す
  * 検索結果を表示する
    * タップされた場合、ユーザ名をUserDetailViewに渡して遷移

### ユーザ詳細画面

* UserDetailStore
  * 表示するユーザ名
  * ユーザの情報
  * ユーザのリポジトリ一覧
* UserDetailViewState
  * 表示するデータをStoreから購読し、View表示用に修正して自身のプロパティに反映する
  * 特にUIに関係して保持する情報はない
* UserDetailView
  * ユーザ情報Viewとリポジトリ一覧を表示する

### ユーザ詳細のユーザ情報View

* UserDetailStore
  * こちらでも利用する
* DetailViewState
  * 表示するデータをStoreから購読し、View表示用に修正して自身のプロパティに反映する
  * 特にUIに関係して保持する情報はない
* DetailView
  * ユーザ情報を表示する