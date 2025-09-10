/*--------------------------------------
point.s: 得点管理・勝者判定・加算処理

input: なし（内部でグローバル変数を参照）
output: HK_point1, HK_point2, HK_winner（得点・勝者情報）

HK_winner: 勝敗判定, HK_add_point1/2: 得点加算, HK_reset_point: リセット
--------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		HK_add_point1, HK_add_point2, HK_reset_point

@ player1 の得点を 1 加算
HK_add_point1:
	push	{r0-r12, r14}

	ldr	r0, =HK_point1
	ldr	r1, [r0]
	add	r1, r1, #1
	str	r1, [r0]

	@ 勝敗判定
	ldr	r2, =HK_win_point
	ldr	r3, [r2]
	cmp	r1, r3
	ldrge	r4, =HK_winner
	ldrge	r5, =1
	strge	r5, [r4]

	pop	{r0-r12, r15}

@ player2 の得点を 1 加算
HK_add_point2:
	push	{r0-r12, r14}

	ldr	r0, =HK_point2
	ldr	r1, [r0]
	add	r1, r1, #1
	str	r1, [r0]

	@ 勝敗判定
	ldr	r2, =HK_win_point
	ldr	r3, [r2]
	cmp	r1, r3
	ldrge	r4, =HK_winner
	ldrge	r5, =2
	strge	r5, [r4]

	pop	{r0-r12, r15}

@ player1, player2 の得点を 0 にする
HK_reset_point:
	push	{r0-r12, r14}

	ldr	r1, =0
	ldr	r0, =HK_point1
	str	r1, [r0]
	
	ldr	r0, =HK_point2
	str	r1, [r0]

	ldr	r0, =HK_winner
	str	r1, [r0]

	pop	{r0-r12, r15}

@ 得点: HK_point1, HK_point2 (global) 直接書き換えることも可能
	.section	.data
	.global	HK_point1, HK_point2, HK_win_point, HK_winner
HK_point1:	.word	0
HK_point2:	.word	0
HK_win_point:	.word	3
HK_winner:	.word	0





