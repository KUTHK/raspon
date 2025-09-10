# ビルド詳細

Goal: `build/Makefile` の役割と生成物フローを理解し、カスタマイズできる。

## 構成

- 入力ソース: `init/`, `display/`, `game/`, `sound/`, `input/`, `include/`
- 中間: オブジェクト(.o) ※ 生成規則 (後で追記)
- 出力: `kernel7.img` (ELF -> objcopy 生成)

## Make ターゲット案

- `all`: 全ビルド
- `clean`: 一時ファイル削除
- `flash` / `deploy`: 書き込み

## ビルドパラメータ

- 最適化フラグ / デバッグシンボル
- メモリアドレス配置 (リンカスクリプト) → `architecture/memory-map.md` 参照

## 変更手順例

1. 新しいモジュール追加
2. Makefile の SRCS へ追記
3. `make` で再ビルド

## 追加検討事項

- Windows / PowerShell での PATH 設定例
- linker.ld 詳細解説 (セクション配置) 追記
