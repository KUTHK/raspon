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

	bl	MS_set_bgm_target
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
	bl		TS_switch
	ldr		r0,=TS_switch_out
	ldr		r1,[r0]
	tst		r1, #15
	ldrne		r0, =main_status
	movne		r1, #2
	strne		r1, [r0]
	blne		MS_play_bgm_init
	ldrne		r0, =MS_bgm_offset
	movne		r1, #8
	strne		r1, [r0]
	tst		r1, #15
	blne		MS_set_bgm_target
	tst		r1, #15
	blne		HK_fb_clear
	tst		r1, #15
	blne		score_cool_time
	@and		r2,r1,#3
	bl		HK_start
	bl		MS_play_bgm
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
	blne	score_cool_time

	pop		{r0-r12,r15}

stop_game:
	push	{r0-r12,r14}
	bl	TS_switch
	bl	MS_play_SE
	bl	MS_play_bgm
	ldr	r0,=OS_goalJudg_out
	ldr	r1,[r0]
	tst	r1,#1
	blne	HK_add_point1
	tst	r1,#1
	blne	KT_ball_init_player2
	tst	r1,#2
	blne	HK_add_point2
	tst	r1,#2
	blne	KT_ball_init_player1
	bl 	MY_show_score

	ldr		r0,=main_status
	ldr		r1,=TS_switch_out
	ldr		r2,[r1]
	tst		r2, #15
	movne		r1, #2
	strne		r1, [r0]
	blne		game_restart
	tst		r2, #15
	blne	check_end

	ldr		r1,=TS_switch_out
	ldr		r2,[r1]

	ldr		r0,=OS_goalJudg_out
	mov		r1,#0
	str		r1,[r0]

	pop		{r0-r12,r15}

end_game:
	push	{r0-r12,r14}
	bl		MS_play_bgm
	bl		TS_switch
	ldr		r0,=TS_switch_out
	ldr		r1,[r0]
	bl		MY_show_result
	tst		r1, #15
	blne	_start
	pop		{r0-r12,r15}

all_init:
	push	{r0-r12,r14}
	bl  	PWM_init
	bl		TS_switch_init
	bl		TS_player_board_init
	bl		KT_ball_init_player1
	bl		KT_ball_init
	bl		HK_start_init
	bl		HK_reset_point
	bl		MS_play_bgm_init
	ldr		r0, =MS_bgm_offset
	mov		r2, #0
	str		r2, [r0]
	bl		MS_set_bgm_target
	ldr		r0,=main_status
	ldr		r1,=1
	str		r1,[r0]
	bl		score_cool_time
	pop		{r0-r12,r15}

game_restart:
	push	{r0-r12,r14}
	bl		HK_fb_clear
	bl		KT_ball_init
	bl		TS_switch_init
	bl		TS_player_board_init
	bl		MY_buffer_ischanged_init

	pop		{r0-r12,r15}

score_cool_time:
	push	{r0-r12,r14}
	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2,=TS_cool_time
	ldr	r3,=500*1000
	add	r1,r1,r3
	str	r1,[r2]
	pop		{r0-r12,r15}

check_end:
	push	{r0-r12,r14}
	
	bl		score_cool_time
	ldr		r0,=HK_winner
	ldr		r1,[r0]
	ldr		r2,=main_status
	tst			r1,#3
	movne		r3, #8
	strne		r3, [r2]
	blne		MS_play_bgm_init
	tst			r1,#3
	ldrne		r0, =MS_bgm_offset
	movne		r2, #4
	strne		r2, [r0]
	blne		MS_set_bgm_target
	tst			r1,#3
	blne		HK_fb_clear
	tst			r1,#3
	blne		MY_show_result_init

	pop		{r0-r12,r15}

	.section .data
	.global	main_status
main_status:
	.word	1
