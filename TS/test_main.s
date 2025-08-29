	.include "common.h"
	.section .init
	.global	_start
_start:
	bl	GPIO_init
	bl	PWM_init
	@ タスクの目標時刻の初期設定(共通)
	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	@ 各タスクに目標時間をコピー
	@ldr	r0, =100000
	@str	r1, [r0]
	
loop:
	bl		OS_goalJudg
	ldr		r0,=OS_goalJudg_out
	ldr		r1,[r0]

	ldr     r2,=HK_write_number_in
    str     r1,[r2]
    bl      HK_write_numbers

    bl HK_display

	b	loop

	.section .data
task_target_time:
	.word	0
