	.section .text
	.global GPIO_init
	.include "common.h"
GPIO_init:
	mov	sp, #STACK		@スタックポインタ設定
	@(GPIO #19 を含め，GPIOの用途を設定する)
	ldr	r0, =GPIO_BASE
	ldr	r1, =GPFSEL_VEC0
	str	r1, [r0, #GPFSEL0] @命令をレジスタGPSELOに書き込んだ
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL1] @命令をレジスタGPSELOに書き込んだ
	ldr	r1, =GPFSEL_VEC2
	str	r1, [r0, #GPFSEL2] @命令をレジスタGPSELOに書き込んだ

	bx	lr
