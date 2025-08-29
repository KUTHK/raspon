	@ 2人のプレイヤーのボードを動かすサブルーチン
    @ スイッチが押されればボードの中心座標が左右に動く
    @ TS_switch_outからボタン情報を読み込む
    @ TS_player1_board,TS_player2_boardにはそれぞれプレイヤーの中心座標がしまってある
	@ TS_player1_mov, TS_player2_movはボタン2、4方向に動くと-1,ボタン1,3方向に動くと1,それ以外なら0
	@ TS_player1_push_time, TS_player2_push_time最後に座標が動いた時間をそれぞれ保存
	.include "common.h"
	.section .text
	.global TS_player_board
TS_player_board:
	push	{r0-r12, r14}
	@ タスク実行の判定, (目標時刻 <= 現在時刻 で実行)
	ldr	r0, =TS_player_board_target_time
	ldr	r1, [r0]	@ 目標時刻
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]	@ 現在時刻
	cmp	r1, r2
	@ タスクの実行時，次の目標時刻の取得更新(r1に目標時刻を与える)
	blle	task_target_time_update
	@ タスクの実行
	cmp	r1, r2
	blle	task

	pop	{r0-r12, r15}

task:
	push	{r0-r12,r14}
	@どちらに動いたのか判定のための値
	mov		r11,#0
	mov		r12,#0

	@ボタンの値
    ldr     r0,=TS_switch_out
    ldr     r1,[r0]

	@player2が動いたかどうか
    ldr     r2,=TS_player2_board
    ldr     r3,[r2]
    tst     r1,#1
    addne   r3,#1
	addne	r11,#1
    tst     r1,#2
    subne   r3,#1
	subne	r11,#1

    cmp     r3,#1
    addlt   r3,#1
    cmp     r3,#6
    subgt   r3,#1
    

	@player1が動いたかどうか
    ldr     r4,=TS_player1_board
    ldr     r5,[r4]
    tst     r1,#4
    addne   r5,#1
	addne	r12,#1
    tst     r1,#8
    subne   r5,#1
	subne	r12,#1

    cmp     r5,#1
    addlt   r5,#1
    cmp     r5,#6
    subgt   r5,#1

    str     r3,[r2]
    str     r5,[r4]

	bl		save
	bl		TS_player1_board_draw
    bl		TS_player2_board_draw

	pop		{r0-r12,r15}

task_target_time_update:
	push	{r0-r12, r14}

	@ldr	r0, =1000
	ldr	r1, =1
	ldr	r0, =TS_player_board_target_time
	ldr	r2, [r0]
	add	r1, r1, r2
	ldr	r0, =TS_player_board_target_time
	str	r1, [r0]

	pop	{r0-r12, r15}

save:
	push	{r0-r12, r14}

	ldr		r0, =TIMER_BASE
	ldr		r2, [r0, #0x04]	@ 現在時刻

	ldr     r6,=TS_player1_push_time

	ldr     r7,=TS_player2_push_time

	ldr		r10,=TS_player1_mov

	@動いた方向もそれぞれ入れる

	@下位2bitの少なくともどちらかのフラグが立っているか確認
    tst     r1,#3
    strne   r2,[r6]
	strne	r11,[r10]
	blne	KT_ball_player1_pushed

	ldr		r10,=TS_player2_mov

    @下位2bit以外のフラグが立っているか確認
    cmp     r1,#3
    strgt   r2,[r7]
	strgt	r12,[r10]
	blgt	KT_ball_player2_pushed

	pop		{r0-r12, r15}

    .global TS_player_board_init
TS_player_board_init:
push    {r0-r12,r14}
    mov     r0,#1
    ldr     r1,=TS_player1_board
    ldr     r0,[r1]
    ldr     r2,=TS_player2_board
    str     r0,[r2]

	mov     r0,#0
    ldr     r1,=TS_player1_mov
    ldr     r0,[r1]
    ldr     r2,=TS_player2_mov
    str     r0,[r2]
	ldr     r1,=TS_player1_push_time
    ldr     r0,[r1]
    ldr     r2,=TS_player2_push_time
    str     r0,[r2]

	ldr	r1, =TIMER_BASE
	ldr	r0, [r1, #0x04]	@ 現在時刻
	ldr     r2,=TS_player_board_target_time
    str     r0,[r2]

pop     {r0-r12,r15}

	.section .data
	.global TS_player_board_target_time, TS_player1_board, TS_player2_board, TS_player1_mov, TS_player2_mov, TS_player1_push_time, TS_player2_push_time
TS_player_board_target_time:
	.word	0

TS_player1_board:
	.word	1

TS_player2_board:
	.word	1

TS_player1_mov:
	.word	0

TS_player2_mov:
	.word	0

TS_player1_push_time: .word	0

TS_player2_push_time: .word	0
