	@ BGMを奏でるプログラム(繰り返し鳴り続ける)
	@ BGMを開始するときに MS_play_bgm_target_time を現在時刻で初期化
	@ MS_SE_status を読み取り，SEと音がかぶらないように処理
	@ bgm_offset に曲目, step_offset に曲の進行状況を保存
	
	.include "common.h"
	.section .text
	.global	 MS_play_bgm
MS_play_bgm:
	push	{r0-r12, r14}

	@ タスク実行の判定 (SEが鳴っているか, status == 1 -> break)
	ldr	r0, =MS_SE_status
	ldr	r0, [r0]
	cmp	r0, #1
	popeq	{r0-r12, r15}	@ break
	
	@ タスク実行の判定, (目標時刻 > 現在時刻 -> break)
	ldr	r0, =MS_play_bgm_target_time
	ldr	r1, [r0]	@ 目標時刻
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]	@ 現在時刻
	@ 各音の末尾を7500カウント削る
	ldr	r3, =7500
	sub	r1, r1, r3
	cmp	r1, r2
	blle	stop
	add	r1, r1, r3
	cmp	r1, r2
	popgt	{r0-r12, r15}	@ break
	
	@ タスクの実行時，次の目標時刻の取得更新(r1に目標時刻を与える)
	bl	task_target_time_update
	@ タスクの実行
	bl	task

	pop	{r0-r12, r15}

stop:
	push	{r0-r12, r14}
	ldr	r0, =PWM_BASE
	mov	r1, #0
	str	r1, [r0, #PWM_DAT2]
	pop	{r0-r12, r15}
	
	
	
task:
	@ スピーカーから出力する音の変更
	ldr	r0, =MS_bgm_list
	ldr	r1, =MS_bgm_offset		@ 曲目のオフセット取得
	ldr	r1, [r1]
	ldr	r0, [r0, r1]
	ldr	r1, =step_offset	@ 曲の進行状況オフセットの取得
	ldr	r1, [r1]
	ldr	r2, [r0, r1]
	ldr	r0, =PWM_BASE
	cmp	r2, #0			@ RNG2に 0 をしまうとバグる
	strne	r2, [r0, #PWM_RNG2]
	lsrne	r2, r2, #1
	str	r2, [r0, #PWM_DAT2]

	@ オフセットの更新
	ldr	r0, =step_offset
	ldr	r1, [r0]
	add	r1, r1, #4
	str	r1, [r0]
	
	bx	r14

task_target_time_update:
	@ 目標時刻を1つ前の目標時刻+音符の長さに設定
	push	{r14}
	
	ldr	r0, =MS_bgm_len_list
	ldr	r7, =MS_bgm_offset		@ 曲目のオフセット取得
	ldr	r7, [r7]
	ldr	r0, [r0, r7]		@ 曲目選択
	ldr	r1, =step_offset	@ ステップオフセットの取得
	ldr	r1, [r1]
	ldr	r1, [r0, r1]		@ 各音符の長さを取得
	
	@ 曲の終わり(0xffffffff)で最初に戻る(目標時刻の更新は行わない)
	cmp	r1, #0xffffffff
	moveq	r8, #0
	ldreq	r7, =step_offset
	streq	r8, [r7]
	popeq	{r14}
	beq	MS_play_bgm

	@ 目標時刻の更新
	ldr	r0, =MS_play_bgm_target_time
	ldr	r2, [r0]
	add	r1, r1, r2
	str	r1, [r0]

	pop	{r15}
	
	@ タスクの更新のみ行うサブルーチン
	.global MS_shadow_target_time_update
MS_shadow_target_time_update:
	push	{r0-r12, r14}
	@ タスク実行の判定, (目標時刻 <= 現在時刻 で実行)
	ldr	r0, =MS_play_bgm_target_time
	ldr	r1, [r0]	@ 目標時刻
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]	@ 現在時刻
	cmp	r1, r2
	@ タスクの実行時，次の目標時刻の取得更新(r1に目標時刻を与える)
	popgt	{r0-r12, r15}
	
	ldr	r0, =MS_bgm_len_list
	ldr	r7, =MS_bgm_offset		@ 曲目のオフセット取得
	ldr	r7, [r7]
	ldr	r0, [r0, r7]		@ 曲目選択
	ldr	r1, =step_offset	@ ステップオフセットの取得
	ldr	r1, [r1]
	ldr	r1, [r0, r1]		@ 各音符の長さを取得
	
	@ 曲の終わり(0xffffffff)で最初に戻る(目標時刻の更新は行わない)
	cmp	r1, #0xffffffff
	moveq	r8, #0
	ldreq	r7, =step_offset
	streq	r8, [r7]
	popeq	{r0-r12, r15}
	
	@ 目標時刻の更新
	ldr	r0, =MS_play_bgm_target_time
	ldr	r2, [r0]
	add	r1, r1, r2
	str	r1, [r0]
	@ オフセットの更新
	ldr	r0, =step_offset
	ldr	r1, [r0]
	add	r1, r1, #4
	str	r1, [r0]

	pop	{r0-r12, r15}

	.global MS_play_bgm_init
MS_play_bgm_init:
	push	{r0-r12, r14}

	ldr	r0, =MS_play_bgm_target_time
	ldr	r1, =0xffffffff
	str	r1, [r0]

	ldr	r0, =step_offset
	mov	r1, #0
	str	r1, [r0]

	ldr	r0, =MS_bgm_offset
	mov	r1, #0
	str	r1, [r0]

	pop	{r0-r12, r15}

	
	.section .data
	.global MS_play_bgm_target_time
MS_play_bgm_target_time:
	.word	0xffffffff
step_offset:
	.word	0
	.global MS_bgm_offset
MS_bgm_offset:
	.word	4
pre_sound:
	.word	0
