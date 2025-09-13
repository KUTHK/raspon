# GPIO の基本

冒頭: 入力と出力を自由に設定できるピンを直接制御して、LED点灯やスイッチ入力を扱えるようにする。

## 簡単（初心者向け）

- LED: 出力に設定 → ビットを立てると点灯、消すと消灯。
- スイッチ: 入力に設定 → 入力レジスタの該当ビットを読む。

```asm
  .include "src/include/common.h"
  ldr r0, =GPIO_BASE
  mov r1, #1
  lsl r1, r1, #LED_PORT
  str r1, [r0, #GPSET0]   @ 点灯
```

## 普通（上級者向け）

- GPFSELx で機能選択（3bit/ピン）。出力は GPSET0/GPCLR0、入力は GPLEV0 を読む。
- 複数ピンはビットORで同時制御。入出力の遅延はメモリ書き込み/読み込みタイミングに依存。

```asm
  .include "src/include/common.h"
  ldr r0, =GPIO_BASE
  mov r1, #((1 << LED_PORT) | (1 << COL1_PORT))
  str r1, [r0, #GPSET0]   @ 複数ピン同時にHigh
  ldr r2, [r0, #GPLEV0]   @ 入力サンプリング
  tst r2, #(1 << SW1_PORT)
  bne handle_pressed
```

まとめ: GPFSELで機能設定→出力はGPSET/GPCLR、入力はGPLEV。必要なら複数ビットで一括制御。
