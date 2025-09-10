# Raspon (Raspberry Pi ベアメタル エアホッケー)

8x8 LED マトリクスとスピーカを用いた 2P 対戦ホッケーゲーム。ベアメタル ARM (Raspberry Pi) 上で動作し、表示 / 入力 / サウンド / ゲームロジックを明確に分離した構成。

## 主な特徴

- 3 点先取の対戦ルール (可変勝利点拡張余地)
- LED マトリクスでスコア / ボール / パドル表示
- PWM 駆動による BGM / 効果音再生
- モジュール化 (init / display / game / input / sound)
- 自動ラベル抽出・メモリマップ生成支援スクリプト

## リポジトリ構成 (抜粋)

```text
build/            # Makefile, linker.ld, 生成物
docs/             # 詳細ドキュメント (README 参照)
init/             # 初期化コード (_start, GPIO/PWM)
display/          # 描画関連
game/             # ボール, スコア, 判定
input/            # スイッチ読み取り
sound/            # BGM / SE 再生
include/          # 共通ヘッダ (common.h 等)
scripts/          # 補助スクリプト (gen_symbols.py 等)
```

詳細な設計や拡張方針は `docs/README.md` および各サブページ参照。

## クイックビルド

```bash
cd build
make        # firmware.elf / kernel7.img 生成
make dump   # セクション/逆アセンブル出力
make size   # サイズ表示
make symbols # シンボル表自動更新
```

出力: `kernel7.img` をブート領域へ配置 (ボード手順は後述予定)。

## ゲームルール概要

1. タイトル状態 → ボタン入力で開始
2. ボール移動 / パドル操作でゴールを狙う
3. 先に 3 点到達で勝者決定 → RESULT 画面
4. リセットで再スタート (得点クリア)

## 貢献

改善提案・バグ報告は Issue。詳細手順は `docs/CONTRIBUTING.md`。

## ライセンス

未定 (決定後 SPDX 識別子記載)。
