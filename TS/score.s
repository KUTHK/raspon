	/*-----------------------------------------------
MY_show_score:
	1pと2pのスコアを表示する
	HK_point_1p
	HK_point_2p
	TS_switch_outが0以外だったら終わり
MY_check_score:	
	どちらかが勝っているかそうでないかでmain_statusの値を書き換えるサブルーチン
	score -> result -> reset
	---------------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		MY_show_score, MY_check_score
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
/*
displayloop:			@なにかボタン押されるまでずっと得点表示バッファ
	bl	HK_display
	bl	switch
	ldr	r3, =TS_switch_out
	ldr	r4, [r3]
	cmp	r4, #0
	beq	displayloop

	@どちらかが9点
	cmp	r11, #9
	cmp	r12, #9
	bge	setEnd
	b	endif
setEnd:	
	ldr	r1, =isEnd
	ldr	r2, =1
	str	r2, [r1]
*/
endifMss:	
	pop	{r0-r12, r15}

	@スイッチ押されたとき,どっちかが勝っていたらstatusを8に書き換えるそれ以外statusを2に書き換える
	@スイッチ押されてないときはなにもしない
MY_check_score:
	push	{r0-r12, r14}

	ldr	r0, =HK_winner	@0:どっちもかってない1:1p勝ち2:2p勝ち
	ldr	r1, [r0]
	cmp	r1, #0		@HK_winner == 0
	bne	end_game
	ldr	r3, =2			@ゲーム中にとばす
	ldr	r2, =main_status	@全体のstatusを切り替える
	str	r3, [r2]
	b	buffer_ischanged_init
end_game:
	ldr	r3, =8			@ゲーム終了へ飛ばす
	ldr	r2, =main_status	@全体のstatusを切り替える
	str	r3, [r2]
buffer_ischanged_init:	
	ldr	r0, =buffer_ischanged		@buffer_ischanged初期化
	ldr	r1, =0
	str	r1, [r0]
endifMcs:
	pop	{r0-r12, r15}

	.section .data
buffer_ischanged:	.word 0
