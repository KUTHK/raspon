/*--------------------------------------
MS_sound_effect: ボールが壁や反射板に当たった際に効果音(SE)を再生する

引数: ボールの現在位置・プレイヤーの場所
戻り値: なし

グローバル変数や関連情報は必要に応じて記載
--------------------------------------*/
	
	.section .text
	.global MS_sound_effect
MS_sound_effect:
	push	{r0-r12, r14}

	ldr	r0, =sound_effect_target_time
	ldr	r1, [r0]	@ target
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]	@ current
	cmp	r1, r2
	blle	SE_stop

	bl	branch_wall
	bl	branch_bar

	@ タスクの実行時，次の目標時刻の取得更新(r1に目標時刻を与える)
	blle	task_target_time_update
	@ タスクの実行
	cmp	r1, r2
	blle	task

	pop	{r0-r12, r15}
	
branch_wall:
	@ タスク実行の判定，ボールが壁と接した場合実行 (ball_pos_x == 0, 7)
	push	{r0-r12, r14}
	@ 壁に当たった
	ldr	r0, =KT_ball_pos_x	@ ボールの現在位置(x)
	ldr	r0, [r0]
	cmp	r0, #0
	blne	branch_1
	pop	{r0-r12, r14}

branch_1:
	cmp	r0, #7
	popne	{r0-r12, r14}
	popne	{r0-r12, r15}	@ サブルーチン終了
	
	bx	r14

branch_bar:
	push	{r0-r12, r14}
	@ 反射板に当たった
	popne	{r0-r12, r14}
	popne	{r0-r12, r15}	@ サブルーチン終了

	pop	{r0-r12, r14}
	
SE_stop:
	ldr	r0, =PWM_BASE
	mov	r1, #0
	ldr	r1, [r0, #PWM_DAT2]
	bx	r14
task:
	@ SE音の設定，出力
	ldr	r0, =SE
	ldr	r1, [r0]
	ldr	r0, =PWM_BASE
	str	r1, [r0, #PWM_RNG2]
	lsr	r1, r1, #1
	str	r1, [r0, #PWM_DAT2]
	bx	r14

task_target_time_update:
	push	{r0-r12, r14}

	ldr	r0, =SE_len
	ldr	r1, [r0]
	ldr	r0, =sound_effect_target_time
	ldr	r2, [r0]
	add	r1, r1, r2
	ldr	r0, =sound_effect_target_time
	str	r1, [r0]

	pop	{r0-r12, r15}
	.include "common.h"
	.include "sound_source.h"
	.section .data
sound_effect_target_time:
	.word	0xffffffff	@ 多分到達しないと思ってる
SE:
	.word	A4
SE_len:
	.word	200*1000	@ 試験的に0.2sec
