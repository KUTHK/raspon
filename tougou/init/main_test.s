/*--------------------------------------
main_test.s: メイン初期化・全体制御・タイマー設定

input: なし（システム初期化・全体制御）
output: 各種初期化・全体制御開始

_start: システム初期化・全体制御開始
--------------------------------------*/
	.include "common.h"
	.section .init
	.global _start
+_start:
	bl	GPIO_init
	bl  all_init
+	ldr	r0, =TIMER_BASE
	ldr	r1, [r0, #0x04]
	ldr	r2, =TS_player_board_target_time
	str	r1, [r2]
+
	bl	MS_set_bgm_target
loop:
	bl		check
	bl		HK_display

	b	loop
