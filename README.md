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

* SearchUsersView
  * 検索窓
    * 文字入力するとViewStateが変更を検知し、Storeに検索を依頼する
  * 検索結果を表示する
    * ViewStateで購読しているusersが更新されると表示される
  * 検索結果をタップされた場合、Userオブジェクトをユーザ詳細画面に渡して遷移する
* UserRowView
  * ユーザ一覧のListItemのコンポーネント
* SearchUsersViewState
  * UserStoreのユーザ一覧データ、エラーメッセージを購読する
  * 検索窓の値を持つ
* UserStore
  * 検索したユーザ一覧データを保持する

### ユーザ詳細画面

* UserDetailView
  * ユーザ詳細画面のView、UserInfoView（ユーザ情報）とUserRepoView（リポジトリ一覧）の表示だけを担当する

#### ユーザ情報コンポーネント

* UserInfoView
  * ユーザ名、フォロー、フォロワー数を表示する
* UserInfoViewState
  * View表示時に、Storeにユーザ情報取得を依頼する
  * Storeのユーザ情報を購読する
* UserInfoStore
  * ユーザ情報を取得し保持する

#### ユーザリポジトリ一覧コンポーネント

* UserRepoView
  * リポジトリ一覧を表示する
* UserRepoViewState
  * View表示に、Storeにリポジトリ一覧取得を依頼する
  * Storeのリポジトリ一覧を購読する
* UserRepoStore
  * リポジトリ一覧を取得し保持する

* RepoLanguageView
  * リポジトリの言語一覧を表示する
* RepoLanguageViewState
  * View表示に、Storeに言語一覧取得を依頼する
  * Storeの言語一覧を購読する
* RepoLanguageLocalStore
  * 言語一覧を取得し、保持する

## SVVS説明

![SVVSのフロー図](/ReadmeImage/svvs.png "svvsフロー")
![SVVS例](/ReadmeImage/svvs_example.png "svvs例")

※SVVSはChatworkさんが発表したアーキテクチャです。こちらの情報を元に記載させて頂いてます。
https://fortee.jp/iosdc-japan-2023/proposal/edcec751-4f7f-46aa-9c17-92249a1a1771