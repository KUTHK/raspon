/*--------------------------------------
MS_bgm_flashman.s: フラッシュマンBGMのデータ・テンポ・音長定義

input: なし（BGMデータ定義）
output: MS_flashman（BGMデータ配列）

PWM_HZ, TIMER_HZ, BPM, 各音長(whole, half, quarter, etc)を定義
--------------------------------------*/
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
	
	.global MS_flashman
MS_flashman:
	.word	E4, G4, B4, D5, Cs5, A4, C5, B4, G4, A4, G4, E4, D4, E4
	.word	Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, B4, 0,  B4, A4, 0, G4, 0, Fs4
	.word	E4, G4, B4, D5, Cs5, A4, C5, B4, G4, A4, G4, E4, D4, E4
	.word	Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, B4, 0,  B4, A4, 0, G4, 0, Fs4
	.word	E4, G4, B4, D5, Cs5, A4, C5, B4, G4, A4, G4, E4, D4, E4
	.word	Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, B4, 0,  B4, A4, 0, G4, 0, Fs4
	.word	E4, G4, B4, D5, Cs5, A4, C5, B4, G4, A4, G4, E4, D4, E4
	.word	Fs4, Fs4, Fs4, G4, 0, Fs4, Fs4, Fs4, G4, 0, A4, A4, 0, A4, 0, A4, 0, A4, B4, 0
	
	.word	E4, B4, A4, B4, A4, G4, A4, B4, 0, E4, 0
	.word	E4, G4, Fs4, 0, Fs4, 0, Fs4, E4, D4, E4, 0, E4, G4, A4, 0
	.word	E4, B4, A4, B4, A4, G4, A4, B4, 0, E4, 0
	.word	E4, G4, Fs4, 0, Fs4, 0, G4, A4, Fs4, E4, 0, E4, G4, B4

	.word	D5, Cs5, C5, G4, E4, 0, E4, G4, A4, As4, B4, As4, B4, A4, G4, E4, D4
	.word	D5, Cs5, C5, G4, E4, 0, E4, G4, A4, E5, B4, B4, B4, Ds5, Fs5, A5, B5, 0

	.word	E4, B4, A4, B4, A4, G4, A4, B4, 0, E4, 0
	.word	E4, G4, Fs4, 0, Fs4, 0, Fs4, E4, D4, E4, 0, E4, G4, A4, 0
	.word	E4, B4, A4, B4, A4, G4, A4, B4, 0, E4, 0
	.word	E4, G4, Fs4, 0, Fs4, 0, G4, A4, Fs4, E4, 0, E4, G4, B4

	.word	D5, Cs5, C5, G4, E4, 0, E4, G4, A4, As4, B4, As4, B4, A4, G4, E4, D4
	.word	D5, Cs5, C5, G4, E4, 0, E4, G4, A4, As4, B4, As4, B4, A4, G4, E4, D4
	.word	D5, Cs5, C5, G4, E4, 0, E4, G4, A4, E5, B4, B4, B4, Ds5, Fs5, A5, B5

	

	.global	MS_flashman_len
MS_flashman_len:	
	.word	quarter, eighth, eighth, eighth_dot, eighth_dot, eighth, eighth_dot, eighth_dot, eighth, eighth, eighth, sixteenth, eighth, eighth_dot
	.word	sixteenth, sixteenth, sixteenth, sixteenth, eighth, sixteenth, sixteenth, sixteenth, sixteenth, quarter_dot, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, eighth
	.word	quarter, eighth, eighth, eighth_dot, eighth_dot, eighth, eighth_dot, eighth_dot, eighth, eighth, eighth, sixteenth, eighth, eighth_dot
	.word	sixteenth, sixteenth, sixteenth, sixteenth, eighth, sixteenth, sixteenth, sixteenth, sixteenth, quarter_dot, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, eighth
	.word	quarter, eighth, eighth, eighth_dot, eighth_dot, eighth, eighth_dot, eighth_dot, eighth, eighth, eighth, sixteenth, eighth, eighth_dot
	.word	sixteenth, sixteenth, sixteenth, sixteenth, eighth, sixteenth, sixteenth, sixteenth, sixteenth, quarter_dot, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, eighth
	.word	quarter, eighth, eighth, eighth_dot, eighth_dot, eighth, eighth_dot, eighth_dot, eighth, eighth, eighth, sixteenth, eighth, eighth_dot
	.word	sixteenth, sixteenth, sixteenth, sixteenth, eighth, sixteenth, sixteenth, sixteenth, sixteenth, quarter, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, sixteenth, half, eighth

	.word	eighth, eighth, eighth, quarter, eighth, eighth, eighth, eighth, eighth, quarter, eighth
	.word	eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, half_dot, eighth, eighth, eighth, eighth, eighth
	.word	eighth, eighth, eighth, quarter, eighth, eighth, eighth, eighth, eighth, quarter, eighth
	.word	eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, half_dot, eighth, eighth, eighth, eighth

	.word	whole, half, half, eighth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	whole, half, half, eighth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth

	.word	eighth, eighth, eighth, quarter, eighth, eighth, eighth, eighth, eighth, quarter, eighth
	.word	eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, half_dot, eighth, eighth, eighth, eighth, eighth
	.word	eighth, eighth, eighth, quarter, eighth, eighth, eighth, eighth, eighth, quarter, eighth
	.word	eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, half_dot, eighth, eighth, eighth, eighth

	.word	whole, half, half, eighth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	whole, half, half, eighth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	whole, half, half, eighth, quarter_dot, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth, eighth
	.word	0xffffffff
