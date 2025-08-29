	.include "common.h"
	.section .init
	.global	_start
_start:
	bl	GPIO_init
	bl	PWM_init
	@ タスクの目標時刻の初期設定(共通)
	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2, =task_target_time
	str	r1, [r2]
	@ 各タスクに目標時間をコピー
	ldr	r0, =hoge
	str	r1, [r0]
	
loop:
	bl	sub1
	bl	sub2
	bl	sub3

	b	loop

	.section .data
task_target_time:
	.word	0
