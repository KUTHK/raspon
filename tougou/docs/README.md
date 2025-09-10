# Raspon プロジェクト ドキュメント

このフォルダはプロジェクトの技術 / 利用 / 開発ドキュメントの統合ハブです。最初に読むべきページは `getting-started.md` と `architecture/overview.md`。

## セクション構成

- getting-started.md: 開発環境・ビルド・実行
- build.md: Makefile / ビルド詳細
- architecture/: 全体構造・メモリマップ・主要フロー
- modules/: 各アセンブリ/機能モジュールの責務
- gameplay/: ゲーム仕様と得点/判定
- assets/: サウンド等リソース一覧
- development/: コーディング規約・テスト・ワークフロー
- reference/: ラベル/シンボル・命令使用パターン索引
- troubleshooting.md: 典型トラブルと対処
- roadmap.md: 今後の改善予定
- CONTRIBUTING.md: コントリビュート手順
- CHANGELOG.md: 変更履歴

## 執筆ポリシー（参考サイト流用思想）

参考サイト（情報学群実験テキスト）の GitBook 風: 「短い導入 → 目的 → 手順/背景 → 次へ誘導」。各ページ冒頭に Goal を明示し、末尾に関連リンク（次へ）を配置する。

---

今後詳細化する際は、各ページ内の TODO セクションを埋めてください。

## プロジェクト概要

Raspberry Pi（ベアメタル想定）上で 8x8 マトリクス LED とスピーカを用いた 2P 対戦ホッケーゲーム。BGM/SE 再生、スコア表示、ゴール判定、結果画面表示を備える。

### 主な成果

#### 1. ベアメタルでの音声出力

- PWM 制御によるスピーカー出力
- BGM / 効果音の再生制御
- 単音再生ループの基盤整備

#### 2. LED マトリクス制御

- 8x8 点灯制御と座標系確立
- 文字 / 数字描画ルーチン
- アニメーション（回転 / スクロール）表現

#### 3. ゲーム機能

- 2人対戦 (3点先取)
- スコア管理・結果画面
- 状態遷移: TITLE → PLAY → RESULT → RESTART

#### 4. チーム開発の特徴

- モジュール化（init/display/game/sound/input）
- レジスタ利用規約策定
- 段階的統合と表示/サウンド/入力の分離

## ディレクトリ構造

```text
tougou/
├── init/        # 初期化・低レベル設定
├── display/     # 表示関連機能
├── game/        # ゲームロジック
├── input/       # 入力処理
├── sound/       # サウンド関連 (bgm/, se/)
├── include/     # 共通ヘッダ
├── build/       # ビルド関連
└── docs/        # ドキュメント
```

## 開発体制メモ

### レジスタ利用（方針）

- r0-r3: 引数 / 戻り値 / 一時
- r4-r8: 永続状態（必要時保存）
- r9-r12: サブルーチン内作業
- sp(like r13): スタックポインタ
- lr(r14): 復帰アドレス
- pc(r15): プログラムカウンタ

### モジュール連携原則

- 共通定数は `common.h`
- サブルーチンは呼出前後のレジスタ破壊範囲をコメント
- 表示更新とゲーム状態更新は 1 ループ内の順序固定

### 統合ステップ

1. 個別機能の単体確認
2. インターフェース整合レビュー
3. 段階統合（入力→ゲーム→表示→サウンド）
4. フレーム動作/遅延計測

## ビルド方法（概要）

```bash
cd build
make        # ビルド
make clean  # クリーン
```

詳細は `build.md` と `getting-started.md` を参照。

## 次に読む

- 初めて: `getting-started.md`
- 全体像: `architecture/overview.md`
- ゲーム仕様: `gameplay/overview.md`

## ライセンス / 著作権

SPDX-License-Identifier: MIT

## 更新履歴

主要変更は `CHANGELOG.md` を参照。
