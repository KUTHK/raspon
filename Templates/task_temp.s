	@ タスクのテンプレート
	@ 初期のターゲットタイムは init でコピーしておく
	.include "common.h"
	.section .text
	.global task_template
task_template:
	push	{r0-r12, r14}
	@ タスク実行の判定, (目標時刻 <= 現在時刻 で実行)
	ldr	r0, =template_target_time
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
	@ ここにタスクの中身

	bx	r14

task_target_time_update:
	push	{r0-r12, r14}

	ldr	r0, @タスク間隔
	ldr	r1, [r0]
	ldr	r0, =template_target_time
	ldr	r2, [r0]
	add	r1, r1, r2
	ldr	r0, =template_target_time
	str	r1, [r0]

	pop	{r0-r12, r15}


	.section .data
	.global template_target_time
template_target_time:
	.word	0
