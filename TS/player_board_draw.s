	@ player1とplayer2をディスプレイ上に描画するためのファイル
	@ TS_player1_boardとTS_player2_boardをframe_bufferに書き込む
	@ player_boardの中で呼び出す
	.include "common.h"
	.section .text
	.global TS_player1_board_draw, TS_player2_board_draw
TS_player1_board_draw:
	push	{r0-r12, r14}

    ldr     r0,=frame_buffer
	mov		r1,#0
	strb	r1,[r0]
	ldr     r2,=TS_player1_board
    ldr     r2,[r2]
	
	mov     r1,#7
	lsl		r1,r1,r2
	lsr		r1,r1,#1
    strb    r1,[r0]

	pop	    {r0-r12, r15}
TS_player2_board_draw:
    push	{r0-r12, r14}

    ldr     r0,=frame_buffer
	mov		r1,#0
	strb	r1,[r0,#7]
    ldr     r2,=TS_player2_board
    ldr     r2,[r2]
	
	mov     r1,#7
	lsl		r1,r1,r2
	lsr		r1,r1,#1
	strb    r1,[r0,#7]

	pop	    {r0-r12, r15}
