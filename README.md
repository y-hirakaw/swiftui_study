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

### 共通Store

* 検索したユーザの一覧データ、および詳細情報を持つ
* SearchUsersViewとUserDetailViewの両方からアクセス可能にする

### ユーザ検索画面

* UserStore
  * 検索したユーザ一覧データを保持し、詳細画面で選択されたユーザ情報を渡す
* SearchUsersViewState
  * 検索窓の値を持つ
  * UserStoreで検索したユーザデータを購読し、View表示用データに修正して自身のプロパティに反映する
* SearchUsersView
  * 検索窓
    * 文字入力するとViewStateを呼び出す
  * 検索結果を表示する
    * タップされた場合、UserStoreでユーザ詳細を取得してからUserDetailViewに遷移

### ユーザ詳細画面

* UserStore
  * UserStore内にある選択されたユーザの詳細情報を参照
* RepositoryStore
  * 表示するユーザのリポジトリ一覧を管理
* UserDetailViewState
  * 表示するデータをUserStoreから購読し、View表示用に修正して自身のプロパティに反映する
  * 特にUIに関係して保持する情報はない
* UserDetailView
  * ユーザ情報Viewとリポジトリ一覧を表示する

### ユーザ詳細のユーザ情報View

* UserInfoView
  * ユーザ情報を表示する

### ユーザ詳細のリポジトリ一覧View

* UserRepositoryListView
  * ユーザリポジト一覧を表示する