	.section .text
	.global PWM_init
	.include "common.h"
PWM_init:
	@(PWM のクロックソースを設定する)
	ldr     r0, =CM_BASE
	ldr     r1, =0x5a000021                     @  src = osc, enable=false
	str     r1, [r0, #CM_PWMCTL]

1:    @ wait for busy bit to be cleared
	ldr     r1, [r0, #CM_PWMCTL]
	tst     r1, #0x80
	bne     1b

	ldr     r1, =(0x5a000000 | (2 << 12))  @ div = 2.0
	str     r1, [r0, #CM_PWMDIV]
	ldr     r1, =0x5a000211                   @ src = osc, enable=true
	str     r1, [r0, #CM_PWMCTL]


	@(PWM の動作モードを設定する)
	ldr     r0, =PWM_BASE
	ldr     r1, =CTL_VEC0
	str	r1, [r0, #PWM_CTL] @命令をレジスタGPSELOに書き込んだ
	bx	r14			@呼び出し元に戻る
