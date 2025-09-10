/*-----------------------------------------------------------------
input: frame_buffer
return:ない！！
HK_display: 8ms 周期で matrixLED を光らせる
HK_fb_clear: frame_buffer を全て 0 にする
---------------------------------------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		HK_display, HK_fb_clear

	.equ	MSEC8, 8*1000

@ 1ms 毎に matrixLED 一行表示
HK_display:
	push	{r0-r12, r14}

	ldr	r4, =TIMER_BASE
	ldr	r3, [r4, #CLO]		@カウンタレジスタの値取り出す。現在時刻を取り出している。

	ldr	r8, =display_timer
	ldr	r11, =MSEC8	@ 8msec

	ldr	r1, =0
	display_loop:
		ldr	r9, [r8]
		cmp	r3, r9		@ 現在時刻 < 目標時刻
		bls	display_skip
			bl	print_line	@ r1 行目表示
			add	r9, r9, r11	@ 1周期分加算
			str	r9, [r8]
		display_skip:
		add	r8, r8, #4	@ 配列移動
		add	r1, r1, #1	@ カウント
		cmp	r1, #8
	bne	display_loop

	pop	{r0-r12, r15}

HK_fb_clear:
	push	{r0-r12, r14}

	ldr	r0, =0
	ldr	r1, =frame_buffer
	str	r0, [r1], #4
	str	r0, [r1], #4

	pop	{r0-r12, r15}


@ r1  行目を表示
print_line:
	push	{r1-r12, r14}
	ldr		r0, =GPIO_BASE
	bl 		all_clear			@すべてのマスを(1,0)に初期化

	ldr		r10, =8				@8回ループ
	ldr		r2, =frame_buffer
	ldrb	r3, [r2, r1]		@frame_bufferのデータとりだす(8bit)
	ldr		r4, =1				@
	ldr		r5, =col			@r5にcol配列の先頭アドレス代入.colは列
	ldr		r9, =0

dot:
	ldrb	r6, [r5], #1				@r6にcol配列のデータ先頭から順に読み込む。
	tst		r3, #1				@r3には一行分光らせる8ビット列が入っており、それの最下位ビットが0か1か見るためにr3と1のand演算を行う。
							@そしてand演算の結果が1のときに限り下のorrneを行う
							@r3の最下位ビットそのものが列のポートに0をいれるか1をいれるか決めている
	orrne	r9, r9, r4, lsl	r6	@r9 = orr r9, #(1 << r6) ここでr9(32bit)に対してどの列のポートに1を入れるか確定させていく
	lsr		r3, r3, #1			@r3を右シフトしてr3の次の最下位ビットを見れるようにする。

	subs	r10, r10, #1			
	bne		dot				@8回ループおわったら、r2をいれる。r2にはどのポートを1にするかを決める二進数列が入っている
	str		r9, [r0, #GPSET0]		@r2をGPSET0レジスタへ書きこむ。ここで上のorr演算を行った各列のポートには1が出力される

@ r1 row 光らせる
	ldr		r5, =row			@rowは行.r5
	ldrb	r6, [r5, r1]				@r6にrow配列のデータを代入してr1ずらして次のデータ参照
	mov		r8, r4, lsl r6			@r4の値をr6bit左シフト(1 << r6).行のポートを選択
	str		r8, [r0, #GPCLR0]		@選択した行のポートの出力は0になった。ここまでやって一行目が光る。

	pop		{r1-r12, r15}

// matrixLED の全消し
all_clear:
	push	{r0-r12, r14}
	ldr	r0, =GPIO_BASE

	@ 全列消灯
	mov	r1, #(1 << COL1_PORT)
	orr	r1, r1, #(1 << COL2_PORT)
	orr	r1, r1, #(1 << COL3_PORT)
	orr	r1, r1, #(1 << COL4_PORT)
	orr	r1, r1, #(1 << COL5_PORT)
	orr	r1, r1, #(1 << COL6_PORT)
	orr	r1, r1, #(1 << COL7_PORT)
	orr	r1, r1, #(1 << COL8_PORT)
	str	r1, [r0, #GPCLR0]

	@ 全行消灯
	mov	r1, #(1 << ROW1_PORT)
	orr	r1, r1, #(1 << ROW2_PORT)
	orr	r1, r1, #(1 << ROW3_PORT)
	orr	r1, r1, #(1 << ROW4_PORT)
	orr	r1, r1, #(1 << ROW5_PORT)
	orr	r1, r1, #(1 << ROW6_PORT)
	orr	r1, r1, #(1 << ROW7_PORT)
	orr	r1, r1, #(1 << ROW8_PORT)
	str	r1, [r0, #GPSET0]

	pop	{r0-r12, r15}


	.section	.data
col:	.byte	 COL8_PORT, COL7_PORT, COL6_PORT, COL5_PORT, COL4_PORT, COL3_PORT, COL2_PORT, COL1_PORT
row:	.byte	 ROW1_PORT, ROW2_PORT, ROW3_PORT, ROW4_PORT, ROW5_PORT, ROW6_PORT, ROW7_PORT, ROW8_PORT
display_timer:	.word	0, 1*1000, 2*1000, 3*1000, 4*1000, 5*1000, 6*1000, 7*1000

/*-----------------------------------------------------------------
frame_bufferの定義
---------------------------------------------------------------------*/
  .global frame_buffer
frame_buffer:
	.byte	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0

