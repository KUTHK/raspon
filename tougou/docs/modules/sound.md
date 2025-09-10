# サウンド (sound)

Goal: BGM / SE の再生制御と拡張手順を整理。

## 対象ファイル

- `sound/bgm/MS_bgm_list.s`
- `sound/bgm/MS_bgm_*.s`
- `sound/se/MS_SE.s`
- `sound/se/MS_sound_effect.s`
- `sound/se/MS_play_bgm.s`
- `sound/se/MS_play_SE.s`

## 概要

- BGM: ループ再生 / 状態遷移で切替
- SE: イベントトリガ (得点, 衝突 など)

## 拡張手順

1. 音源データ追加
2. リストへ ID 追加
3. 再生トリガをゲーム側へ記述

## TODO

- フォーマット仕様 (周波数, エンコーディング)
- ミキシングの有無
