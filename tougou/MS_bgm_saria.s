	.equ	PWM_HZ, 9600*1000
	.equ	TIMER_HZ, 1000 * 1000
	.equ	BPM, 140	@ bmp=60, quarter -> 1sec, half -> 2sec
	.equ	whole,	(240*TIMER_HZ)/BPM	@ (60*TIMER_HZ)/(BPM/4)
	.equ	half,	(120*TIMER_HZ)/BPM
	.equ	half_dot,	half + (half/2)
	.equ	quarter,	(60*TIMER_HZ)/BPM
	.equ	quarter_dot,	quarter + (quarter/2)
	.equ	eighth,		(30*TIMER_HZ)/BPM
	.equ	eighth_dot,	eighth + (eighth/2)
	.equ	sixteenth,	(15*TIMER_HZ)/BPM
	.include "sound_source.h"
	
	.section .data
	
	.global MS_saria
	
MS_saria:
	.word	F5, A5, B5, F5, A5, B5
	.word	F5, A5, B5, E6, D6, B5, C6
	.word	B5, G5, E5, 0, D5
	.word	E5, G5, E5, 0

	.word	F5, A5, B5, F5, A5, B5
	.word	F5, A5, B5, E6, D6, B5, C6
	.word	E6, B5, E6, 0, B6
	.word	G5, D5, E5, 0

	.word	D5, E5, F5, G5, A5, B5
	.word	C6, B5, E5, 0
	.word	D5, E5, F5, G5, A5, B5
	.word	C6, D6, E6, 0

	.word	D5, E5, F5, G5, A5, B5
	.word	C6, B5, E5, 0
	.word	D5, C5, F5, E5, G5, F5, A5, G5
	.word	B5, A5, C6, B5, D6, C6, E6, F6, D6
	.word	E6, E6, 0
	
	.word	0, 0, E6

	.global	MS_saria_len
MS_saria_len:	
	.word	eighth, eighth, quarter, eighth, eighth, quarter
	.word	eighth, eighth, eighth, eighth, quarter, eighth, eighth
	.word	eighth, eighth, half, eighth, eighth
	.word	eighth, eighth, half, quarter

	.word	eighth, eighth, quarter, eighth, eighth, quarter
	.word	eighth, eighth, eighth, eighth, quarter, eighth, eighth
	.word	eighth, eighth, half, eighth, eighth
	.word	eighth, eighth, half, quarter

	.word	eighth, eighth, quarter, eighth, eighth, quarter
	.word	eighth, eighth, half, quarter
	.word	eighth, eighth, quarter, eighth, eighth, quarter
	.word	eighth, eighth, half, quarter

	.word	eighth, eighth, quarter, eighth, eighth, quarter
	.word	eighth, eighth, half, quarter
	.word	eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	eighth, eighth, eighth, eighth, eighth, eighth, sixteenth, eighth, sixteenth
	.word	half, quarter, quarter
	.word	half, quarter, quarter
	.word	0xffffffff	@ 楽譜の終了場所

