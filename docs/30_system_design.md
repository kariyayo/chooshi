# System Design Document

## プロジェクト構造

```
lib/
├── main.dart           # エントリーポイント、Riverpod初期化
├── model/              # データモデル
│   ├── post.dart       # 投稿データ
│   ├── tag_detail.dart # タグ統計情報
│   └── month.dart      # 年月情報
├── screen/             # 画面コンポーネント
│   ├── top_screen.dart          # メイン画面
│   ├── top_app_bar_widget.dart  # アプリバー
│   ├── top_body_widget.dart     # 投稿リスト表示
│   ├── tag_list_screen.dart     # タグ一覧画面
│   ├── tag_detail_screen.dart   # タグ詳細画面
│   ├── post_list_notifier.dart  # 投稿リスト状態管理
│   └── top_seleted_page_notifier.dart # ページ選択状態管理
├── dialog/             # ダイアログ
│   ├── post_dialog.dart       # 投稿追加ダイアログ
│   ├── post_add_form.dart     # フォームデータモデル
│   └── post_form_notifier.dart # フォーム状態管理
└── storage/            # データ永続化
    ├── post_store.dart # 投稿データの永続化
    ├── tag_store.dart  # タグデータの永続化
    └── prefs.dart      # SharedPreferencesラッパー
```

## 技術スタック

| カテゴリ | 技術 | 用途 |
|---------|------|------|
| 状態管理 | flutter_riverpod | NotifierProviderによるリアクティブな状態管理 |
| データモデル | freezed | イミュータブルなデータクラス生成 |
| シリアライズ | json_serializable | JSON変換コード生成 |
| 永続化 | shared_preferences | ローカルストレージ |
| UI | flutter_rating_bar | 星評価ウィジェット |
| チャート | fl_chart | 棒グラフ描画 |
| スクロール | scroll_to_index | スクロール位置制御 |
| 日付 | intl | 日付フォーマット |

## アーキテクチャ

### 状態管理

Riverpodを使用したリアクティブな状態管理を採用。

- `NotifierProvider`: 状態の保持と更新
- `AutoDispose`: リソースの自動解放

### データ永続化

SharedPreferencesにJSON形式でデータを保存。

- 投稿データ: `posts_YYYY MM` キーで月別に保存
- タグ情報: 個別・一覧形式で保存

### データフロー

```
UI (Screen/Dialog)
    ↓ ユーザー操作
Notifier (状態管理)
    ↓ 状態更新
Store (永続化層)
    ↓ 読み書き
SharedPreferences (ローカルストレージ)
```

### コード生成

以下のファイルはbuild_runnerで自動生成される。

- `*.freezed.dart`: Freezedによるイミュータブルクラス
- `*.g.dart`: json_serializableによるJSON変換コード

生成コマンド:
```bash
flutter pub run build_runner build
```
