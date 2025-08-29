	/*---------------------------------------
MY_play_movie:
	MY_frame_buffer配列に書き込まれている各データをMY_show_timeの長さごとにframe_bufferに書き込む
	MY_show_timeの終端に0を追加することで動画の終端とする.
	---------------------------------------------*/

	.include	"common.h"
	.section	.text
	.global		MY_play_movie
MY_play_movie:
	push	{r0-r12, r14}
	
	@ タスク実行の判定, (目標時刻 <= 現在時刻 で実行)
	ldr	r0, =TIMER_BASE
	ldr	r2, [r0, #0x04]	@ 現在時刻取得

	ldr	r0, =target_time

	ldr	r1, [r0]	@ 目標時刻
	cmp	r1, r2		@r1 > r2現在カウンタと比較
	bgt	endif
	bl	task_target_time_update		@目標更新
	bl	next_buffer			@buffer切り替え
	bl	add_offset			@offset++
endif:	
	pop	{r0-r12, r15}
next_buffer:					@result画面のframe_bufferの切り替え
	push	{r0-r12, r14}

	ldr	r0, =frame_buffer		@frame_bufferをロード
	ldr	r1, =MY_movie_buffer		@frame_bufferの配列をロード前半4バイト

write_buffer:
	ldr	r6, =offset
	ldr	r5, [r6]
	mov	r5, r5, lsl #3			@frame_bufferが8バイトだからoffset8倍
						@なんでうごかないかTAにきく
	ldr	r4, [r1, r5]			@r1に入れてる表示させるデータをロード, offsetに応じる(配列データはbyte)
	str	r4, [r0]			@はじめ4バイト分frame_bufferに書き込む(8バイトなんで2かいに分けるよ)
	add	r5, r5, #4			@表示させる配列のアドレスを4バイトずらす
	ldr	r4, [r1, r5]			@下位4バイト分の値を読み込む
	str	r4, [r0, #4]			@4バイトずらしたとこに書き込む

	pop	{r0-r12, r15}

task_target_time_update:
	push	{r0-r12, r14}

	ldr	r3, =offset
	ldr	r5, [r3]			@offset
	mov	r5, r5, lsl #2			@wordに変換
	ldr	r0, =MY_show_time
	ldr	r2, [r0, r5]			@表示の長さ取得(offsetの値に応じる)
	ldr	r4, =target_time
	ldr	r6, [r4]			@現在の更新目標
	add	r6, r6, r2			@r6 = r6 + r2
	str	r6, [r4]			@新しいtarget_time書き込み

	pop	{r0-r12, r15}
add_offset:
	push	{r0-r12, r14}

	ldr	r0, =offset			@
	ldr	r1, [r0]			@r1にoffsetの値
	add	r1, r1, #1			@r1 = r1 + 1
	mov	r10, r1				@r10にbyteのままコピー
	@配列サイズを超えないようにする.終端かどうかチェック
	ldr	r3, =MY_show_time
	mov	r1, r1, lsl #2			@offsetをwordに変換
	ldr	r2, [r3, r1]
	cmp	r2, #0				@MY_show_time[offset] != 0 終端ではないとき
	bne	write
	ldr	r10, =0				@offset0に戻す
write:	
	str	r10, [r0]

	pop	{r0-r12, r15}

	.section .data
	.global MY_show_time, MY_movie_buffer
	.equ	SWITCH_TIME, 100000 	  @
MY_show_time:				@各frame_bufferの表示させる時間
	.word	SWITCH_TIME, SWITCH_TIME, SWITCH_TIME, SWITCH_TIME
	.word	SWITCH_TIME, SWITCH_TIME, 0
target_time:
	.word	0
offset:					@今どこを見てるか
	.word	0
MY_movie_buffer:
	.byte	0x00, 0x00, 0x24, 0x66, 0x00, 0x42, 0x3c, 0x00
	.byte	0x00, 0x24, 0x24, 0x24, 0x00, 0x42, 0x3c, 0x00
	.byte	0x00, 0x24, 0x24, 0x24, 0x00, 0x42, 0x3c, 0x00
	.byte	0x00, 0x24, 0x24, 0x24, 0x00, 0x42, 0x3c, 0x00
	.byte	0x00, 0x24, 0x24, 0x24, 0x00, 0x42, 0x3c, 0x00
	.byte	0x00, 0x24, 0x24, 0x24, 0x00, 0x42, 0x3c, 0x00
/*
MY_movie_buffer:
	.byte	0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00
	.byte	0x00, 0x00, 0x3c, 0x24, 0x24, 0x3c, 0x00, 0x00
	.byte	0x00, 0x7e, 0x42, 0x42, 0x42, 0x42, 0x7e, 0x00
	.byte	0xff, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0xff
	.byte	0x00, 0x7e, 0x42, 0x42, 0x42, 0x42, 0x7e, 0x00
	.byte	0x00, 0x00, 0x3c, 0x24, 0x24, 0x3c, 0x00, 0x00
*/
