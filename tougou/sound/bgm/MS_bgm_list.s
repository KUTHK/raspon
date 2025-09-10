/*--------------------------------------
MS_bgm_list.s: BGMデータのアドレス・長さリスト

input: 各BGMデータ
output: MS_bgm_list, MS_bgm_len_list（BGMアドレス・長さリスト）

各BGMデータのアドレスと長さを管理
--------------------------------------*/
	.section .data
	.global  MS_bgm_list
MS_bgm_list:
	.word	MS_title, MS_fox_20th, MS_flashman, MS_saria

	.global	 MS_bgm_len_list
MS_bgm_len_list:
	.word	MS_title_len, MS_fox_20th_len, MS_flashman_len, MS_saria_len
