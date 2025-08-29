	.include "common.h"

	.equ	TIMER_HZ, 1000000
    .equ    TIMER_100m, 100000
	
	.section .init
	.global	_start
_start:
	@ LEDとディスプレイ用のIOポートを出力に設定する
	mov	sp, #STACK	@ スタックポインタの指定
	ldr     r0, =GPIO_BASE
	ldr     r1, =GPFSEL_VEC0
	str     r1, [r0, #GPFSEL0 + 0]
	ldr     r1, =GPFSEL_VEC1
	str     r1, [r0, #GPFSEL0 + 4]
	ldr     r1, =GPFSEL_VEC2
	str     r1, [r0, #GPFSEL0 + 8]

	@ 初期化

	bl	draw_init
	
	@ r12 レジスタに描画する数値を保存
	@ r2 レジスタに数字の描画時間を保存
	mov	r12, #0
    bl num_buf
	ldr	r1, =TIMER_BASE
	ldr	r2, [r1, #0x4]
	ldr	r3, =TIMER_100m
	
	add	r5, r2, r3		@r5には目標時刻を保存
	ldr	r6, =1000
	add	r7, r2, r6

    mov r9,#0
    @r10に0.5秒,r11にledの点灯情報(1で点灯,2で消灯)
    ldr r10,=TIMER_HZ
    mov r10,r10, lsr #1
    mov r11,#1
    mov r2,r10
loop:
	@ 数値の更新タスク
	ldr	r4, [r1, #0x4]
    bl  switch
    ldr  r8,=TS_switch_out
    ldrb r8,[r8]

    @ディスプレイの処理r9に数値の更新を行う場合は1,行わない場合は0を入れる
    tst     r8,#1
    movne   r9,#1
    tst     r8,#2
    movne   r9,#0

    @ledの表示を管理する値の変更
    cmp     r2,r4
    addle   r2,r10
    eorle   r11,r11,#1

    @タイマーの状態の変更
    cmp     r9,#1
    bleq    task_timer_run
    blne    task_timer_stop

    @ledの状態の変更
    cmp     r11,#1
    bleq    LED_ON
    blne    LED_OFF

	@ 描画の更新タスク
	cmp	r7, r4
	addle	r7, r6
	blle	HK_display

	b	loop

task_timer_run:
    @呼び出すとタイマーが動く
	push {r0-r4,r6-r11,r14}

    cmp	    r5, r4
	addle	r5, r3

    addle	r12, r12, #1
	cmp	    r12, #100
	moveq	r12, #0
	
	bl	num_buf

    pop {r0-r4,r6-r11,r15}
task_timer_stop:
    @呼び出すとタイマーが止まる
	push {r0-r4,r6-r11,r14}

    cmp	    r5, r4
	addle	r5, r3

    pop {r0-r4,r6-r11,r15}