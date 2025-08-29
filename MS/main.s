	@ テスト用メインプログラム
	.include "common.h"
	.section .init
	.global	_start
_start:
	bl	GPIO_init
	bl	PWM_init

	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r0, =MS_play_bgm_target_time
	str	r1, [r0]
	
loop:	
	bl	MS_play_SE
	bl	MS_play_bgm
	
	b	loop

	.section .data
	.global KT_collision
KT_collision:
	.word	-1
