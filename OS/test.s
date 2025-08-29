    .section .init
	.global _start
	.include "common.h"

_start:
    @ GPIO 制御用の番地
	ldr	r0, =GPIO_BASE

	@ GPIO #10 を出力用に GPIO #11 ~ #19 を入力用に設定
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL1]

    ldr r2, =KT_ball_pos_y  @グローバル変数のアドレス取得
    ldr r3, =0              @代入する数字きめる
    str r3, [r2]            @グローバル変数KT_ball_pos_yに0代入

    bl OS_goalJudg          @関数呼び出し

    ldr r2, =OS_goalJudg_out    @グローバル変数OS_goalJudg_outのアドレス取得
    ldr r2, [r2]                @グローバル変数OS_goalJudg_outの中身を取得
    cmp r2, #1      @r2の中身が1(true)かをみる
    bne loop        @1じゃないならloopにいく
    @LED光らせる処理
    mov	r1, #(1 << LED_PORT)
	str	r1, [r0, #GPSET0]

loop:	b	loop    @光ったままか消えたままにする

    .section .data
	@ 整数型で保存するボールの仮の位置
	.global	KT_ball_pos_y
KT_ball_pos_y: 
    .word	0

