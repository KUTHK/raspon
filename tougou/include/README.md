# include

このディレクトリは ヘッダファイル（定数・アドレス・音階定義）をまとめています。

## ファイル一覧

- `common.h` — 共通定義（GPIO/TIMER 等のアドレス、定数）
- `sound_source.h` — 音階定義（PWM 関連）

備考: これらヘッダはアセンブリ内で `.include "common.h"` の形で参照されています。
