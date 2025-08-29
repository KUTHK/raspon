 /*ゴール判定をする関数。戻り値はOS_goalJudg_out。ゴールしてるとき1,ゴールしてないとき0
  */
 
    .include "common.h"
	.section .init
	.global OS_goalJudg

    @.equ    OS_goalJudg_out, 0                  @戻り値の変数宣言
OS_goalJudg:
    push	{r1-r12, r14}@  r1-r12はレジスタの避難。r14はこの関数を呼び出した場所を保存するレジスタ
    /*c言語の翻訳

    ボールのy座標取得;
    if(ボールが0行目に来た){
        return true;
        }else if(ボールが7行目に来た){
           return true; 
            }
    */
    mov r3, #1      @OS_goalJudg_outに１を代入する用のレジスタ

    ldr r1, =KT_ball_pos_y  @ボールの座標を取得(y座標のみ)
    ldr r1, [r1]            @r1にボールのy座標が入った。
    cmp r1, #0              @0行目に来たか判断
    bne elseif                 @来てないなら次の判断へ行く
    ldr r0 , =OS_goalJudg_out   @グローバル変数のアドレス取得
    mov r3, #1      @OS_goalJudg_outに１を代入する用のレジスタ
    str r3, [r0]                @1を書き込み、OS_goalJudg_outをtrueに変える。
    b end                       @elseifの部分は処理したくないため、trueに変えたらそのまま終わる
elseif:
    cmp r1, #7                  @7行目に来たか判断
    bne end                     @来てないならそのまま終わる
    ldr r0, =OS_goalJudg_out    @グローバル変数のアドレス取得
    mov r3, #2      @OS_goalJudg_outに１を代入する用のレジスタ
    str r3, [r0]                @1を書き込み、OS_goalJudg_outをtrueに変える。

end:
    pop		{r1-r12, r15}

    .section .data@書き換え可能
    .global OS_goalJudg_out
OS_goalJudg_out: 
    .word 0    @0でfalse,1でtrue






    








