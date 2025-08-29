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
    ldr	r2, =TS_playar_bord_target_time
	str	r1, [r2]
	@ 各タスクに目標時間をコピー
	ldr	r0, =100000
	str	r1, [r0]
	
loop:
	bl switch
    ldr      r0,=TS_switch_out
    ldrb     r1,[r0]

    @tst     r1,#1
    @blne    LED_ON
    @tst     r1,#2
    @blne    LED_OFF

    ldr     r3,=HK_write_number_in
    str     r1,[r3]
    bl      HK_write_number

	b	loop

	.section .data
task_target_time:
	.word	0
