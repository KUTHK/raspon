/*--------------------------------------
ball.s: ボール制御・座標・衝突・初期化・状態管理

input: KT_ball_init_player1/2, KT_ball_player1_pushed, KT_ball_player2_pushed など
output: KT_ball_pos_x, KT_ball_pos_y, KT_collision など（ボール状態）

KT_ball_init, KT_ball_move, KT_ball_pos_x/y, KT_collision などボール関連処理
--------------------------------------*/
	@ ボールの制御用タスク
	@ アクセスするデータ 各プレイヤーの位置,framebuffer
	@ KT_ball_init ball.sで利用する変数の初期化
	@ KT_ball_move ballの位置を更新するタスク
	@ KT_ball_pos_x, KT_ball_pos_y ボールの位置を保存(0~7)
	@ KT_collision ボールが衝突した物体の種類を保存(0 壁, 1 反射板)
	@ KT_ball_player1_pushed, KT_ball_player2_pushed 対応するプレイヤーのボタンが押されたタイミングで呼び出す。最初のボタン入力だったときballが動き出す
	@ KT_ball_init_player1, KT_ball_init_player2 ボールの初期位置を対応するplayerの位置にする
	@ 画面座標右上を(0,0)とする
	.include "common.h"
	.section .text
	.global KT_ball_init
KT_ball_init:
	push	{r14}
	@ ballの仮の初期座標を保存
	ldr	r2, =ball_init_player
	ldr	r2, [r2]
	cmp	r2, #0
	
	ldr	r0, =KT_ball_pos_x
	mov	r1, #2
	str	r1, [r0]
	ldr	r0, =KT_ball_pos_y
	mov	r1, #1
	rsbeq	r1, r1, #7
	str	r1, [r0]
	@ ballの初期角度を保存
	ldr	r0, =ball_dir_type
	mov	r1, #2
	rsbeq	r1, r1, #13
	str	r1, [r0]
	@ ballの真の初期座標の保存
	ldr	r0, =ball_pos_x_fixed
	ldr	r1, =KT_ball_pos_x
	ldr	r1, [r1]
	lsl	r1, r1, #24
	str	r1, [r0]
	ldr	r0, =ball_pos_y_fixed
	ldr	r1, =KT_ball_pos_y
	ldr	r1, [r1]
	lsl	r1, r1, #24
	str	r1, [r0]

	@ KT_collisionの初期化
	ldr	r0, =KT_collision
	mov	r1, #-1
	str	r1, [r0]
	
	@ ball_task_timeの初期化
	ldr	r0, =ball_task_time
	ldr	r1, =TIMER_BASE
	ldr	r1, [r1, #0x04]
	str	r1, [r0]

	@ ball_ismoveの初期化
	ldr	r0, =ball_is_move
	mov	r1, #0
	str	r1, [r0]

	@ ball_task_widthの初期化
	ldr	r0, =ball_task_width
	ldr	r1, =150000
	str	r1, [r0]
	
	pop	{r15}
	
	.global KT_ball_move
	@ 現在のボールの位置を更新するサブルーチン
KT_ball_move:
	push	{r14}
	@ タスクを実行するかの確認
	ldr	r0, =ball_is_move
	ldr	r0, [r0]
	cmp	r0, #0
	bleq	framebuffer_ball_pos_write
	cmp	r0, #0
	popeq	{r15}
	
	ldr	r0, =ball_task_time
	ldr	r0, [r0]
	ldr	r1, =TIMER_BASE
	ldr	r1, [r1, #0x04]
	cmp	r0, r1
	popgt	{r15}

	ldr	r1, =ball_task_time
	ldr	r2, =ball_task_width
	ldr	r2, [r2]
	add	r0, r0, r2
	str	r0, [r1]

	ldr	r0, =KT_ball_pos_y
	ldr	r0, [r0]
	cmp	r0, #0
	popeq	{r15}

	cmp	r0, #7
	popeq	{r15}

	@ frame_bufferから前のボールの位置の点灯を削除
	bl	framebuffer_ball_pos_clear
	
	@ 固定小数形式のボールの真の位置の呼び出し
	ldr	r0, =ball_pos_x_fixed
	ldr	r1, [r0]
	ldr	r2, =ball_pos_y_fixed
	ldr	r3, [r2]

	@ ボールの角度と速度を呼び出し
	ldr	r4, =ball_dir_type
	ldr	r4, [r4]
	ldr	r5, =ball_speed
	ldr	r5, [r5]

	@ ボールの位置の変化量を呼び出し
	ldr	r6, =ball_dir_data_x_fixed
	ldr	r6, [r6, r4, lsl #2]
	ldr	r7, =ball_dir_data_y_fixed
	ldr	r7, [r7, r4, lsl #2]

	@ ボールの位置の変化量の正負を呼び出し
	ldr	r8, =ball_dir_data_x_signed
	ldr	r8, [r8, r4, lsl #2]
	ldr	r9, =ball_dir_data_y_signed
	ldr	r9, [r9, r4, lsl #2]

	@ ボールの変化量に速度を乗算
	mul	r10, r6, r5
	mul	r11, r7, r5
	
	@ ボールの真の位置を更新
	cmp	r8, #0
	addeq	r1, r1, r10
	subne	r1, r1, r10

	cmp	r9, #0
	addeq	r3, r3, r11
	subne	r3, r3, r11

	@ 真の数値の更新
	ldr	r0, =ball_pos_x_fixed
	str	r1, [r0]
	ldr	r2, =ball_pos_y_fixed
	str	r3, [r2]

	@ 真の数値の調整(0以上8未満の数値に収める) 反射処理
	bl	ball_dir_reflect_x
	bl	ball_dir_reflect_y

	@ 整数化の処理
	ldr	r1, =ball_pos_x_fixed
	ldr	r1, [r1]
	mov	r0, r1, lsr #24
	ldr	r3, =ball_pos_y_fixed
	ldr	r3, [r3]
	mov	r2, r3, lsr #24

	@ 仮の値の更新
	ldr	r1, =KT_ball_pos_x
	str	r0, [r1]
	ldr	r3, =KT_ball_pos_y
	str	r2, [r3]
	
	@ frame_bufferの更新
	bl	framebuffer_ball_pos_write

	pop	{r15}

	@ KT_ball_pos_x, KT_ball_pos_yの値に対応したframebufferのビットを0にする
framebuffer_ball_pos_clear:
	push	{r0-r12, r14}
	
	ldr	r0, =KT_ball_pos_x
	ldr	r0, [r0]
	mov	r1, #1
	cmp	r0, #0
	lslne	r0, r1, r0
	moveq	r0, r1
	ldr	r2, =KT_ball_pos_y
	ldr	r2, [r2]
	
	ldr	r3, =frame_buffer
	ldrb	r4, [r3, r2]
	eor	r0, r0, r4
	strb	r0, [r3, r2]

	pop	{r0-r12, r15}
	
	@ KT_ball_pos_x, KT_ball_pos_yの値に対応したframebufferのビットを1にする
framebuffer_ball_pos_write:
	push	{r0-r12, r14}
	
	ldr	r0, =KT_ball_pos_x
	ldr	r0, [r0]
	mov	r1, #1
	cmp	r0, #0
	lslne	r0, r1, r0
	moveq	r0, r1
	ldr	r2, =KT_ball_pos_y
	ldr	r2, [r2]

	ldr	r3, =frame_buffer
	ldrb	r4, [r3, r2]
	orr	r0, r0, r4
	strb	r0, [r3, r2]

	pop	{r0-r12, r15}
	
	@ ボールが壁に当たったときの反射
ball_dir_reflect_x:
	push	{r0, r1, r14}

	ldr	r0, =ball_pos_x_fixed
	ldr	r1, [r0]

	@ ボールの位置を範囲内にする(0.5~7.5)
	mov	r11, #(1 << 23)
	cmp	r1, r11
	sublt	r10, r11, r1
	addlt	r1, r11, r10
	blt	reflect_x
	
	mov	r11, #(15 << 23)
	cmp	r1, r11
	subge	r10, r1, r11
	subge	r1, r11, r10
	bge	reflect_x

	pop	{r0, r1, r15}
reflect_x:

	ldr	r0, =ball_pos_x_fixed
	str	r1, [r0]
	
	@ SE用のデータ保存
	ldr	r0, =KT_collision
	mov	r1, #0
	str	r1, [r0]
	
	ldr	r0, =ball_dir_type
	ldr	r1, [r0]
	cmp	r1, #6
	rsble	r1, r1, #6
	rsbgt	r1, r1, #20
	str	r1, [r0]
	
	pop	{r0, r1, r15}

	@ ボールがplayerに当たったときの反射
ball_dir_reflect_y:
	push	{r0, r1, r14}

	ldr	r0, =ball_pos_y_fixed
	ldr	r3, [r0]
	cmp	r3, #(3 << 23)
	ldrle	r1, =TS_player1_board
	ldrle	r1, [r1]
	ble	reflect_if
	cmp	r3, #(13 << 23)
	ldrge	r1, =TS_player2_board
	ldrge	r1, [r1]
	bge	reflect_if
	b	reflect_end
reflect_if:
	ldr	r0, =KT_ball_pos_x
	ldr	r0, [r0]
	sub	r0, r0, r1

	cmp	r0, #1
	bgt	reflect_end
	cmp	r0, #-1
	blt	reflect_end
reflect_y:
	ldr	r0, =ball_pos_y_fixed
	ldr	r3, [r0]

	@ ボールの位置を範囲内にする(1.5~6.5)
	mov	r11, #(3 << 23)
	cmp	r3, r11
	sublt	r10, r11, r3
	addlt	r3, r11, r10

	mov	r11, #(13 << 23)
	cmp	r3, r11
	subge	r10, r3, r11
	subge	r3, r11, r10

	ldr	r0, =ball_pos_y_fixed
	str	r3, [r0]
	
	@ SE用のデータ保存
	ldr	r0, =KT_collision
	mov	r1, #1
	str	r1, [r0]

	@ taskの加速
	@bl	ball_task_acceleration
	
	ldr	r0, =ball_dir_type
	ldr	r1, [r0]
	rsb	r1, r1, #13
	str	r1, [r0]
	
	@ 前の移動の時間から角度変化を行うか判定
	ldr	r0, =ball_dir_type
	ldr	r1, [r0]

	cmp	r1, #6
	
	ldrle	r3, =TS_player1_push_time
	ldrgt	r3, =TS_player2_push_time
	ldr	r3, [r3]
	ldr	r4, =ball_player_time_width
	add	r3, r3, r4
	
	ldr	r4, =TIMER_BASE
	ldr	r4, [r4, #0x04]
	cmp	r3, r4
	blt	reflect_end

	@ 角度変化
	ldr	r0, =ball_dir_type
	ldr	r1, [r0]

	cmp	r1, #6
	ldrle	r2, =TS_player1_mov
	ldrgt	r2, =TS_player2_mov
	ldr	r2, [r2]
	ldrlt	r3, =-1
	movlt	r4, r2
	mullt	r2, r4, r3
	cmp	r2, #-1
	bleq	ball_dir_sub
	cmp	r2, #1
	bleq	ball_dir_add
	
reflect_end:
	
	pop	{r0, r1, r15}

	@ ballの角度を変化させる
ball_dir_sub:
	push	{r14}

	ldr	r0, =ball_dir_type
	ldr	r1, [r0]
	
	cmp	r1, #0
	popeq	{r15}
	cmp	r1, #7
	popeq	{r15}
	sub	r1, r1, #1

	str	r1, [r0]
	
	pop	{r15}
	
ball_dir_add:
	push	{r14}

	ldr	r0, =ball_dir_type
	ldr	r1, [r0]
	
	cmp	r1, #6
	popeq	{r15}
	cmp	r1, #13
	popeq	{r15}
	add	r1, r1, #1

	str	r1, [r0]
	
	pop	{r15}

	@ どちらのplayerがボールを持つか決める
	.global KT_ball_init_player1
KT_ball_init_player1:
	push	{r0-r12, r14}
	
	ldr	r0, =ball_init_player
	mov	r1, #0
	str	r1, [r0]
	
	pop	{r0-r12, r15}
	
	.global KT_ball_init_player2
	
KT_ball_init_player2:
	push	{r0-r12, r14}

	ldr	r0, =ball_init_player
	mov	r1, #1
	str	r1, [r0]
	
	pop	{r0-r12, r15}

	@ 初めてボタンが押されたときボールが動き出すようにする
	.global	KT_ball_player1_pushed
KT_ball_player1_pushed:
	push	{r0-r12, r14}

	ldr	r0, =ball_is_move
	ldr	r0, [r0]
	cmp	r0, #0
	popne	{r0-r12, r15}
	ldr	r0, =ball_init_player
	ldr	r0, [r0]
	cmp	r0, #0
	popne	{r0-r12, r15}
	ldr	r0, =ball_is_move
	mov	r1, #1
	str	r1, [r0]

	ldr	r0, =ball_task_time
	ldr	r1, =TIMER_BASE
	ldr	r1, [r1, #0x04]
	str	r1, [r0]
	
	pop	{r0-r12, r15}
	
	.global KT_ball_player2_pushed
KT_ball_player2_pushed:	
	push	{r0-r12, r14}

	ldr	r0, =ball_is_move
	ldr	r0, [r0]
	cmp	r0, #0
	popne	{r0-r12, r15}
	ldr	r0, =ball_init_player
	ldr	r0, [r0]
	cmp	r0, #1
	popne	{r0-r12, r15}
	ldr	r0, =ball_is_move
	mov	r1, #1
	str	r1, [r0]

	ldr	r0, =ball_task_time
	ldr	r1, =TIMER_BASE
	ldr	r1, [r1, #0x04]
	str	r1, [r0]
	
	pop	{r0-r12, r15}

	@ task間隔を減らすことでballを加速する
ball_task_acceleration:
	push	{r0-r12, r14}

	ldr	r0, =ball_task_width
	ldr	r1, [r0]
	ldr	r2, =ball_task_width_min
	cmp	r1, r2
	pople	{r0-r12, r15}
	ldr	r2, =ball_task_acceleration_num
	sub	r1, r1, r2
	str	r1, [r0]
	
	pop	{r0-r12, r15}
	
	.section .data
	@ 整数型で保存するボールの仮の位置
	.global	KT_ball_pos_x
KT_ball_pos_x:
	.word	0
	.global	KT_ball_pos_y
KT_ball_pos_y:
	.word	0
	.global	KT_collision
KT_collision:
	.word	-1
	@ ボールの角度のタイプを保存
ball_dir_type:
	@ 30, 45, 60, 90, 120, 135, 150, 210, 225, 240, 300, 315, 330
	.word	0
	@ ボールの速度
ball_speed:
	.word	1
	@ 固定小数形式でボールの真の位置を保存する
	@ 固定小数は整数部８ビット小数部２４ビットで管理する
ball_pos_x_fixed:
	.word	0
ball_pos_y_fixed:
	.word	0

ball_task_time:
	.word	0
ball_task_width:
	.word	0
	@ ボールのタスクの減算量
	.equ	ball_task_acceleration_num, 100
	.equ	ball_task_width_min, 10000
	@ ball_dir_typeに対応した角度を固定小数で保存する
ball_dir_data_x_fixed:
	@ cos(30), cos(45), cos(60), cos(90), cos(120), cos(135), cos(150),
	@ cos(210), cos(225), cos(240), cos(270), cos(300), cos(315), cos(330)
	.word	0x00ddb22d, 0x00b50481, 0x00800000, 0x00000000, 0x00800000, 0x00b50481, 0x00ddb22d, 0x00ddb22d, 0x00b50481, 0x00800000, 0x00000000, 0x00800000, 0x00b50481, 0x00ddb22d

ball_dir_data_x_signed:
	@ 0のとき正の値が保存されており、1のとき負の値が保存されている
	.word	0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0
	
ball_dir_data_y_fixed:
	@ sin(30), sin(45), sin(60), sin(90), sin(120), sin(135), sin(150),
	@ sin(210), sin(225), sin(240), sin(270), sin(300), sin(315), sin(330)
	.word	0x00800000, 0x00b50481, 0x00ddb22d, 0x01000000, 0x00ddb22d, 0x00b50481, 0x00800000, 0x00800000, 0x00b50481, 0x00ddb22d, 0x01000000, 0x00ddb22d, 0x00b50481, 0x00800000

ball_dir_data_y_signed:
	.word	0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1

	@ playerが移動してから移動量が利用可能な期間
	.equ	ball_player_time_width, 1000*1000/10

	@ 0 最初のボタン入力前 1 ボタン入力があった 
ball_is_move:
	.word	0

	@ 0 ならplayer1からスタート 1 ならplayer2からスタート
ball_init_player:
	.word	0
	

