	@ r0にベースアドレス
	@ グローバル宣言したframe_buffer timer を使用
	@ 現在描画している行をメモリに保存
	@ displayサブルーチンが呼び出されたとき現在描画中の行をクリアして次の行を描画
	.include "common.h"
	.section .text
	.global display
display:
	push	{r0-r12, r14}

	ldr	r1, =draw_row
	ldrb	r2, [r1]

	@ 現在描画している行r1の削除
	
	@ 対応する行のメモリマップ
	ldr	r10, =row_buf
	mov	r9, #1
	ldrb	r3, [r10, r2]
	mov	r9, r9, lsl r3
	str	r9, [r0, #GPSET0]	@ 同時消灯

	bl	clear_col
	
	
	add	r2, r2, #1
	cmp	r2, #8
	moveq	r2, #0
	strb	r2, [r1]

	@ 次に描画する行r1の描画
	@ 対応する列のメモリマップ
	ldr	r10, =col_buf
	
	ldr	r6, =frame_buffer
	ldrb	r7, [r6, r2]
	@バッファデータの書き込み
	mov	r8, #7
	mov	r9, #1
1:
	tst	r7, r9, lsl r8
	ldrneb	r11, [r10]
	movne	r11, r9, lsl r11
	strne	r11, [r0, #GPSET0]
	add	r10, r10, #1
	subs	r8, r8, #1
	bge	1b

	ldr	r10, =row_buf
	ldrb	r3, [r10, r2]
	mov	r9, r9, lsl r3
	str	r9, [r0, #GPCLR0]
	
	pop	{r0-r12, r15}
	
	.global clear_col
	@ r0 はベースアドレス
clear_col:
	push	{r0-r12, r14}

	ldr	r10, =col_buf		@ r10 -> 番地
	
	mov	r8, #1		
	mov	r7, #8
	
1:
	ldrb	r9, [r10], #1		@ r9 -> 値
	mov	r6, r8, lsl r9
	str	r6, [r0, #GPCLR0]	@ 消灯指定
	subs	r7, r7, #1
	bne	1b

	pop	{r0-r12, r15}

	.global clear_row
clear_row:
	push	{r0-r12, r14}

	ldr	r10, =row_buf		@ r10 -> 番地
	
	mov	r8, #1		
	mov	r7, #8
1:
	ldrb	r9, [r10], #1		@ r9 -> 値
	mov	r6, r8, lsl r9
	str	r6, [r0, #GPSET0]	@ 消灯指定
	subs	r7, r7, #1
	bne	1b
	pop	{r0-r12, r15}

	.global	draw_init
draw_init:
	push	{r0-r12, r14}

	bl	clear_col
	bl	clear_row
	
	pop	{r0-r12, r15}
	
	.section .data
col_buf:
	.byte COL1_PORT, COL2_PORT, COL3_PORT, COL4_PORT, COL5_PORT, COL6_PORT, COL7_PORT, COL8_PORT
row_buf:
	.byte ROW1_PORT, ROW2_PORT, ROW3_PORT, ROW4_PORT, ROW5_PORT, ROW6_PORT, ROW7_PORT, ROW8_PORT

draw_row:
	.byte	0
