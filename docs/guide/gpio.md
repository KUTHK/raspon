# GPIO の基本

入力と出力を自由に設定できるピンです。

## 出力(LED点灯)

- GPFSELでピン機能を「出力」に設定し、GPSET/GPCLRでHigh/Lowを切り替えます。

```asm
  .include "src/include/common.h"
  ldr r0, =GPIO_BASE
  mov r1, #1
  lsl r1, r1, #LED_PORT     @ LEDピンのビットマスク
  str r1, [r0, #GPSET0]     @ 点灯
```

## 入力(スイッチ)

- GPFSELで「入力」に。レベルはGPLEV0を読みます。

```asm
  .include "src/include/common.h"
  ldr r0, =GPIO_BASE
  ldr r1, [r0, #GPLEV0]
  mov r2, #1
  lsl r2, r2, #SW1_PORT
  and r3, r1, r2            @ r3!=0 で押下
```

まとめ: 機能設定(GPFSEL)→出力はGPSET/GPCLR、入力はGPLEVを読む、が基本形。
