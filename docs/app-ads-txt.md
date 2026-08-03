# app-ads.txt セットアップ手順

AdMob の「アプリの確認を完了できませんでした / app-ads.txt の問題を確認して修正してください」
というエラーを解消するための手順です。

## 1. なぜ必要か

app-ads.txt は「このアプリの広告枠を販売する権限を持つ広告システムはどれか」を
デベロッパー自身が公開宣言する仕組み（IAB Tech Lab の Authorized Sellers for Apps 仕様）です。
なりすまし在庫（スプーフィング）対策として、AdMob をはじめ多くの広告システムが参照します。

AdMob はストア掲載情報のデベロッパー ウェブサイト URL を起点にこのファイルを探し、
見つかって形式が正しければ「アプリの確認」が完了します。

## 2. 配置場所のルール（最重要）

**app-ads.txt はドメインのルート直下にしか置けません。**

クローラーはストアに登録されたデベロッパー ウェブサイト URL から**ホスト名だけを取り出し、
パス部分を捨てて** `https://<ホスト名>/app-ads.txt` を取得します。
サブディレクトリに置いたファイルは一切クロールされません。

| URL | 判定 |
|-----|------|
| `https://muscat-bell.github.io/app-ads.txt` | ✅ クロールされる |
| `https://muscat-bell.github.io/app-legal/app-ads.txt` | ❌ クロールされない |

`github.io` は Public Suffix List に登録されているため、`muscat-bell.github.io` 自体が
ルートドメインとして扱われます。したがって配信には
**`muscat-bell.github.io` という名前の User Pages リポジトリ**が必要です
（このリポジトリ `app-legal` はプロジェクトページなので `/app-legal/` 配下にしか配信できません）。

Play Console のデベロッパー ウェブサイト URL は `https://muscat-bell.github.io/app-legal/`
のままで構いません。クローラーがパスを無視するため、変更は不要です。

## 3. セットアップ手順

### 3.1 User Pages リポジトリを作成する

1. GitHub で **`muscat-bell.github.io`** という名前の**パブリック**リポジトリを新規作成する
   （リポジトリ名はアカウント名と完全一致させること。大文字小文字は問わないが `.github.io` は必須）
2. デフォルトブランチ（`main`）のルートに以下の 2 ファイルを置く

**`app-ads.txt`**（このリポジトリの `app-ads.txt` をコピーし、パブリッシャー ID を実際の値に置換する）

```
google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
```

**`.nojekyll`**（空ファイル。Jekyll のビルド処理を無効化し、静的ファイルをそのまま配信させる）

> `index.html` を置いて `https://muscat-bell.github.io/app-legal/` へリダイレクトさせておくと、
> ルートが 404 にならず見栄えが良くなります（AdMob の確認自体には不要）。

### 3.2 GitHub Pages を有効化する

リポジトリの **Settings → Pages → Source** を **`Deploy from a branch`**、
ブランチを **`main` / `/ (root)`** に設定します。数分でデプロイされます。

### 3.3 パブリッシャー ID を確認する

AdMob 管理画面 → **設定 → アカウント情報 → パブリッシャー ID**
（`pub-` から始まる 16 桁の数字）をコピーします。

`AndroidManifest.xml` の AdMob App ID `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY` の
`~` より前の数字部分と同じ値です。

### 3.4 配信を確認する

```bash
curl -sSI https://muscat-bell.github.io/app-ads.txt
curl -sS  https://muscat-bell.github.io/app-ads.txt
```

以下をすべて満たしていることを確認します。

- HTTP ステータスが **200**（301/302 のリダイレクトを挟まないこと）
- `content-type` が **`text/plain`**
- 本文に `google.com, pub-..., DIRECT, f08c47fec0942fa0` の行が含まれる
- HTTPS で配信されている

### 3.5 AdMob で再確認する

AdMob 管理画面 → **アプリ → アプリを表示 → app-ads.txt** から再クロールをリクエストします。

**反映には時間がかかります。** Google のクローラーは毎日巡回しますが、
ステータスが更新されるまで **24 時間〜数日**かかることがあります。
ファイルが正しく配信できていればエラー表示が残っていても待てば解消します。

## 4. パブリッシャー ID をリポジトリシークレットにすべきか

**不要です。直接コミットして問題ありません。**

1. **app-ads.txt は公開されることが前提のファイル**です。固定 URL で誰でも取得できなければ
   Google が検証できません。リポジトリ内で秘匿しても公開サイト上で全世界に見えるため、
   秘匿性はまったく得られません。
2. **`pub-XXXXXXXXXXXXXXXX` は認証情報ではなく公開識別子**です。すでに `AndroidManifest.xml` の
   AdMob App ID に埋め込まれて APK に同梱され、広告リクエストごとに送信されています。
   API キーや署名鍵とは性質が異なります。
3. **シークレット化するとむしろ壊れやすくなります。** Jekyll のビルド時にシークレットから
   ファイルを生成する仕組みが必要になり、シークレットの未設定やタイポで
   **空または誤った app-ads.txt が無言で公開され、検証が落ちる**経路が生まれます。
   Pull Request 上で内容を目視レビューできなくなるのも不利です。
4. app-ads.txt は第三者が正規販売者を監査するためのファイルなので、
   Git 履歴に変更が残ること自体がメリットです。

**app-ads.txt には秘密情報を書かないでください。** 記述してよいのは
「広告システムのドメイン・パブリッシャー ID・関係性・認証局 ID」の 4 項目だけです。

## 5. メディエーション／他の広告ネットワークを追加した場合

利用する広告システムごとに 1 行ずつ追記します。各ネットワークの公式ドキュメントに
記載された行をそのままコピーしてください。

```
google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
applovin.com, XXXXXXXXXXXXXXXXXXXX, DIRECT
unityads.unity3d.com, XXXXXXX, DIRECT
```

- `DIRECT`: 自分が広告システムと直接契約している場合
- `RESELLER`: 第三者に再販を許可している場合

行が不足していると該当ネットワークの広告収益が失われるため、
メディエーションを追加するたびに更新してください。

## 6. うまくいかないときのチェックリスト

- [ ] `https://muscat-bell.github.io/app-ads.txt` が 200 で返るか（`/app-legal/` 配下ではない）
- [ ] リポジトリ名が `muscat-bell.github.io` と完全一致しているか
- [ ] リポジトリがパブリックか（プライベートだと GitHub Free では Pages を公開できない）
- [ ] Settings → Pages のソースが `main` / `/ (root)` になっているか
- [ ] Play Console のストア掲載情報にウェブサイト URL が設定され、公開反映済みか
- [ ] `robots.txt` でクローラーをブロックしていないか
- [ ] パブリッシャー ID の桁数・綴りが AdMob 管理画面の表示と一致しているか
- [ ] `pub-0000000000000000` のままになっていないか
- [ ] 全角文字・全角スペース・BOM が混入していないか（半角 ASCII のみで記述する）

## 参考

- [AdMob ヘルプ: app-ads.txt ガイド](https://support.google.com/admob/answer/9363762)
- [IAB Tech Lab: Authorized Sellers for Apps (app-ads.txt)](https://iabtechlab.com/ads-txt/)
