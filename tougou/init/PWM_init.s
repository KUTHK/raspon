/*--------------------------------------
PWM_init.s: PWM制御・初期化・クロック設定

input: なし（初期化処理）
output: PWM関連レジスタ設定

PWM_init: PWM関連レジスタの初期化
--------------------------------------*/
	.equ    CM_BASE,      0x3f101000 @ CMベースアドレス
	.equ    CM_PWMCTL,    0xa0       @ CMコントロールのオフセット
	.equ    CM_PWMDIV,    0xa4       @ CMDivisorのオフセット
	.equ    PWM_BASE,     0x3f20c000 @ PWMのベースアドレス

	.section .text
	.global	 PWM_init
PWM_init:
	push	{r14}
	
	bl	clock_src_init

	@ PWM動作モードの設定 M/S転送モード(Channel 2)
	ldr	r0, =PWM_BASE
	ldr	r1, =0x8100
	str	r1, [r0]

	pop	{r15}

clock_src_init:
	@ クロックソースの設定
	ldr	r0, =CM_BASE
	ldr	r1, =0x5a000021
	str	r1, [r0, #CM_PWMCTL]

1:	@ busy bit(7ビット目, 0x80)がクリアされるまで待つ
	ldr	r1, [r0, #CM_PWMCTL]
	tst	r1, #0x80
	bne	1b

	ldr	r1, =(0x5a000000 | (2 << 12))	@ div = 2.0
	str	r1, [r0, #CM_PWMDIV]
	ldr	r1, =0x5a000211
	str	r1, [r0, #CM_PWMCTL]

	bx	r14
