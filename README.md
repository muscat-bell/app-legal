# privacy-policies

複数のAndroidアプリのプライバシーポリシーを管理し、GitHub Pages で公開するためのリポジトリです。

## 公開URL

`https://muscat-bell.github.io/privacy-policies/`

| アプリ | URL |
|--------|-----|
| app1 | `/privacy-policies/app1/` |
| app2 | `/privacy-policies/app2/` |
| app3 | `/privacy-policies/app3/` |

## ディレクトリ構成

```
privacy-policies/
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions ワークフロー
├── _apps/                    # Jekyll collection（各アプリのポリシー）
│   ├── app1.md
│   ├── app2.md
│   └── app3.md
├── _layouts/
│   ├── default.html          # 共通レイアウト
│   └── app.html              # アプリポリシー用レイアウト
├── _includes/
│   └── head.html             # HTML <head>
├── assets/
│   └── css/
│       └── style.css         # スタイルシート
├── _config.yml               # Jekyll 設定
├── Gemfile                   # Ruby 依存関係
└── index.md                  # トップページ（アプリ一覧）
```

## 新しいアプリを追加する手順

1. `_apps/` ディレクトリに新しい Markdown ファイルを作成します。

```bash
touch _apps/myapp.md
```

2. 以下の front matter を記述します。

```yaml
---
app_name: "マイアプリ"
description: "マイアプリのプライバシーポリシーです。"
lang: ja
version: "1.0"
last_updated: "2026-02-27"
---
```

3. Markdown 形式でプライバシーポリシー本文を記述します。

4. `main` ブランチへ push すると GitHub Actions が自動デプロイします。

公開URL: `https://muscat-bell.github.io/privacy-policies/myapp/`

## 英語版を追加する手順

1. `_apps/` に英語版ファイルを作成します（例: `myapp-en.md`）。

```yaml
---
app_name: "My App"
description: "Privacy policy for My App."
lang: en
version: "1.0"
last_updated: "2026-02-27"
---
```

2. `_layouts/app.html` 内の言語切り替えリンクを必要に応じて追加します。

公開URL: `https://muscat-bell.github.io/privacy-policies/myapp-en/`

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
# http://localhost:4000/privacy-policies/ でプレビュー
```