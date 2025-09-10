# アーキテクチャ概要

Goal: 全体のモジュール分割と主な制御フローを把握する。

## 高レベル構造

```text
init --> (GPIO/PWM 初期化) --> main ループ
  |                                |
  +-> display (描画) <-------------+
  +-> input (スイッチ状態取得)
  +-> game (状態更新: ball, score, goal 判定)
  +-> sound (BGM/SE 制御)
```

## レイヤ定義

- Hardware Abstraction: GPIO_init, PWM_init
- Device/IO: display 描画, sound 再生
- Game Logic: ball, goal 判定, score 集計
- Interface: switch 入力 → game 状態遷移

## データフロー (骨子)

1. 入力読み取り
2. ゲーム状態更新 (位置/スコア/判定)
3. 描画バッファ更新 → 出力
4. サウンド (イベント駆動)

## 依存関係原則

- 下位(ハード)は上位(ゲーム)を知らない
- 共通定義は `include/common.h` に集約

## 次へ

→ メモリ配置: `memory-map.md` / コールフロー: `call-flow.md`

## TODO

- 実際の割り込み/ポーリング方式
- タイミング(フレームレート) 数値
