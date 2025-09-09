	@ SEを奏でるプログラム
	@ KT_collision の値を取得し音を鳴らす, その後KT_collisionを初期化(-1)
	
	.include "common.h"
	.include "sound_source.h"
	.section .text
	.global  MS_play_SE
MS_play_SE:
	push	{r0-r12, r14}

	@ 音を止める判定
	ldr	r0, =play_SE_target_time
	ldr	r1,[r0]
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]
	cmp	r1, r2
	blle	SE_stop		@ target <= current で実行

	@ タスク実行の判定	壁・反射板に衝突していない	-> -1
	@		壁に衝突			-> 0
	@		反射板に衝突		-> 1
	mov	r1, #0		@ 比較用
	ldr	r0, =KT_collision
	ldr	r2, [r0]
	ldr	r4, =SE_offset
	str	r2, [r4]
	mov	r3, #-1
	str	r3, [r0]	@ KT_collision の初期化
	cmp	r1, r2		@ #0 <= collision
	popgt	{r0-r12, r15}
	bl	task_target_time_update
	bl	task
	
	pop	{r0-r12, r15}

SE_stop:
	push	{r14}
	ldr	r0, =MS_SE_status
	ldr	r0, [r0]
	cmp	r0, #0
	popeq	{r15}		@ SEが鳴っていない -> break
	
	ldr	r0, =PWM_BASE
	mov	r1, #0
	str	r1, [r0, #PWM_DAT2]
	ldr	r0, =MS_SE_status	@ ステータスの更新
	mov	r1, #0			@ 0 -> off
	str	r1, [r0]
	pop	{r15}

task:
	push	{r14}
	@ bgmを止める(ターゲットは更新)
	bl	MS_shadow_target_time_update
	
	@ スピーカーから出力する音の変更
	ldr	r0, =MS_SE
	ldr	r1, =SE_offset		@ SEのオフセット(壁か反射板)の取得 (0 or 1)
	ldr	r1, [r1]
	ldr	r2, [r0, r1, lsl #2]
	ldr	r2, [r2]
	ldr	r0, =PWM_BASE
	cmp	r2, #0			@ RNG2に 0 をしまうとバグる
	strne	r2, [r0, #PWM_RNG2]
	lsrne	r2, r2, #1
	str	r2, [r0, #PWM_DAT2]
	@ ステータスの更新
	ldr	r0, =MS_SE_status
	mov	r1, #1
	str	r1, [r0]

	pop	{r15}

task_target_time_update:
	push	{r14}

	ldr	r0, =MS_SE_len
	ldr	r1, =SE_offset
	ldr	r1, [r1]
	ldr	r1, [r0, r1, lsl #2]
	ldr	r1, [r1]
	@ 目標の更新
	ldr	r0, =TIMER_BASE
	ldr	r0, [r0, #0x04]
	add	r1, r0, r1
	ldr	r0, =play_SE_target_time
	str	r1, [r0]

	pop	{r15}

	.global MS_play_SE_init
MS_play_SE_init:
	push	{r0-r12, r14}

	ldr	r0, =MS_SE_status
	mov	r1, #0
	str	r1, [r0]

	ldr	r0, =play_SE_target_time
	ldr	r1,=#0xffffffff
	str	r1, [r0]

	ldr	r0, =SE_offset
	mov	r1, #0
	str	r1, [r0]

	pop	{r0-r12, r15}
	
	.section .data
	.global MS_SE_status
MS_SE_status:
	.word	0	@ 0 -> off, 1 -> on
play_SE_target_time:
	.word	0xffffffff
SE_offset:
	.word	0
