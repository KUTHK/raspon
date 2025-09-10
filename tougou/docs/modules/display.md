# 表示 (display)

Goal: 画面描画パイプラインとフォント / 回転 / 数値表示仕様を明確化。

## 対象ファイル

- `display/start.s`
- `display/display.s`
- `display/player_board_draw.s`
- `display/result.s`
- `display/rotate.s`
- `display/text.s`
- `display/write_number.s`

## 機能粒度

- 初期化: start.s
- 基本描画: display.s
- プレイヤーボード: player_board_draw.s
- 回転処理: rotate.s
- テキスト描画: text.s
- 数値表示: write_number.s
- 結果画面: result.s

## 描画順序 (仮)

1. 背景クリア
2. 可動オブジェクト描画
3. UI / スコア描画

## TODO

- カラーフォーマット / フレームバッファ仕様
- 文字フォント形式
