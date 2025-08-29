	.include "common.h"
	.section .init
	.global _start
_start:
	bl	GPIO_init
	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2, =TS_player_board_target_time
	str	r1, [r2]

	bl	KT_ball_init
loop:
	bl	TS_switch
	bl	TS_player_board
	
	bl	KT_ball_move
	bl	HK_display
	
	b	loop


