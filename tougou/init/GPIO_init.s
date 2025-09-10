/*--------------------------------------
GPIO_init.s: GPIO初期化・LED/ディスプレイ/スピーカーIO設定

input: なし（初期化処理）
output: 各種IOポート設定

GPIO_init: 各種IOポートの初期化
--------------------------------------*/
	.include "common.h"
	.section .text
	.global GPIO_init
GPIO_init:
	@ LED、ディスプレイとスピーカー用のIOポートを出力に設定する
	mov	sp, #STACK	@ スタックポインタの指定
	ldr     r0, =GPIO_BASE
	ldr     r1, =GPFSEL_VEC0
	str     r1, [r0, #GPFSEL0 + 0]
	ldr     r1, =GPFSEL_VEC1
	str     r1, [r0, #GPFSEL0 + 4]
	ldr     r1, =GPFSEL_VEC2
	str     r1, [r0, #GPFSEL0 + 8]

	bx	r14
