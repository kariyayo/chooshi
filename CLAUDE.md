# Chooshi

日々の体験を記録・評価するFlutterアプリ。

## ドキュメント

@docs/10_prd.md
@docs/20_spec.md
@docs/30_system_design.md

## クイックリファレンス

### ビルド・実行

```bash
# 依存関係インストール
flutter pub get

# コード生成（Freezed, json_serializable）
flutter pub run build_runner build

# 実行
flutter run
```

### 主要ディレクトリ

- `lib/model/` - データモデル（Post, TagDetail, Month）
- `lib/screen/` - 画面コンポーネント
- `lib/dialog/` - ダイアログ
- `lib/storage/` - データ永続化層
