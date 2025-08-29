	.include "common.h"
	.include "sound_source.h"
	.section .data
	.global MS_SE
MS_SE:
	.word	wall, board

wall:
	.word	A5

board:
	.word	B5

	.global	MS_SE_len
MS_SE_len:
	.word	wall_len, board_len

wall_len:
	.word	100 * 1000
	
board_len:
	.word	100 * 1000
