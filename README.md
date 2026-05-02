# zmqae.max

Algebraic Effects over ZMQ を Max/MSP で使うためのエクスターナルパッケージ。

## 概要

[zmq-algebraiceffect](https://github.com/zmq-algebraiceffect/protocol) プロトコルを実装した Max/MSP エクスターナル。Algebraic Effects のセマンティクス（perform / handle / resume）をネットワーク経由で実現する。

- **`zmqae.performer`** — 効果の要求元（DEALER）。effect を perform し、結果を受け取る。
- **`zmqae.handler`** — 効果の処理元（ROUTER）。effect を on で登録し、resume で結果を返す。

## 必要環境

- Max 8 以降
- macOS (Universal Binary: x86_64 + arm64) / Windows

## ビルド

```bash
mkdir build && cd build
cmake ..
cmake --build .
```

成果物は `externals/` に配置される。

## インストール

`externals/` ディレクトリを Max の search path に含めるか、パッケージとして `~/Documents/Max 8/Packages/zmqae.max/` にコピー。

## オブジェクト

### zmqae.performer

Algebraic Effects performer（ZMQ DEALER クライアント）。effect を perform し、ハンドラからの結果を受け取る。

#### Attributes

| Attribute | 型 | デフォルト | 説明 |
|-----------|-----|-----------|------|
| `@endpoint` | symbol | `tcp://localhost:5555` | ZMQ DEALER 接続先 |
| `@timeout` | int | `0` | タイムアウト (ms)。0 = ブロッキング |

#### Messages

| メッセージ | 引数 | 説明 |
|-----------|------|------|
| `connect` | なし | エンドポイントに接続 |
| `disconnect` | なし | 接続を閉じる |
| `perform` | `effect_name json_payload` | 効果を要求 |
| `bang` | なし | 保留中の結果をポーリング |
| `close` | なし | 接続を閉じる |

#### Outlets

| 番号 | 説明 |
|------|------|
| 0 (左) | `result <id> <json_value>` — perform の結果 |
| 1 (右) | エラーメッセージ (string) |

#### 使用例

```
[zmqae.performer @endpoint tcp://localhost:5555]
  |
  [perform Transcribe "{\"text\":\"hello\"}"]
  |
  [result]  ← "result <id> <json>"
```

### zmqae.handler

Algebraic Effects handler（ZMQ ROUTER）。effect のハンドラを登録し、perform 要求を処理する。

#### Attributes

| Attribute | 型 | デフォルト | 説明 |
|-----------|-----|-----------|------|
| `@endpoint` | symbol | `tcp://*:5555` | ZMQ ROUTER バインド先 |

#### Messages

| メッセージ | 引数 | 説明 |
|-----------|------|------|
| `connect` | なし | エンドポイントにバインド |
| `close` | なし | 接続を閉じる |
| `on` | `effect_name` | 効果ハンドラを登録 |
| `off` | `effect_name` | 効果ハンドラを解除 |
| `resume` | `id json_value` | 最終結果を返して要求を完了 |
| `resumepartial` | `id json_value` | 中間結果を返す（ストリーミング） |
| `error` | `id error_message` | エラーを通知 |
| `setparent` | `endpoint` | 親ルーターのエンドポイントを設定（未処理 effect の転送先） |
| `setnested` | `endpoint` | ネストされた perform 用のエンドポイントを設定 |
| `bang` | なし | 着信要求をポーリング |

#### Outlets

| 番号 | 説明 |
|------|------|
| 0 (左) | `<effect_name> <id> <json_payload>` — perform 要求 |
| 1 (中) | `resume <id> <json_value>` — resume のエコー |
| 2 (右) | エラーメッセージ (string) |

#### 使用例

```
[zmqae.handler @endpoint tcp://*:5555]
  |                   |               |
  [on Transcribe]    [resume]         [print error]
  |
  [Transcribe <id> <payload>]
  |
  [処理...]
  |
  [resume <id> "{\"result\":\"...\"}"]
```

## 高度な機能

### ストリーミング Resume

`resumepartial` で中間結果を返す。ハンドラは継続的に値を送信し、最後に `resume` で完了する。

### ハンドラフォワーディング

`setparent` で親ルーターを設定すると、未登録の effect は自動的に親に転送される。

### ネストされた Perform

`setnested` でネストエンドポイントを設定すると、ハンドラ内から新しい effect を perform できる。

## アーキテクチャ

```
┌──────────────────┐         ┌──────────────────┐
│  zmqae.performer │         │  zmqae.handler   │
│  (DEALER)        │ ──ZMQ── │  (ROUTER)        │
│                  │         │                  │
│  perform ──────> │         │  ──> on(effect)  │
│  <────── result  │         │  resume ──────>  │
└──────────────────┘         └──────────────────┘
                                    │
                              setparent ↓ (forwarding)
                              setnested ↓ (nested perform)
```

## 関連プロジェクト

- [protocol](https://github.com/zmq-algebraiceffect/protocol) — プロトコル仕様
- [zmq-algebraiceffect](https://github.com/zmq-algebraiceffect/zmq-algebraiceffect) — C++ ヘッダオンリーライブラリ
- [node-zmq-algebraiceffect](https://github.com/zmq-algebraiceffect/node-zmq-algebraiceffect) — Node.js アドオン

## ライセンス

MIT
