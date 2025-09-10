# ゲームロジック (game)

Goal: ボール挙動, ゴール判定, スコア更新フローを定義。

## 対象ファイル

- `game/ball.s`
- `game/GoalJudg.s`
- `game/point.s`
- `game/score.s`
- `game/player_board.s`

## ステートマシン (骨子)

- 状態: TITLE -> PLAY -> RESULT -> (RESTART)

## 更新シーケンス

1. 入力結果でプレイヤーボード位置更新
2. ボール位置更新 (速度/反射)
3. ゴール判定 / スコア加算
4. ゲーム終了条件チェック

## TODO

- パラメータ表 (初速度, 反射係数, 得点)
- 擬似コード
