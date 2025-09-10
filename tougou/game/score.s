/*--------------------------------------
score.s: スコア表示・勝敗判定・状態遷移

input: HK_point1, HK_point2（各プレイヤー得点）
output: HK_write_number_in, frame_buffer（スコア表示）

MY_show_score: 1P/2Pスコア表示
MY_check_score: 勝敗判定・状態遷移（score→result→reset）
--------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		MY_show_score, MY_buffer_ischanged_init
MY_show_score:
	push	{r0-r12, r14}

	ldr	r0, =buffer_ischanged
	ldr	r1, [r0]
	cmp	r1, #1		@buffer_ischanged == 1
	beq	endifMss
	add	r1, r1, #1
	str	r1, [r0]	@buffer_ischanged = 1
	ldr	r1, =HK_point1
	ldr	r2, =HK_point2
	ldr	r11, [r1]
	ldr	r12, [r2]
	
	ldr	r5, =10
	mul	r4, r11, r5
	add	r4, r4, r12	@十の位に1p, 一の位に2p得点
	ldr	r1, =HK_write_number_in
	str	r4, [r1]
	bl	HK_write_numbers
	ldr	r1, =MY_rotate_90_n
	ldr	r0, =1
	str	r0, [r1]	@回転回数1
	bl	MY_rotate_90	@90まわす
endifMss:	
	pop	{r0-r12, r15}

MY_buffer_ischanged_init:	
	push	{r0-r12, r14}
	ldr	r0, =buffer_ischanged		@buffer_ischanged初期化
	ldr	r1, =0
	str	r1, [r0]
	pop	{r0-r12, r15}

	.section .data
buffer_ischanged:	.word 0
