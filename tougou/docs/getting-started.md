# 環境構築と起動 (Getting Started)

Goal: リポジトリを取得し、ビルドし、実機またはエミュレータで起動する。

## 前提

- 対象アーキテクチャ: Raspberry Pi (BCM2836 / ARMv7) ベアメタル
- 必要ツール: `make`, クロスアセンブラ (例: `arm-none-eabi-as`), `objcopy`, 書き込みツール

## セットアップ手順 (骨子)

1. リポジトリ取得
2. ツールチェーン導入
3. `build/Makefile` にパスを設定
4. `make` 実行
5. 生成物を (SDカード / フラッシュ / エミュレータ) へ配置
6. 起動と初期画面確認

## クイックコマンド (例/ダミー: 要調整)

```bash
git clone <repo-url>
cd tougou
make -C build
```

## 成功確認

- ディスプレイ初期化後にタイトル/スコア領域表示
- サウンド初期 BGM 再生 (任意)

## 次へ

→ アーキテクチャ全体: `architecture/overview.md`

## 追加検討事項

- 実機ボード型番写真
- 推奨 arm-none-eabi-* バージョン明記
- 起動後スクリーンショット
