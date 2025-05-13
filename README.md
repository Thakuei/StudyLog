# StudyLog

## 概要
StudyLogは、学習記録を管理するためのアプリケーションです。このプロジェクトは、Ruby on Rails(APImode)をBEに、Next.jsをFEに採用したSlackアプリケーションです。

## 仕様書
- https://www.notion.so/StudyLog-1dbd7100621d8043a2c9d890ef688261?pvs=4

## SlackAPI(コマンド作成場所)
- https://api.slack.com/apps/A08QF9LUNGK/slash-commands?saved=1
- 

## 技術スタック
- Ruby on Rails
- Next.js(node.js) 
- Docker
- ngrok(localでの検証用)

## デプロイ
- backend → Railway
  - Railwayのログイン権限は寺田しか持ってないので寺田がマージデプロイを現時点では全て担当します。
- frontend → Versel予定
  - フロント側の人材がアサインされ次第開発を行う予定

## セットアップ
- Docker上で動いているため、Dockerをインストールしてください。Dockerコンテナが起動している前提でセットアップしてください。

1. このリポジトリのクローン
    ```bash
    git clone リポジトリ
    ```

2. build
    ```bash
    docker compose build
    ```

3. コンテナの起動
    ```bash
    docker compose up
    ```

4. BEコンテナに入る
    ```bash
    docker compose exec backend bash
    ```

5. DBを作成する
    ```bash
    bundle exec rails db:migrate:create 
    ```
    ```bash
    bin/rails db:migrate:create
    ```

6. migrationを読み込む
    ```bash
    bundle exec rails db:migrate:migrate
    ```
    ```bash
    bin/rails db:migrate:migrate
    ```

7. 

## 環境変数
- `.env`に以下のように配置してください。
```bash
RAILS_API_KEY

```

## アクセス
- BE:`http://localhost3000`(APIモードなので起動しても何もないです。)
- FE:`http://localhost:3001`


## 開発ルール
- **PRには、```Resolve#issue番号```をつけてください**
- **必ずブランチを作成して開発を行ってください**