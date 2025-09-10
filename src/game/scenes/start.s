/*--------------------------------------
start 画面
HK_start: start 画面を流す
HK_start_init: start になる状態推移時に呼び出す(初期設定)
--------------------------------------*/

	.include	"common.h"
	.section	.text
	.global	HK_start, HK_start_init

@ start 画面(更新)
HK_start:
	push	{r0-r12, r14}

	bl	HK_slide_text

	pop	{r0-r12, r15}

@ start 初期設定
HK_start_init:
	push	{r0-r12, r14}

	ldr	r0, =HK_update_text_address
	ldr	r1, =start_text
	str	r1, [r0]
	
	bl	HK_write_text

	pop	{r0-r12, r15}

	.section	.data
start_text:	.ascii	" RASPON\n"

