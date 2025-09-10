# Raspon

Raspberry Pi (ARMv7 / bare‑metal) 上で動作するアセンブリ主体のホッケーゲーム。

GPIO / PWM 直接制御で LED マトリクス表示と BGM / SE 再生、シーン遷移・スコア管理を行う。

参考: 実験用 I/O ボード仕様 (<https://www.info.kochi-tech.ac.jp/y-takata/pl2/appendix/ioboard.html>)。

## 目的

低レイヤ (割込み無しポーリング中心) での I/O・タイミング制御学習 / コード最適化 / ハード資源理解。

## アーキテクチャ概要

* ターゲット: Raspberry Pi 2/3 系 (Peripheral base 0x3F00_0000 系列を使用)
* エントリ: `_start` (section .init) / `kernel7.img` としてブート
* 表示: 8x8 ドットマトリクス LED 行スキャン (ROW Low + COL High 点灯)
* 音源: GPIO19 (PWM) による矩形波出力 (BGM / SE 排他)
* 入力: 4 スイッチ (プルダウン) ポーリング

## ピン割り当て (common.h / 外部資料)

| 種別 | シンボル | GPIO |
|------|----------|------|
| 単色 LED | LED_PORT | 10 |
| スピーカ (PWM ALT5) | (PWM) | 19 |
| COL1..8 | COL1_PORT..COL8_PORT | 27,8,25,23,24,22,17,4 |
| ROW1..8 | ROW1_PORT..ROW8_PORT | 14,15,21,18,12,20,7,16 |
| SW1..4 | SW1_PORT..SW4_PORT | 13,26,5,6 |


## ディレクトリ構成

```text
src/
   init/        GPIO / PWM 初期化
   audio/
      play/      再生ルーチン (BGM / SE)
      data/      音データ (BGM, SE, sound_source.h)
   display/     表示/文字/数値/回転
   game/
      ball/      ボール挙動
      player/    パドル操作/描画
      logic/     得点/判定
      scenes/    START / RESULT
   include/     共通定義 (common.h)
main.s         メインループ
build/         生成物
docs/          ドキュメント
scripts/       補助スクリプト
linker.ld      リンカスクリプト
Makefile       ビルド定義
```

## 主ファイル一覧

| ファイル | 概要 |
|----------|------|
| init/GPIO_init.s | GPIO / Function Select 設定 & Stack 初期化 |
| init/PWM_init.s | PWM クロックソース / M/S モード設定 |
| audio/play/MS_play_bgm.s | BGM 更新 & ループ制御 |
| audio/play/MS_play_SE.s | 効果音再生 (BGM 抑制) |
| audio/data/MS_bgm_*.s | 楽曲データ列 |
| audio/data/MS_SE.s | 効果音データ列 |
| audio/data/sound_source.h | 周波数テーブル |
| display/display.s | フレームバッファ走査出力 |
| display/text.s | 文字列バッファ書き込み |
| display/write_number.s | 数値描画 |
| display/rotate.s | 画面回転エフェクト |
| game/ball/ball.s | ボール物理更新 |
| game/player/player_board*.s | パドル入力 & 描画 |
| game/logic/point.s | 得点保持/加算/リセット |
| game/logic/score.s | スコア表示処理 |
| GoalJudg.s | ゴール判定 |
| game/scenes/start.s | START シーン描画/遷移 |
| game/scenes/result.s | RESULT シーン描画 |
| main/switch.s | スイッチ状態取得 |
| main.s | 状態遷移 (start→play→stop→end) |
| include/common.h | GPIO / PWM / Timer / Pin マクロ |

## ビルド

前提: `arm-none-eabi-*` ツールチェーン (Homebrew 例: `brew install arm-none-eabi-gcc`)

```sh
make          # kernel7.img 生成
make dump     # 逆アセンブリ (firmware.dump)
make symbols  # シンボル/ドキュメント生成 (将来拡張)
make clean    # 生成物削除
```

生成物:

* firmware.elf : ELF (デバッグ)
* kernel7.img : ブートローダ読込用

### 典型的 SD カード配置

```text
bootfs/
   bootcode.bin
   start.elf
   config.txt
   kernel7.img   <- 生成物
```

## 表示走査 (疑似処理)

```text
for row in 1..8:
   set all ROW pins High
   output COL pins = frame[row]
   drive ROW[row] Low
   short delay
```

残像を利用して全面表示。`rotate.s` は別バッファ回転後に転送。

## サウンド設計

* PWM Ch2 M/S モード (DIV=2)
* BGM: テンポ基準シーケンス
* SE: 一時的に BGM を抑制

## 状態遷移 (main.s)

| Bit | 状態 | ハンドラ |
|-----|------|----------|
| 0x1 | START | start_game |
| 0x2 | PLAY  | play_game |
| 0x4 | STOP  | stop_game |
| 0x8 | END   | end_game |

クール: `score_cool_time` が遅延管理。

## デバッグ TIPS

| 目的 | 方法 |
|------|------|
| GPIO 状態確認 | LED_PORT トグル追加 |
| ボール速度調整 | ball.s の速度定数変更 |
| BGM 切替 | MS_bgm_offset 初期値変更 |
| スキャン速度 | display.s の wait 調整 |

## 今後の改善案

* スタック領域再配置 / `.bss` 初期化
* 割込み駆動 (Timer / SysTick)
* 簡易タスクスケジューラ
* SE ミックス / キューイング
* QEMU (raspi2) サポート

## ライセンス

未定 (選定予定)。

## 貢献者

松本 / 久保田 / 寺内 / 林 / 奥平 / 森岡 (敬称略)

## 参考資料

* I/O ボード仕様: <https://www.info.kochi-tech.ac.jp/y-takata/pl2/appendix/ioboard.html>
* Bare-metal Raspberry Pi 関連資料

---
改善提案や仕様確定 (スタック / メモリマップ) があれば随時更新。
