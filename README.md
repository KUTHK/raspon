# Raspon

Raspberry Pi 上で動作するアセンブリ主体のホッケーゲーム。
GPIO / PWM を直接制御し 8x8 ドットマトリクス LED 表示と BGM / SE 再生、得点・シーン管理を行う。

## 遊び方

> 🚨 重要: **先に電源を落としてから SD カードを抜いてください。**

1. SD カードを挿入する（`kernel7.img` を含む）
1. 電源を入れる（自動で `kernel7.img` をブート）
1. START 画面で任意のスイッチを押す → ゲーム開始
1. 左右スイッチで自分のパドルを水平方向に移動
1. ボールを弾いて相手ゴールへ入れると得点
1. 規定得点 (3点) 獲得で RESULT 画面
1. スイッチ押下で再スタート
1. **電源を切る(先)**
1. SDカードを抜く

| スイッチ | 操作割り当て |
|----------|--------------|
| SW青 | Player1 左 |
| SW緑 | Player1 右 |
| SW赤 | Player2 左 |
| SW黄 | Player2 右 |

## ビルド

> ⚠️ 注意: **電源が入った状態で SD カードを抜き差ししないこと。**

Makefile を使って `kernel7.img` を生成します。以下は一般的な使い方です。

前提:

- GNU Arm Embedded Toolchain がインストール済み（`arm-none-eabi-*` が使えること）

インストール例 (macOS):

```sh
brew install arm-none-eabi-gcc
```

基本コマンド:

```sh
# Makefile があるディレクトリで実行
make            # ビルド（kernel7.img を生成）
make clean      # 生成物削除
```

ビルド完了後（SD へ書き込み）:

- Finder での手順:
  - SD を挿入し、表示される BOOT (FAT32) パーティションを開く
  - `kernel7.img` を 直下に上書きコピー
  - 必ず「取り出す」操作でアンマウント → 本体に挿入 → 電源を入れる

- macOS ターミナル例:

```sh
# SD のデバイス/パーティションを確認
diskutil list

# 例: /dev/disk3s1 が BOOT の場合
diskutil mount /dev/disk3s1
cp -v kernel7.img /Volumes/boot/kernel7.img   # ラベルが異なる場合は適宜変更
```

注意:

- 既存の `kernel7.img` は必要に応じてバックアップしてから上書き
- **SD は必ず安全に取り外してから抜く**（アンマウント or 取り出す）
- **本体では「SD を先に挿す → 電源を入れる」を徹底**

## 目的

本プロジェクトの目的

- メモリマップI/Oを通じて GPIO・タイマ・PWM を直接制御する力を身につける
- 8x8 マトリクスLEDを行スキャンで駆動し、フレームバッファ/シーン遷移を設計する
- PWM による BGM/SE 生成とタイミング制御（SE優先など）を実装して理解する
- 割込みに頼らないポーリング中心の時間設計を体験し、必要に応じて拡張できる基礎を作る
- アセンブリでのサブルーチン化・レジスタ保存・呼出規約・モジュール分割を実践する

## アーキテクチャ概要

- 機器: Raspberry Pi 3
- OS: `_start` (section .init) / `kernel7.img` としてブート
- 表示: 単色LED・8x8 ドットマトリクス
- 音源: スピーカー
- 入力: 4 スイッチ

## ピン割り当て

| 種別 | シンボル | GPIO |
|------|----------|------|
| 単色 LED | LED_PORT | 10 |
| スピーカ | (PWM) | 19 |
| COL1..8 | COL1_PORT..COL8_PORT | 27,8,25,23,24,22,17,4 |
| ROW1..8 | ROW1_PORT..ROW8_PORT | 14,15,21,18,12,20,7,16 |
| SW1..4 | SW1_PORT..SW4_PORT | 13,26,5,6 |

## ディレクトリ構成

```text
Raspon/
├── README.md
├── docs/
│   ├── introduce.md
│   └── program_detail.txt
├── scripts/
│   └── Makefile
└── src/
    ├── main.s
    ├── GoalJudg.s
    ├── init/
    ├── include/
    ├── audio/
    │   ├── play/
    │   └── data/
    ├── display/
    ├── game/
    │   ├── ball/
    │   ├── player/
    │   ├── logic/
    │   └── scenes/
    └── main/
```

## 状態遷移 (main.s)

| ビット | 状態 | 関数 | 説明 |
|--------|------|------|------|
| 0x1 | START | start_game | 開始待ち |
| 0x2 | PLAY  | play_game  | メイン進行 |
| 0x4 | STOP  | stop_game  | 得点後クールタイム |
| 0x8 | END   | end_game   | 結果表示 |

## TODO / 課題

- 難易度スケーリング（ボール速度・パドルサイズ・得点倍率の調整）
- サウンド表現の拡張（和音再生）
- 割り込み処理による高度化
- ボール軌跡の残像表示

## マニュアル

- ミクロン・シミュレータ
  - [ミクロン・シミュレータ](https://kut-tktlab.github.io/tiny-cpu-simulator/)（[予備](http://eris.info.kochi-tech.ac.jp/micron/)）
  - [操作マニュアル](https://www.info.kochi-tech.ac.jp/y-takata/micron-manual/micron-manual.pdf)（[予備](http://eris.info.kochi-tech.ac.jp/micron-manual/micron-manual.pdf)）
  - [2進・10進・16進変換器](https://ytakata69.github.io/bin-dec-hex/)
- i386
  - [Intel 64 and IA-32 Architectures Software Developer's Manual](http://www.intel.co.jp/content/www/jp/ja/processors/architectures-software-developer-manuals.html)
  - [The Netwide Assembler - NASM Manual](http://www.nasm.us/doc/)
- Git, Make
  - [Pro Git book](https://git-scm.com/book/ja)
  - [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html)（マニュアル） / [GNU Make 第3版](http://www.oreilly.co.jp/library/4873112699/)（書籍のPDF版）
- ARM, BCM2835
  - [RealView(R) Compilation Tools アセンブラガイド](https://developer.arm.com/documentation/dui0204/j)（GNU as とは別だが ARM 命令の詳細）
  - [Using as (GNU Assembler)](https://sourceware.org/binutils/docs-2.18/as/)（GNU as の疑似命令など）
  - [BCM2835 ARM Peripherals](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2835/BCM2835-ARM-Peripherals.pdf) / [Errata](http://elinux.org/BCM2835_datasheet_errata#p141)
  - （BCM283x = Raspberry Pi の SoC）
