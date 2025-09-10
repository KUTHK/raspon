	/*---------------------------------------
MY_rotate_90:
	frame_bufferの値を90度回転させる
	MY_rotate_90_nに入れた値で回転回数を指定
transpose_buffer:	
	frame_bufferの値を転置させる
MY_x_rotate_buffer:
	frame_bufferの値をx軸対象で回転
MY_y_rotate_buffer:	
	frame_bufferの値をy軸対象で回転
	---------------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		MY_rotate_90, MY_x_rotate_buffer, MY_y_rotate_buffer
MY_rotate_90:
	push	{r0-r12, r14}
	@MY_rotate_90_nの値を読み込む
	ldr	r5, =MY_rotate_90_n
	ldr	r0, [r5]
	@4で割ったあまりを取る
	and	r0, r0, #3
	ldr	r1, =0
loopMr9:
	cmp	r1, r0
	bge	endifMr9
	add	r1, r1, #1
	bl	MY_x_rotate_buffer
	bl	transpose_buffer
	b	loopMr9
endifMr9:	
	pop	{r0-r12, r15}

MY_x_rotate_buffer:
	push	{r0-r12, r14}
	@frame_buffer(r1, r2)の値をswap_buffer(r1, 7 - r2)に書き込む
	ldr	r1, =7	@x
	ldr	r2, =7	@y
	ldr	r3, =7
loopx_xrb:				@内側
	mov	r11, r1
	sub	r12, r3, r2
	bl	set_swap_buffer
	subs	r1, r1, #1	@r1--
	bcc	loopy_xrb		@r1 < 0
	b	loopx_xrb
loopy_xrb:				@外側
	subs	r2, r2, #1	@r2--
	bcc	endif_xrb		@r2 < 0
	ldr	r1, =7		@r1 = 7
	b	loopx_xrb
endif_xrb:		
	@swap_buffer(r1, r2)の値をframe_buffer(r1, r2)に書き込む
	bl	write_swap_to_buffer
	pop	{r0-r12, r15}

MY_y_rotate_buffer:
	push	{r0-r12, r14}
	@frame_buffer(r1, r2)の値をswap_buffer(7 - r1, r2)に書き込む
	ldr	r1, =7	@x
	ldr	r2, =7	@y
	ldr	r3, =7
loopx_yrb:				@内側
	mov	r12, r2
	sub	r11, r3, r1
	bl	set_swap_buffer
	subs	r1, r1, #1	@r1--
	bcc	loopy_yrb		@r1 < 0
	b	loopx_yrb
loopy_yrb:				@外側
	subs	r2, r2, #1	@r2--
	bcc	endif_yrb		@r2 < 0
	ldr	r1, =7		@r1 = 7
	b	loopx_yrb
endif_yrb:		
	@swap_buffer(r1, r2)の値をframe_buffer(r1, r2)に書き込む
	bl	write_swap_to_buffer
	pop	{r0-r12, r15}

transpose_buffer:
	push	{r0-r12, r14}
	@frame_buffer(r1, r2)の値をswap_buffer(r2, r1)に書き込む
	ldr	r1, =7	@x
	ldr	r2, =7	@y
loopx1:				@内側
	mov	r11, r2
	mov	r12, r1
	bl	set_swap_buffer
	subs	r1, r1, #1	@r1--
	bcc	loopy1		@r1 < 0
	b	loopx1
loopy1:				@外側
	subs	r2, r2, #1	@r2--
	bcc	endif1		@r2 < 0
	ldr	r1, =7		@r1 = 7
	b	loopx1
endif1:
	bl	write_swap_to_buffer
	pop	{r0-r12, r15}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@サブルーチン@@@@@@@@@@@@@@@@@@@@@@@@@@@@
write_swap_to_buffer:	@swapの値をframe_bufferに書き込む
	push	{r0-r12, r14}
	@swap_buffer(r1, r2)の値をframe_buffer(r1, r2)に書き込む
	ldr	r1, =7	@x
	ldr	r2, =7	@y
loopx2:				@内側
	bl	set_buffer
	subs	r1, r1, #1	@r1--
	bcc	loopy2		@r1 < 0
	b	loopx2
loopy2:				@外側
	subs	r2, r2, #1	@r2--
	bcc	endif2		@r2 < 0
	ldr	r1, =7		@r1 = 7

	b	loopx2

endif2:	
	pop	{r0-r12, r14}

set_swap_buffer:		@frame_bufferの(r1, r2)をframe_buffer_swapの(r11, r12)に代入する
	push	{r0-r12, r14}
	@frame_bufferの(r1, r2)の値をr0にいれる
	bl	get_val
	@frame_buffer_swapの(r1, r2)にr0を書き込む
	mov	r1, r11
	mov	r2, r12
	bl	set_val_swap
	pop	{r0-r12, r15}


set_buffer:			@frame_buffer_swapの(r1, r2)をframe_bufferの(r1, r2)に代入する
	push	{r0-r12, r14}
	@frame_buffer_swapの(r1, r2)をr0にいれる
	bl	get_val_swap
	@frame_bufferの(r1, r2)にr0を書き込む
	bl	set_val
	pop	{r0-r12, r15}

get_val:				@frame_bufferの(x, y) = (r1, r2)の値をr0に入れて返す
	push	{r1-r12, r14}
	ldr	r0, =frame_buffer
	ldr	r6, =7
	ldr	r7, =1
	ldrb	r3, [r0, r2]		@r2行目
	sub	r5, r6, r1		@r5 = 7 - r1
	ldr	r0, =0
	@ands	r4, r3, #(1 << r1)	@左からr1ビット目と1のand
	ands	r4, r3, r7, lsl r1
	ldrne	r0, =1
	pop	{r1-r12, r15}

get_val_swap:				@frame_bufferの(x, y) = (r1, r2)の値をr0に入れて返す
	push	{r1-r12, r14}
	ldr	r0, =frame_buffer_swap
	ldr	r6, =7
	ldr	r7, =1
	ldrb	r3, [r0, r2]		@r2行目1バイト
	sub	r5, r6, r1		@r5 = 7 - r1
	ldr	r0, =0
	@ands	r4, r3, #(1 << r1)	@左からr1ビット目と1のand
	ands	r4, r3, r7, lsl r1
	ldrne	r0, =1
	pop	{r1-r12, r15}

set_val:				@frame_bufferの(x, y) = (r1, r2)にr0の値を書き込む
	push	{r0-r12, r14}
	ldr	r8, =frame_buffer
	ldr	r6, =7
	ldr	r7, =1
	ldrb	r3, [r8, r2]		@r2行目
	sub	r5, r6, r1		@r5 = 7 - r1
	@ldrb	r4, =(1 << r5)		@r1ビット目だけ1
	mov	r4, r7, lsl r5
	cmp	r0, #0
	bne	one			@1のときジャンプ
	@r0が0のとき
	ldrb	r6, =0xff
	eor	r4, r4, r6		@r1ビット目だけ0
	and	r3, r3, r4		@r1ビット目の位置を0にする
	b	write
one:	
	@r0が1のとき
	orr	r3, r3, r4		@r1ビット目の位置を0にする
write:	
	strb	r3, [r8, r2]		@変更した1バイトをr2行目に書き込み
	pop	{r0-r12, r15}

set_val_swap:				@frame_bufferの(x, y) = (r1, r2)にr0の値を書き込む
	push	{r0-r12, r14}
	ldr	r8, =frame_buffer_swap
	ldr	r6, =7
	ldr	r7, =1
	ldrb	r3, [r8, r2]		@r2行目
	sub	r5, r6, r1		@r5 = 7 - r1
	@ldrb	r4, =(1 << r5)		@r1ビット目だけ1
	mov	r4, r7, lsl r5
	cmp	r0, #0
	bne	one_swap			@1のときジャンプ
	@r0が0のとき
	ldrb	r6, =0xff
	eor	r4, r4, r6		@r1ビット目だけ0
	and	r3, r3, r4		@r1ビット目の位置を0にする
	b	write_swap
one_swap:	
	@r0が1のとき
	orr	r3, r3, r4		@r1ビット目の位置を0にする
write_swap:	
	strb	r3, [r8, r2]		@変更した1バイトをr2行目に書き込み
	pop	{r0-r12, r15}
	
	.section .data
	.global	MY_rotate_90_n
frame_buffer_swap:	.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
MY_rotate_90_n:	.word	0
