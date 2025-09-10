/*--------------------------------------
start.s: スタート画面表示

input: HK_update_text_address（表示テキストアドレス）
output: frame_buffer（スタート画面表示内容を書き込む）

HK_start: スタート画面表示
HK_start_init: スタート画面用の初期設定
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

