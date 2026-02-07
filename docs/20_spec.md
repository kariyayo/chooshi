# 仕様書

## 主な機能

| 機能 | 説明 |
|------|------|
| 投稿記録 | レーティング（1〜5段階）とタグを付けて体験を記録 |
| 月別表示 | 投稿を月ごとに分けてPageViewで閲覧 |
| 投稿削除 | 各投稿の「…」メニューから削除可能 |
| タグ一覧 | 全タグとその統計情報を一覧表示 |
| タグ分析 | タグごとの平均スコアやレーティング分布をグラフで可視化 |

## 画面構成

### TopScreen（メイン画面）

メイン画面。以下の要素で構成される。

- **TopAppBarWidget**: 月別タブスクロール、タグ一覧ボタン
- **TopBodyWidget**: PageViewで月別の投稿リストを表示
- **FloatingActionButton**: 投稿追加ダイアログを開く

### PostDialog（投稿追加ダイアログ）

FABをタップすると表示される。

- レーティング入力（1〜5段階の星評価）
- タグ入力（複数タグ対応）

### TagListScreen（タグ一覧画面）

全タグの一覧を表示。各タグの平均スコアや出現数を確認できる。

### TagDetailScreen（タグ詳細画面）

タグごとの詳細情報を表示。

- 平均スコア
- 出現数
- レーティング分布（棒グラフ）

## 画面遷移

```
TopScreen（メイン画面）
├── TopAppBarWidget
│   ├── 月別タブスクロール
│   └── タグ一覧ボタン → TagListScreen
├── TopBodyWidget
│   └── PageView（月別投稿表示）
│       └── PostRow
│           ├── タグチップ → TagDetailScreen
│           └── 削除メニュー
└── FloatingActionButton
    └── PostDialog
```

## データモデル

### Post（投稿）

| フィールド | 型 | 説明 |
|-----------|-----|------|
| timestamp | DateTime | 投稿日時 |
| rating | int | レーティング（1〜5） |
| tags | List\<String\> | タグのリスト |

### TagDetail（タグ統計情報）

| フィールド | 型 | 説明 |
|-----------|-----|------|
| label | String | タグ名 |
| mean | double | 平均スコア |
| count | double | 出現数 |
| ratings | Map\<int, int\> | レーティング分布 |

### Month（年月）

| フィールド | 型 | 説明 |
|-----------|-----|------|
| year | int | 年 |
| month | int | 月 |
