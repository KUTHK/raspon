/*-----------------------------
input: HK_write_number_in に表示したい値
HK_write_number: input の 1 桁目まで frame_buffer に書き込み
HK_write_numbers: input の 2 桁目まで frame_buffer に書き込み
----------------------------------*/


	.include	"common.h"
	.section	.text
	.global		HK_write_number, HK_write_numbers


@ HK_write_number_in の 1 桁目までの値を frame_buffer に書き込む
HK_write_number:
	push	{r0-r12, r14}
	bl	clean

	ldr	r1, =HK_write_number_in
	ldr	r1, [r1]
	ldr	r2, =10
	bl	mod

	bl	number
	bl	write
	
	pop	{r0-r12, r15}

@ HK_write_number_in の 2 桁目までの値を frame_buffer に書き込む
HK_write_numbers:
	push	{r0-r12, r14}
	bl	clean

	ldr	r1, =HK_write_number_in
	ldr	r1, [r1]

	mov	r7, r1
	ldr	r2, =10
	udiv	r1, r1, r2
	bl	mod


	bl	number
	bl	write

	mov	r1, r7
	ldr	r2, =10
	bl	mod

	bl	number
	bl	write
	
	pop	{r0-r12, r15}

@ r1 % r2 = ? ... return r1
mod:
	push	{r2-r12, r14}
	
	udiv	r3, r1, r2
	mul	r4, r2, r3
	sub	r1, r1, r4
	
	pop	{r2-r12, r15}


@ r1 に入っている数字 (0-9) に対応したマトリックス LED の配列を r3 にロードする
number:
	push	{r1-r2, r14}

	ldr	r3, =zero
	cmp	r1, #0
	ldreq	r3, =zero
	cmp	r1, #1
	ldreq	r3, =one
	cmp	r1, #2
	ldreq	r3, =two
	cmp	r1, #3
	ldreq	r3, =three
	cmp	r1, #4
	ldreq	r3, =four
	cmp	r1, #5
	ldreq	r3, =five
	cmp	r1, #6
	ldreq	r3, =six
	cmp	r1, #7
	ldreq	r3, =seven
	cmp	r1, #8
	ldreq	r3, =eight
	cmp	r1, #9
	ldreq	r3, =nine

	pop	{r1-r2, r15}

@ r5 レジスタを使って r2 (frame_buffer) の中身をすべて 0 にする
clean:
	push	{r1-r5, r14}
	ldr	r2, =frame_buffer
	ldr	r4, =8
	clean0:
		ldr	r5, =0
		strb	r5, [r2], #1
		subs	r4, r4, #1
		bne	clean0
	pop	{r1-r5, r15}

@ r3 に入っているマトリックス LED の数字の配列データを frame_buffer に書き込む
write:
	push	{r1-r12, r14}
	ldr	r2, =frame_buffer
	ldr	r4, =8
	write0:
		ldrb	r5, [r3], #1
		ldrb	r6, [r2]
		orr	r5, r5, r6, lsl #4
		strb	r5, [r2], #1
		subs	r4, r4, #1
		bne	write0
	pop	{r1-r12, r15}


@ 数値のマトリックス LED のデータ定義
	.section	.data
zero:	.byte	0x0, 0xe, 0xa, 0xa, 0xa, 0xe, 0x0, 0x0
one:	.byte	0x0, 0x4, 0xc, 0x4, 0x4, 0xe, 0x0, 0x0
two:	.byte	0x0, 0xe, 0x2, 0xe, 0x8, 0xe, 0x0, 0x0
three:	.byte	0x0, 0xe, 0x2, 0xe, 0x2, 0xe, 0x0, 0x0
four:	.byte	0x0, 0xa, 0xa, 0xe, 0x2, 0x2, 0x0, 0x0
five:	.byte	0x0, 0xe, 0x8, 0xe, 0x2, 0xe, 0x0, 0x0
six:	.byte	0x0, 0xe, 0x8, 0xe, 0xa, 0xe, 0x0, 0x0
seven:	.byte	0x0, 0xe, 0xa, 0x2, 0x2, 0x2, 0x0, 0x0
eight:	.byte	0x0, 0xe, 0xa, 0xe, 0xa, 0xe, 0x0, 0x0
nine:	.byte	0x0, 0xe, 0xa, 0xe, 0x2, 0xe, 0x0, 0x0

	.global HK_write_number_in
HK_write_number_in: .word	0

