# display

このディレクトリは 8x8 マトリクス LED 表示の制御と、`frame_buffer` に対する描画処理を収めています。

簡単な使い方: 表示データを `frame_buffer` に書き込み、`HK_display` を周期的に呼ぶと LED に反映されます。

## ファイル一覧

- `display.s` — マトリクス LED 表示制御（`HK_display`, `HK_fb_clear`）
- `player_board_draw.s` — プレイヤーボードを `frame_buffer` に描画
- `rotate.s` — `frame_buffer` の回転/転置/反転処理
- `text.s` — テキスト流し表示（`HK_slide_text` 等）
- `write_number.s` — 数値表示（1桁/2桁）

備考: 各ファイル先頭のコメントに input/output を記載しています。詳細は各ファイルを参照してください。
