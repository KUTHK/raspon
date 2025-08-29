	.equ	PWM_HZ, 9600*1000
	.equ	TIMER_HZ, 1000 * 1000
	.equ	BPM, 180	@ bmp=60, quarter -> 1sec, half -> 2sec
	.equ	whole,	(240*TIMER_HZ)/BPM	@ (60*TIMER_HZ)/(BPM/4)
	.equ	two_whole, whole*2
	.equ	half,	(120*TIMER_HZ)/BPM
	.equ	half_dot,	half + (half/2)
	.equ	quarter,	(60*TIMER_HZ)/BPM
	.equ	quarter_dot,	quarter + (quarter/2)
	.equ	eighth,		(30*TIMER_HZ)/BPM
	.equ	eighth_dot,	eighth + (eighth/2)
	.equ	sixteenth,	(15*TIMER_HZ)/BPM
	.include "sound_source.h"
	
	.section .data
	
	.global MS_fox_20th
MS_fox_20th:
	.word	F5, 0, F5, F5, F5, 0, Fs5, F5, Fs5, F5, Fs5
	.word	F5, 0, F5, F5, F5, F5, F5, F5, F5, F5, D5, Ds5
	.word	F5, 0, F5, F5, F5, 0
	.word	As4, D5, F5, G5, 0, C5, Ds5, G5, As5, 0
	.word	C5, Ds5, Fs5, As5, 0

	.global	MS_fox_20th_len
MS_fox_20th_len:
	.word	eighth, eighth, sixteenth, sixteenth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth
	.word	eighth, eighth, sixteenth, sixteenth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	eighth, eighth, sixteenth, sixteenth, half, quarter
	.word	eighth, eighth, eighth, half_dot, quarter_dot, eighth, eighth, eighth, half_dot, eighth_dot
	.word	eighth_dot, eighth_dot, eighth_dot, two_whole, whole
	.word	0xffffffff
