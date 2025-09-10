/*--------------------------------------
MS_bgm_title.s: タイトルBGMのデータ・テンポ・音長定義

input: なし（BGMデータ定義）
output: MS_title（BGMデータ配列）

PWM_HZ, TIMER_HZ, BPM, 各音長(whole, half, quarter, etc)を定義
--------------------------------------*/
	.equ	PWM_HZ, 9600*1000
	.equ	TIMER_HZ, 1000 * 1000
	.equ	BPM, 120	@ bmp=60, quarter -> 1sec, half -> 2sec
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
	
	.global MS_title
MS_title:
	.word	G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4, G4, 0, G4, 0, D4, F4
	
	.global	MS_title_len
MS_title_len:
	.word	eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter, eighth, quarter, eighth, eighth, eighth, quarter
	.word	0xffffffff
