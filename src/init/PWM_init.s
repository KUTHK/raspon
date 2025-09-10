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
	@ クロックソース -> 発振器(oscillator), divisor -> 2.0

	ldr	r0, =CM_BASE
	ldr	r1, =0x5a000021
	@ password -> 0x5a,
	@ 0x21 = 0b10 0001, クロックのリセット，クロックの無効化，ソース選択(0001 -> osc)

	str	r1, [r0, #CM_PWMCTL]

1:	@ busy bit(7ビット目, 0x80)がクリアされるまで待つ(クロックは即座に停止しない)
	ldr	r1, [r0, #CM_PWMCTL]
	tst	r1, #0x80
	bne	1b

	ldr	r1, =(0x5a000000 | (2 << 12))	@ div = 2.0
	str	r1, [r0, #CM_PWMDIV]
	ldr	r1, =0x5a000211
	@ password -> 0x5a
	@ 0x211 = 0b01 000 0 1 0001, MASH制御, FLIP/BUSY/Unused, クロックはリセットしない， クロックの有効化, ソースはosc

	str	r1, [r0, #CM_PWMCTL]

	bx	r14
