	.section .init
	.global _start
	.include "common.h"

_start:
	mov	sp, #STACK
	@ LEDとディスプレイ用のIOポートを出力に設定する
	ldr	r0, =GPIO_BASE
	ldr	r1, =GPFSEL_VEC0
	str	r1, [r0, #GPFSEL0 + 0] @命令をレジスタGPSELOに書き込んだ
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL0 + 4]
	ldr	r1, =GPFSEL_VEC2
	str	r1, [r0, #GPFSEL0 + 8]

	bl HK_start_init

	loop:
		bl	HK_start
		bl	HK_display
	b	loop



