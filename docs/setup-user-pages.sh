#!/usr/bin/env bash
#
# muscat-bell.github.io (User Pages) リポジトリを作成し、
# AdMob 認証用の app-ads.txt をドメイン直下で配信できる状態にするスクリプト。
#
# 前提: GitHub CLI (gh) がインストールされ、`gh auth login` 済みであること。
# 使い方: ./docs/setup-user-pages.sh
#
# 冪等性: 既にリポジトリが存在する場合は作成をスキップし、内容の更新のみ行う。

set -euo pipefail

OWNER="muscat-bell"
REPO="${OWNER}.github.io"
PUBLISHER_ID="pub-1867732787940396"

command -v gh >/dev/null 2>&1 || {
  echo "エラー: GitHub CLI (gh) が見つかりません。https://cli.github.com/ からインストールしてください。" >&2
  exit 1
}

gh auth status >/dev/null 2>&1 || {
  echo 'エラー: gh が未認証です。`gh auth login` を実行してください。' >&2
  exit 1
}

# 1. リポジトリを作成（既存ならスキップ）
if gh repo view "${OWNER}/${REPO}" >/dev/null 2>&1; then
  echo "==> ${OWNER}/${REPO} は既に存在します。内容の更新のみ行います。"
else
  echo "==> ${OWNER}/${REPO} を作成します"
  gh repo create "${OWNER}/${REPO}" \
    --public \
    --description "GitHub Pages のユーザーサイト。AdMob 認証用の app-ads.txt をドメイン直下で配信します。"
fi

# 2. 一時ディレクトリに clone してファイルを配置
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

echo "==> clone: ${WORKDIR}/${REPO}"
gh repo clone "${OWNER}/${REPO}" "${WORKDIR}/${REPO}" -- --quiet
cd "${WORKDIR}/${REPO}"

# 作成直後のリポジトリはコミットが無いため main を用意する。
# 既存リポジトリの場合は clone 時のブランチをそのまま使う（別ブランチを作らない）。
if ! git rev-parse --verify -q HEAD >/dev/null 2>&1; then
  git checkout -q -B main
fi
BRANCH="$(git symbolic-ref --short HEAD)"

# app-ads.txt（このファイルが AdMob にクロールされる正本）
cat > app-ads.txt <<EOF
# app-ads.txt — Authorized Sellers for Apps (IAB Tech Lab spec 1.0)
# 管理元: https://github.com/${OWNER}/app-legal (docs/app-ads-txt.md)

google.com, ${PUBLISHER_ID}, DIRECT, f08c47fec0942fa0
EOF

# Jekyll のビルド処理を無効化し、静的ファイルをそのまま配信させる
touch .nojekyll

# ルートが 404 にならないよう法的情報ページへ誘導する
cat > index.html <<'EOF'
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>muscat-bell</title>
<link rel="canonical" href="/app-legal/">
<meta http-equiv="refresh" content="0; url=/app-legal/">
</head>
<body>
<p><a href="/app-legal/">アプリ法的情報へ移動</a></p>
</body>
</html>
EOF

# 3. commit & push
git add -A
if git diff --cached --quiet; then
  echo "==> 変更はありません"
else
  git commit -q -m "AdMob 認証用の app-ads.txt を追加"
  git push -q -u origin "${BRANCH}"
  echo "==> push しました (${BRANCH})"
fi

echo
echo "完了しました。数分後に以下で配信を確認してください:"
echo "  curl -sSI https://${REPO}/app-ads.txt   # 200 / content-type: text/plain"
echo "  curl -sS  https://${REPO}/app-ads.txt"
echo
echo "Pages が有効になっていない場合は Settings → Pages → Source を"
echo "'Deploy from a branch' / main / (root) に設定してください。"
