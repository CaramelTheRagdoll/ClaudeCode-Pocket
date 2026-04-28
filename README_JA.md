[English](README.md) | [中文](README_CN.md) | [日本語](README_JA.md)

# ClaudeCode-Pocket

**真のポータブル Claude Code for Windows** — 全依存関係をバンドル、どこでも実行可能。

---

## 特徴

- **真のポータブル** — Node.js + Git for Windows を完全バンドル、システム依存ゼロ
- **柔軟な切り替え** — portable / system / hybrid の3つのランタイムモード
- **すぐに使える** — 環境変数の設定不要、システムPATHを汚染しない
- **ワンクリック起動** — `claude.cmd` をダブルクリックするだけ
- **コンテキストメニュー** — 任意のフォルダを右クリックで Claude Code を起動
- **ワンクリック更新** — `update.cmd` で最新バージョンにアップデート
- **設定は常に一緒** — 全ての Claude Code 設定はポータブルディレクトリ内に保存、USBで持ち運べる
- **CC Switch 内蔵** — ポータブル CC Switch で Provider / MCP / 使用量を管理

---

## ディレクトリ構成

```
ClaudeCode-Pocket/
├── claude.cmd              ← 🚀 ダブルクリックで Claude Code を起動
├── switch-runtime.cmd      ← 🔄 ランタイムモード切替（portable/system/hybrid）
├── update.cmd              ← 📦 最新版にアップデート
├── setup-context-menu.cmd  ← 🔗 右クリックメニューを登録
├── remove-context-menu.cmd ← ❌ 右クリックメニューを削除
├── launcher.cmd            ← 📂 コンテキストメニュー用ランチャー（フォルダパス自動引継ぎ）
├── build.cmd               ← 🔧 スクラッチビルド（初回使用 / 再パッケージ）
├── portable.ini            ← ⚙️ ランタイムモード設定（portable/system/hybrid）
├── README.md               ← 📖 本ファイル
├── runtime/
│   ├── node/               ← Node.js v22 ランタイム（約94 MB）
│   ├── npm/                ← Claude Code および npm 依存（約483 MB）
│   └── git/                ← Git for Windows Portable（約391 MB）
├── config/                 ← npm グローバル設定（npmrc）
├── cc-switch/              ← CC Switch ポータブル版（Provider/MCP/使用量管理）
│   ├── CC Switch.exe       ← ダブルクリックで CC Switch を起動
│   └── ...                 ← 付属ファイル
└── data/
    ├── home/               ← ユーザーホームディレクトリ（.claude/ 設定の保存先）
    └── npm-cache/          ← npm キャッシュディレクトリ
```

**総容量**：約 1 GB（CC Switch 含む）

---

## クイックスタート

### 方法1：ビルド済みを使う

1. [Releases](https://github.com/CaramelTheRagdoll/ClaudeCode-Pocket/releases) から最新の ZIP をダウンロード
2. 任意のフォルダ（またはUSBメモリ）に展開
3. `claude.cmd` をダブルクリックで起動
4. 初回起動時にログイン：
   ```
   claude auth login
   ```
5. 使い始める！

### 方法2：ソースからビルド

> **`build.cmd` は破壊的操作です！** 実行前に以下のリスクを理解してください：
>
> | リスク | 説明 |
> |------|-------------|
> | **既存ランタイムの上書き** | `runtime/node/` と `runtime/npm/` が再ダウンロード・置換されます |
> | **インターネット接続必須** | nodejs.org と npmjs.org から約 110 MB をダウンロード |
> | **ディスク容量が必要** | 最低 1.5 GB の空き容量（ダウンロード + 展開 + インストール） |
> | **時間がかかる** | 初回ビルドは約5〜10分（ネットワーク速度に依存） |
>
> **安全機構**：
> 1. 既存インストール検出 — `YES` と入力してビルドを確認
> 2. 操作確認 — 再度 `YES` と入力して開始
> 3. 自動バックアップ + ロールバック — ビルド前に現在のランタイムをバックアップ、失敗時に自動復元
>
> **`data/` ディレクトリ（設定、認証情報）は build.cmd によって一切変更されません。**

1. `git clone https://github.com/CaramelTheRagdoll/ClaudeCode-Pocket.git`
2. `build.cmd` をダブルクリック
3. プロンプトを読み、`YES` と入力して確認
4. ビルド完了を待つ
5. `claude.cmd` をダブルクリックで起動

---

## コンテキストメニュー連携

### 登録

`setup-context-menu.cmd` をダブルクリック。登録後：

- **フォルダ内の空白で右クリック** → "Open Claude Code Here"
- **フォルダを右クリック** → "Open Claude Code Here"

### 削除

`remove-context-menu.cmd` をダブルクリックでレジストリエントリをクリーンアップ。

> レジストリは `HKCU`（現在のユーザー）以下に書き込まれ、管理者権限は不要です。
> フォルダを移動した後は `setup-context-menu.cmd` を再実行してください（レジストリは絶対パスを保存します）。

---

## Claude Code の更新

`update.cmd` をダブルクリックで npm 経由で最新バージョンに自動更新します。

---

## ランタイムモード切替

ClaudeCode-Pocket は3つのランタイムモードをサポートしており、`switch-runtime.cmd` または `portable.ini` の編集で切り替えられます。

### モード比較

| モード | Node.js | Git | ユースケース |
|------|---------|-----|----------|
| **portable** | ✅ バンドル | ✅ バンドル | デフォルト。システム依存ゼロ、USBでどこでも実行 |
| **system** | 🔗 システム | 🔗 システム | マシンに Node.js + Git が既にインストール済み |
| **hybrid** | ✅ バンドル | 🔗 システム | バンドル版 Claude Code + 新しいシステム Git を使用 |

### 切り替え方法

**方法1：対話式スクリプト（推奨）**

`switch-runtime.cmd` をダブルクリック。以下の処理を行います：
1. インストール済みの Node.js / Git バージョンを自動検出
2. ポータブル版 vs システム版の比較を表示
3. モードを選択
4. `portable.ini` に書き込み、`claude.cmd` 再起動で反映

**方法2：手動編集**

`portable.ini` を開き `RUNTIME_MODE` を変更：
```ini
RUNTIME_MODE=portable    ; または system, hybrid
```

### 起動時表示

`claude.cmd` 起動時に現在のモードとランタイムソースが表示されます：

```
 Starting Claude Code...
 ──────────────────────────────────────────
  Mode:  portable
  Node:  ...\runtime\node\node.exe [portable]
  Git:   ...\runtime\git [portable]
  Home:  ...\data\home
 ──────────────────────────────────────────
```

> モード切替後は **`claude.cmd` を再起動** してください。
> `HOME` はモードに関わらず常にポータブル版の `data/home/` を指します。

---

## CC Switch — Provider 管理

[CC Switch](https://github.com/farion1231/cc-switch) は AI コーディング CLI の設定を統合管理するクロスプラットフォームデスクトップツールで、ポータブル版としてバンドルされています。

### 主な機能

| 機能 | 説明 |
|---------|-------------|
| **Provider 管理** | 50以上のプリセット（AWS Bedrock、NVIDIA NIM 等）、ワンクリックインポート/切替、ドラッグ&ドロップ並べ替え、インポート/エクスポート |
| **ローカルプロキシとフェイルオーバー** | フォーマット変換、自動フェイルオーバー、サーキットブレーカー、プロバイダーヘルスモニタリング |
| **統一 MCP 管理** | Claude Code / Codex / Gemini CLI / OpenCode 間で MCP サーバーを管理、双方向同期 |
| **プロンプト管理** | Markdown エディタ、アプリ間同期（CLAUDE.md / AGENTS.md / GEMINI.md） |
| **スキル管理** | GitHub リポジトリや ZIP からワンクリックインストール、シンボリックリンク対応 |
| **使用量・コスト追跡** | 消費ダッシュボード、リクエストログ、トークン統計、トレンドチャート、カスタムモデル価格設定 |
| **セッション管理** | 全アプリの会話履歴を閲覧、検索、復元 |
| **クラウド同期** | Dropbox、OneDrive、iCloud、NAS、WebDAV 対応 |
| **システムトレイ** | メインウィンドウを開かずにプロバイダー切替、即時反映 |
| **ディープリンク** | `ccswitch://` URL でプロバイダーやMCP設定をインポート |

### CC Switch の起動

1. `cc-switch/` フォルダを開く
2. `CC Switch.exe` をダブルクリックで起動
3. 初回使用時に既存の Claude Code 設定をデフォルトプロバイダーとしてインポート

### Claude Code との連携

1. `claude.cmd`（Claude Code）を起動
2. `CC Switch.exe` を起動
3. CC Switch でプロバイダーを追加/切替 → **Claude Code を再起動せずに反映**
4. 公式ログインに戻す場合：「Official Login」プリセットを追加 → Claude Code を再起動 → ログインフローに従う

> CC Switch のデータは `data/home/.cc-switch/` に保存され（HOME 環境変数に追従）、USBメモリと一緒に持ち運べます。

### CC Switch の更新

1. [Releases ページ](https://github.com/farion1231/cc-switch/releases/latest) から最新の `CC-Switch-vX.X.X-Windows-Portable.zip` をダウンロード
2. 展開して `cc-switch/` フォルダ内のファイルを上書き

---

## USBメモリでの使用

1. `ClaudeCode-Pocket` フォルダ全体を USB メモリにコピー
2. 任意の Windows PC で `claude.cmd` をダブルクリックで実行
3. 全ての設定は `data/home/.claude/` に保存され、USBメモリと一緒に移動
4. 新しいPCでコンテキストメニューを使う場合は `setup-context-menu.cmd` を一度実行

---

## 技術詳細

### 起動プロセス

`claude.cmd` は起動時に以下を実行します：

1. `portable.ini` から `RUNTIME_MODE` を読み取り
2. モードに基づいて Node.js と Git のソースを選択（バンドル版またはシステム版）
3. `PATH` を構築：バンドルパス優先（portable/hybrid）、またはシステムのみ（system）
4. `CLAUDE_CODE_GIT_BASH_PATH` に適切な Git Bash を設定
5. `HOME` を `data/home/` にリダイレクト — 設定は常にポータブル版と一緒
6. `NPM_CONFIG_CACHE` を `data/npm-cache/` にリダイレクト
7. 必要なランタイムの存在を検証、不足時はエラー
8. Claude Code を起動

### 主要環境変数

| 変数 | 目的 | モード依存 |
|----------|---------|:---:|
| `CLAUDE_CODE_GIT_BASH_PATH` | Git Bash の場所 — portable/hybrid ではバンドル版、system ではシステム版 | あり |
| `DISABLE_INSTALLATION_CHECKS` | 1 に設定、インストールチェックをスキップ | なし |
| `HOME` | `data/home/` にリダイレクト、設定はポータブル版と一緒に移動 | なし |
| `NPM_CONFIG_CACHE` | npm キャッシュをポータブルディレクトリ内に保存 | あり (portable/hybridのみ) |
| `PATH` | portable: バンドル優先; system: システムのみ; hybrid: バンドル Node + システム Git | あり |

### なぜ Git Bash が必要なのか？

Claude Code は Windows 上でシェルコマンドを実行するために Git Bash が**必須**です。システムレベルの Git for Windows がない場合、`CLAUDE_CODE_GIT_BASH_PATH` 環境変数でポータブル Git Bash の場所を Claude Code に伝える必要があります。これが他のサードパーティ製ポータブル版との最大の違いです——ほとんどの版はこの問題を解決していません。

---

## 既知の制限

- **Windows 専用**（macOS / Linux 非対応）
- **初回使用時にインターネット接続が必要**（Anthropic アカウントログイン）
- **大容量**（約 1 GB）— Git for Windows Portable と CC Switch を完全バンドルしているため
- **フォルダ移動後にコンテキストメニューの再登録が必要**（レジストリは絶対パスを保存）

---

## ライセンス

- **Claude Code**: © Anthropic — 利用は[利用規約](https://www.anthropic.com/legal/commercial-terms)に従います
- **Node.js**: MIT License
- **Git for Windows**: GPLv2
- **CC Switch**: MIT License — [github.com/farion1231/cc-switch](https://github.com/farion1231/cc-switch)
- **本リポジトリのビルドスクリプト**: MIT License
