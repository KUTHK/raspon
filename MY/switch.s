@スイッチが押されているかを返すプログラム
@sw_bufに下位bitから順にボタンの押下情報を保持
@画面の更新をした場合0に戻す処理をすると良い
    .include "common.h"
    .section .text
	.global switch, TS_switch_out, TS_switch_save
switch:
    push {r0-r12,r14}
    @初期設定
    ldr     r0, =GPIO_BASE
    ldr     r2, =GPLEV0
	add     r2,r2,r0
	ldr     r2,[r2]
    @TS_switch_outの初期化
    ldr     r3,=TS_switch_out
    mov     r4,#0
    str     r4,[r3]

    @現在時刻の取得
    ldr	    r6, =TIMER_BASE
	ldr	    r5, [r6, #0x4]
    bl      sw_p1
    bl      sw_p2
    bl      sw_check
    
    pop {r0-r12,r15}

sw_p1:
push    {r14}

	tst     r2,#(1 << SW1_PORT)
    addne   r4,r4,#1
	tst     r2,#(1 << SW2_PORT)
    addne   r4,r4,#2

pop     {r15}

sw_p2:
push    {r14}

    tst     r2,#(1 << SW3_PORT)
    addne   r4,r4,#4
	tst     r2,#(1 << SW4_PORT)
    addne   r4,r4,#8

pop     {r15}

sw_check:
push    {r0-r12,r14}

    ldr     r3,=TS_switch_save
    ldr     r5,[r3]

    eor     r6,r4,r5
    and     r5,r6,r4
    str     r4,[r3]

    ldr     r3,=TS_switch_out
    str     r5,[r3]

pop     {r0-r12,r15}
	.section .data
TS_switch_out: .word 0

TS_switch_save: .word 0
