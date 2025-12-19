# Redmine DevContainer 開発環境

このリポジトリは、Redmineの開発環境をVS Codeの**Dev Container**として簡単にセットアップできるようにしたものです。

## 📋 目次

- [概要](#概要)
- [前提条件](#前提条件)
- [セットアップ手順](#セットアップ手順)
- [使い方](#使い方)
- [含まれるサービス](#含まれるサービス)
- [環境変数の設定](#環境変数の設定)
- [トラブルシューティング](#トラブルシューティング)

## 概要

このプロジェクトでは、以下の開発環境が自動的に構築されます：

- **Ruby on Rails** 開発環境（Ruby 3.3系）
- **PostgreSQL** データベース
- **Selenium** ブラウザテスト環境
- **MailDev** メール送信テスト環境
- **mise** によるバージョン管理
- **GitHub CLI** サポート

## 前提条件

以下のソフトウェアがインストールされている必要があります：

1. **Docker Desktop**
   - [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
   - [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)

2. **Visual Studio Code**
   - [VS Code ダウンロード](https://code.visualstudio.com/)

3. **VS Code 拡張機能**
   - [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

4. **Redmine のソースコード**
   - このリポジトリと同じ階層に配置する必要があります

## セットアップ手順

### 1. Redmine のソースコードを準備

まず、Redmine のソースコードを取得します：

```bash
# このリポジトリの親ディレクトリに移動
cd /path/to/parent-directory

# Redmine のソースコードをクローン
git clone https://github.com/redmine/redmine.git

# ディレクトリ構成は以下のようになります：
# parent-directory/
# ├── redmine/                    # Redmine のソースコード
# └── easy-redmine-devcontainer/   # このリポジトリ
```

### 2. 環境変数ファイルを作成

`.devcontainer/.env` ファイルを作成し、Redmineのパスを設定します：

```bash
# .devcontainer/.env
REDMINE_PATH=../redmine
```

> **注意**: `REDMINE_PATH` は、このリポジトリからRedmineのソースコードへの相対パスを指定します。

### 3. Dev Container を起動

1. VS Code でこのリポジトリ（`redmine-devcontainer-oss`）を開きます

2. コマンドパレットを開きます：
   - Mac: `Cmd + Shift + P`
   - Windows: `Ctrl + Shift + P`

3. `Dev Containers: Reopen in Container` を選択します

4. 初回起動時は、以下の処理が自動的に実行されます（数分程度かかります）：
   - Dockerイメージのビルド
   - 必要なコンテナの起動
   - Ruby、Node.jsの最新バージョンのインストール
   - bash-itのインストール
   - その他の開発ツールのセットアップ

### 4. Redmineのセットアップ

Dev Container内で以下のコマンドを実行します：

```bash
# ワークスペースディレクトリに移動
cd /workspaces/redmine

# 依存関係をインストール
bundle install

# データベースのセットアップ
cp config/database.yml.example config/database.yml
# database.yml を編集して以下のように設定：
# development:
#   adapter: postgresql
#   database: redmine_development
#   host: db
#   username: vscode
#   password: vscode

# データベースを作成・初期化
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake redmine:load_default_data RAILS_ENV=development

# サーバーを起動
bundle exec rails server
```

## 使い方

### Redmine の起動

```bash
cd /workspaces/redmine
bundle exec rails server
```

ブラウザで `http://localhost:3000` にアクセスすると、Redmineが表示されます。

### デフォルトのログイン情報

- ユーザー名: `admin`
- パスワード: `admin`

## 含まれるサービス

### 1. アプリケーションコンテナ (app)

- Ruby 3.3系（Gemfileの制約に基づいて自動インストール）
- Rails
- mise（バージョン管理ツール）
- GitHub CLI

### 2. PostgreSQLデータベース (db)

- **ホスト**: `db`
- **ポート**: `5432`
- **ユーザー名**: `postgres`
- **パスワード**: `postgres`
- **データベース**: `postgres`

### 3. Selenium (selenium)

ブラウザテストを実行するためのSeleniumサーバーです。

- **Seleniumポート**: `4444`
- **VNCポート**: `5900`（画面を見ながらテスト可能）
- **ログポート**: `7900`

テストの様子を確認するには、ブラウザで `http://localhost:7900` にアクセスしてください。

### 4. MailDev (maildev)

開発中のメール送信をテストするための、ローカルメールサーバーです。

- **Webインターフェース**: `http://localhost:1080`
- **SMTPポート**: `1025`

Redmineから送信されたメールは、すべてこのMailDevで確認できます。

## 環境変数の設定

### 必須の環境変数

`.devcontainer/.env` ファイルに以下を設定します：

```bash
# Redmineのソースコードへのパス（相対パスまたは絶対パス）
REDMINE_PATH=../redmine
```

### オプションの環境変数

| 変数名 | デフォルト | 説明 |
|--------|-----------|------|
| `INSTALL_CLAUDE_CODE` | `true` | Claude Code のインストール有無 |
| `INSTALL_OPENAI_CODEX` | `true` | OpenAI Codex のインストール有無 |

```bash
# 例: Claude Code のみインストールする場合
INSTALL_CLAUDE_CODE=true
INSTALL_OPENAI_CODEX=false
```

GitHub CLIを使用する場合、`scripts/init.sh` が自動的にGitHubトークンを設定します。

## トラブルシューティング

### コンテナが起動しない

1. Dockerが正常に動作しているか確認してください：
   ```bash
   docker ps
   ```

2. `.devcontainer/.env` ファイルが存在し、`REDMINE_PATH` が正しく設定されているか確認してください

3. Redmineのソースコードが正しい場所に配置されているか確認してください

### データベース接続エラー

`config/database.yml` の設定を確認してください：

```yaml
development:
  adapter: postgresql
  database: redmine_development
  host: db
  username: postgres
  password: postgres
```

### ポートが使用中

他のアプリケーションが以下のポートを使用している場合、競合が発生します：

- `3000` - Rails サーバー
- `5432` - PostgreSQL
- `4444` - Selenium
- `1080` - MailDev Web UI
- `1025` - MailDev SMTP

競合する場合は、`docker-compose.yml` でポート番号を変更してください。

### Ruby または Node.js のバージョンエラー

`mise` を使って正しいバージョンがインストールされているか確認してください：

```bash
mise list
mise install
```

## ディレクトリ構成

```
easy-redmine-devcontainer/
├── .devcontainer/
│   ├── Dockerfile              # コンテナイメージの定義
│   ├── devcontainer.json       # Dev Container の設定
│   ├── docker-compose.yml      # サービスの定義
│   ├── create-db-user.sql      # データベース初期化スクリプト
│   └── .env                    # 環境変数（要作成）
├── scripts/
│   ├── init.sh                 # 初期化スクリプト
│   └── postCreateCommand.sh    # コンテナ作成後の実行スクリプト
├── .gitignore
└── README.md
```

## System Specの実行

System SpecはSeleniumを起動して行います。Seleniumはコンテナの一つとして起動されており、下記のコマンドでSystem Specを実行することができます。

```sh
SELENIUM_REMOTE_URL=http://selenium:4444 \
CAPYBARA_SERVER_HOST=0.0.0.0 \
CAPYBARA_SERVER_PORT=3001 \
CAPYBARA_APP_HOST=http://app:3001 \
GOOGLE_CHROME_OPTS_ARGS=headless,disable-gpu,no-sandbox,disable-dev-shm-usage \
bin/rails test:system
```

## 参考リンク

- [Redmine 公式サイト](https://www.redmine.org/)
- [VS Code Dev Containers ドキュメント](https://code.visualstudio.com/docs/devcontainers/containers)
- [mise ドキュメント](https://mise.jdx.dev/)

## ライセンス

このDevContainer設定は、Redmineの開発を支援するために提供されています。Redmine本体のライセンスについては、[Redmine公式サイト](https://www.redmine.org/)を参照してください。

