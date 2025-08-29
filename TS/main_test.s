	.include "common.h"
	.section .init
	.global _start
_start:
	bl	GPIO_init
	bl  all_init
	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2, =TS_player_board_target_time
	str	r1, [r2]

	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2,=MS_play_bgm_target_time
	str	r1,[r2]
loop:
	bl		check
	bl		HK_display
	
	b	loop

check:
	push	{r14}
	ldr		r0,=main_status
	ldr		r1,[r0]
	
	tst		r1,#1
	blne	start_game
	tst		r1,#2
	blne	play_game
	tst		r1,#4
	blne	stop_game
	tst		r1,#8
	blne	end_game
	pop		{r15}

start_game:
	push	{r0-r12,r14}
	@bl		TS_switch
	@ldr		r0,=TS_switch_out
	@ldr		r1,[r0]
	@and		r2,r1,#3
	bl		HK_start

	pop		{r0-r12,r15}

play_game:
	push	{r0-r12,r14}
	bl	TS_switch
	bl	TS_player_board
	
	bl	KT_ball_move
	bl	OS_goalJudg
	bl	MS_play_SE
	bl	MS_play_bgm

	ldr	r0,=main_status
	ldr	r2,=OS_goalJudg_out
	ldr	r3,[r2]
	ldr		r4,=4
	tst		r3,#3
	strne	r4,[r0]
	pop		{r0-r12,r15}

stop_game:
	push	{r0-r12,r14}
	bl	MS_play_bgm
	bl 	MY_show_score
	pop		{r0-r12,r15}

end_game:
	push	{r0-r12,r14}
	bl	TS_switch
	pop		{r0-r12,r15}

all_init:
	push	{r0-r12,r14}
	bl  	PWM_init
	bl		TS_switch_init
	bl		TS_player_board_init
	bl		KT_ball_init
	bl		HK_start_init
	pop		{r0-r12,r15}

.section .data
	.global	main_status
main_status:
	.word	1