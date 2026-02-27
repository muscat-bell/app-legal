# app-legal

複数のAndroidアプリの法的ドキュメント（プライバシーポリシー・利用規約・データ削除ポリシー・特商法表記など）を管理し、GitHub Pages で公開するためのリポジトリです。

## 公開URL

`https://muscat-bell.github.io/app-legal/`

| アプリ | 文書種別 | URL |
|--------|----------|-----|
| app1 | プライバシーポリシー | `/app-legal/app1/privacy/` |
| app1 | 利用規約 | `/app-legal/app1/terms/` |
| app2 | プライバシーポリシー | `/app-legal/app2/privacy/` |

## ディレクトリ構成

```
app-legal/
├── .github/
│   ├── copilot-instructions.md   # Copilot 利用ガイドライン（日本語使用）
│   └── workflows/
│       └── deploy.yml            # GitHub Actions ワークフロー
├── _apps/                        # Jekyll collection（各アプリの法的ドキュメント）
│   ├── app1.md                   # サンプルアプリ1 プライバシーポリシー
│   ├── app2.md                   # サンプルアプリ2 プライバシーポリシー
│   └── app3.md                   # サンプルアプリ3 プライバシーポリシー
├── _data/
│   └── doc_types.yml             # 文書種別ラベル定義
├── _layouts/
│   ├── default.html              # 共通レイアウト
│   └── app.html                  # 法的ドキュメント用レイアウト
├── _includes/
│   └── head.html                 # HTML <head>
├── assets/
│   └── css/
│       └── style.css             # スタイルシート
├── _config.yml                   # Jekyll 設定
├── Gemfile                       # Ruby 依存関係
└── index.md                      # トップページ（アプリ・文書種別一覧）
```

## URL 構造

各ドキュメントのURL は `/<app_id>/<doc_type>/` の形式です。

| `doc_type` 値 | 文書種別 |
|---------------|---------|
| `privacy` | プライバシーポリシー |
| `terms` | 利用規約 |
| `data-deletion` | データ削除ポリシー |
| `tokusho` | 特定商取引法に基づく表記 |

新しい文書種別を追加する場合は `_data/doc_types.yml` にエントリを追加してください。

## 新しいドキュメントを追加する手順

### 1. ファイルを作成する

```bash
touch _apps/myapp-terms.md
```

### 2. front matter を記述する

```yaml
---
app_name: "マイアプリ"
app_id: "myapp"
doc_type: "terms"
description: "マイアプリの利用規約です。"
lang: ja
version: "1.0"
last_updated: "2026-02-27"
---
```

`doc_type` に指定できる値は `privacy`・`terms`・`data-deletion`・`tokusho` です（`_data/doc_types.yml` 参照）。

### 3. 本文を Markdown で記述する

### 4. `main` ブランチへ push する

GitHub Actions が自動デプロイします。  
公開URL: `https://muscat-bell.github.io/app-legal/myapp/terms/`

## 新しいアプリのプライバシーポリシーを追加する

```yaml
# _apps/myapp.md
---
app_name: "マイアプリ"
app_id: "myapp"
doc_type: "privacy"
description: "マイアプリのプライバシーポリシーです。"
lang: ja
version: "1.0"
last_updated: "2026-02-27"
---
Markdown でポリシー本文を記述…
```

公開URL: `https://muscat-bell.github.io/app-legal/myapp/privacy/`

## 英語版を追加する手順

```yaml
# _apps/myapp-en.md
---
app_name: "My App"
app_id: "myapp"
doc_type: "privacy"
description: "Privacy policy for My App."
lang: en
version: "1.0"
last_updated: "2026-02-27"
---
```

## デプロイの仕組み

1. `main` ブランチへの push をトリガーに GitHub Actions が起動します。
2. `actions/checkout` でリポジトリを取得します。
3. `ruby/setup-ruby` で Ruby 環境をセットアップします。
4. `actions/configure-pages` でPages設定を取得します。
5. `bundle exec jekyll build` でサイトをビルドします。
6. `actions/upload-pages-artifact` でビルド成果物をアップロードします。
7. `actions/deploy-pages` で GitHub Pages へデプロイします。

> **注意**: GitHub リポジトリの Settings → Pages → Source を **"GitHub Actions"** に設定してください。

## ローカル開発

```bash
bundle install
bundle exec jekyll serve
# http://localhost:4000/app-legal/ でプレビュー
```