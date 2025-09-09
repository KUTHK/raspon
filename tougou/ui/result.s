	/*-----------------------------------------------
MY_show_result:
	勝敗がついたときに流すフレームバッファを生成する
	HK_winnerの値によって回転回数を変えてYOU WINを流す
MY_show_result_init:	
	MY_show_result_initの初期設定
	score -> result -> reset
	---------------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		MY_show_result_init, MY_show_result
@勝った方向に"YOU WINをながす"
MY_show_result:
	push	{r0-r12, r14}

	ldr	r0, =HK_winner
	ldr	r1, [r0]
	cmp	r1, #1		@HK_winner == 1
	beq	win_1p
	bl	HK_slide_text_rotate
/*
	ldr	r2, =MY_rotate_90_n
	ldr	r3, =2
	str	r3, [r2]	@回転回数2(180度)
*/
	b	endifMsr

win_1p:	@回転なし
/*
	ldr	r2, =MY_rotate_90_n
	ldr	r3, =0
	str	r3, [r2]	@回転回数0(0度)
*/
	bl	HK_slide_text
endifMsr:
	pop	{r0-r12, r15}

@MY_show_result初期設定
MY_show_result_init:
	push	{r0-r12, r14}
	ldr	r0, =HK_update_text_address
	ldr	r1, =result_text
	str	r1, [r0]
	bl	HK_write_text
	ldr	r0, =HK_winner
	ldr	r1, [r0]
	cmp	r1, #1
	beq	endifMsri
	bl	MY_x_rotate_buffer
	bl	MY_y_rotate_buffer
endifMsri:	
	pop	{r0-r12, r15}

	.section	.data
result_text:	.ascii	" YOU WIN\n" @流す文字
