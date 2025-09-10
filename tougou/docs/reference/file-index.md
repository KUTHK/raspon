# ファイル索引

Goal: どの機能がどのソースにあるか素早く辿れるようにする。

| ディレクトリ | 役割 | 代表例 |
|--------------|------|--------|
| init | 初期化 | GPIO_init.s |
| display | 描画 | display.s |
| game | ゲームロジック | ball.s |
| input | 入力取得 | switch.s |
| sound | 音源/BGM/SE | MS_bgm_list.s |
| include | 共通ヘッダ | common.h |

## 自動生成

`make file-index` で下記 AUTO セクションを更新。

<!-- AUTO-FILES:BEGIN -->
### 自動生成ファイル索引

| モジュール | パス | 概要 |
|-----------|------|------|
| init | init/GPIO_init.s | GPIO_init.s: GPIO初期化・LED/ディスプレイ/スピーカーIO設定 |
| init | init/main_test.s | main_test.s: メイン初期化・全体制御・タイマー設定 |
| init | init/PWM_init.s | PWM_init.s: PWM制御・初期化・クロック設定 |
| display | display/display.s | display.s: LEDマトリクス表示・frame_buffer制御 |
| display | display/player_board_draw.s | player_board_draw.s: プレイヤーボード描画・frame_buffer反映 |
| display | display/result.s | result.s: 勝敗決定時のフレームバッファ生成・表示 |
| display | display/rotate.s | rotate.s: frame_buffer回転・転置・軸反転 |
| display | display/start.s | start.s: スタート画面表示 |
| display | display/text.s | テキスト流し・回転・frame_buffer書き込み */ |
| display | display/write_number.s | (no summary) |
| game | game/ball.s | ball.s: ボール制御・座標・衝突・初期化・状態管理 |
| game | game/GoalJudg.s | GoalJudg.s: ゴール判定・出力管理 |
| game | game/player_board.s | player_board.s: プレイヤーボード制御・座標管理・入力反映 |
| game | game/point.s | point.s: 得点管理・勝者判定・加算処理 |
| game | game/score.s | score.s: スコア表示・勝敗判定・状態遷移 |
| input | input/switch.s | switch.s: スイッチ入力取得・状態保存・初期化 |

<!-- AUTO-FILES:END -->
