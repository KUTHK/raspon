# PWM の基礎

明るさや音量・音階などをアナログ風にデジタルで制御する手法です。

## 考え方

- 一定周期でON/OFFを繰り返し、ONの割合(デューティ比)で平均出力を制御します。

## 例: PWM2で出力

```asm
  .include "src/include/common.h"
  ldr r0, =PWM_BASE
  ldr r1, =CTL_VEC0     @ PWEN2|MSEN2
  str r1, [r0, #PWM_CTL]
  mov r2, #1024         @ RNG2=1024
  str r2, [r0, #PWM_RNG2]
  mov r3, #256          @ DAT2=256 (25%)
  str r3, [r0, #PWM_DAT2]
```

まとめ: 周期(RNG)とデューティ(DAT)を設定→CTLで有効化、で出力が作れる。
