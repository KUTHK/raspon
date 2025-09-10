# build ディレクトリ

本ディレクトリはビルドシステム関連ファイルを格納。

## 現状

- `Makefile`: 最小骨子。リンカスクリプト未導入。

## 今後追加予定

1. リンカスクリプト (例: `linker.ld`)
2. セクション配置とメモリアドレス (docs/architecture/memory-map.md を同期)
3. objcopy によるバイナリ出力 (`kernel7.img` 等)
4. `make size` でバイナリサイズ集計

## シンボル自動収集

`make symbols` → `scripts/gen_symbols.py` 実行で `reference/symbols.md` に自動ブロック追記。

## 変数上書き例

```bash
make AS=arm-linux-gnueabihf-as TARGET=game.bin
```

## 注意

- skeleton のため現時点では最終イメージを生成しない
- 追加時はターゲットボードに合わせてツールチェーン変数を設定
