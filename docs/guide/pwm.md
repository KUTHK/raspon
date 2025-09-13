# PWM の基礎

冒頭: 明るさや音量・音階などアナログ風制御を実現するデジタル手法を理解する。

## 簡単（初心者向け）

- 周期(RNG)とデューティ(DAT)を設定してCTLを有効化すると波形が出る。

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

## 普通（上級者向け）

### クロック源と分周

- PWM のクロックは CM（Clock Manager）で供給。`CM_PWMCTL`/`CM_PWMDIV` を用い、`PWMDIV`で分周（整数部/小数部）。
- 本プロジェクトでは `PWM_HZ = 9.6MHz` を前提（`CTL_VEC0` の MSEN2 を使う Mark-Space モード）。

### レジスタとモード

- `PWM_CTL`: `PWEN2`（チャネル2有効）/`MSEN2`（マークスペース）など。
- `PWM_RNG2` に周期、`PWM_DAT2` にデューティ。RNG更新時は境界でDATの見かけが変わることに注意。

### 周波数と音階

- 周波数 f ≒ PWM_clk / RNG。音階は f を 2^(n/12) でスケール。音量はデューティ比で表現。

まとめ: CMでPWMクロックを決め、CTLのモード＋RNG/DATで波形を形成。周波数とデューティを分離して設計する。
