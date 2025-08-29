.equ    STACK, 0x8000
  .equ    GPIO_BASE,  0x3f200000 @ GPIOベースアドレス

  .equ GPFSEL0, 0x00		@ GPIO #0〜9 の機能を選択する番地のオフセット
  .equ GPFSEL1, 0x04		@ GPIO #10〜19 の機能を選択する番地のオフセット
  .equ GPFSEL2, 0x08		@ GPIO #20〜29 の機能を選択する番地のオフセット
  .equ GPSET0, 0x1C		@ GPIO ポートの出力値を1にするための番地のオフセット
  .equ GPCLR0, 0x28		@ GPIO ボートの出力値を0にするための番地のオフセット
  .equ GPLEV0, 0x34               @ GPIO#0~33の機能を選択する番地のオフセット
  @タイマーカウンタ
  .equ    TIMER_BASE,  0x3f003000 @ TIMERベースアドレス
  .equ    CLO,    0x4             @ SystemTimerCounter LOWER 32bit
  .equ    CHI,    0x8             @ SystemTimerCounter HIGHER 32bit

  @ ポートの入出力設定
  .equ    GPFSEL_VEC0, 0x01201000 @ GPFSEL0 に設定する値 (GPIO #4, #7, #8 を出力用に設定)
  .equ    GPFSEL_VEC1, 0x11249041 @ GPFSEL1 に設定する値 (GPIO #10, #12, #14, #15, #16, #17, #18 を出力用に設定, #19をALT5(PWM)に設定)
  .equ    GPFSEL_VEC2, 0x00209249 @ GPFSEL2 に設定する値 (GPIO #20, #21, #22, #23, #24, #25, #27 を出力用に設定)

  @LED
  .equ LED_PORT, 10

  @マトリックスLED
  @列
  .equ COL1_PORT, 27
  .equ COL2_PORT, 8
  .equ COL3_PORT, 25
  .equ COL4_PORT, 23
  .equ COL5_PORT, 24
  .equ COL6_PORT, 22
  .equ COL7_PORT, 17
  .equ COL8_PORT, 4
  @ 行
  .equ ROW1_PORT, 14
  .equ ROW2_PORT, 15
  .equ ROW3_PORT, 21
  .equ ROW4_PORT, 18
  .equ ROW5_PORT, 12
  .equ ROW6_PORT, 20
  .equ ROW7_PORT, 7
  .equ ROW8_PORT, 16

  .equ SW1_PORT, 13
  .equ SW2_PORT, 26
  .equ SW3_PORT, 5
  .equ SW4_PORT, 6

  @PWM
  .equ CM_BASE, 0x3f101000       @CM_BASE は0x3f101000
  .equ CM_PWMCTL, 0xa0           @CM_PWMCTL は0xa0
  .equ CM_PWMDIV, 0xa4            @CM_PWMDIV は0xa4

  .equ    PWM_HZ, 9600 * 1000	@クロック周期9.6Mhz
  .equ PWM_BASE, 0x3f20c000
  .equ PWM_CTL, 0x00
  .equ PWM_RNG2, 0x20
  .equ PWM_DAT2, 0x24
  .equ CTL_VEC0, 0x00008100       @CTLレジスタのPWEN2とMSEN2をON

  @スピーカー
  .equ EOM, 0                    @End of music, 鳴らす長さ配列の最後を表す
  .equ	ONE_SEC, 1 * 1000 * 1000
  .equ	ONE_MSEC, 1 * 1000
  .equ	TONE1, PWM_HZ / 440	@ぽ
  .equ	TONE2, PWM_HZ / 880	@ぽーーー

