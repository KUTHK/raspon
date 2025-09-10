# 主要シンボル / ラベル

Goal: 重要ラベルの意味と呼出側期待を明確化。

| ラベル | 位置 | 説明 | 呼出前提 |
|--------|------|------|----------|
| _start | init/main_test.s | エントリ | ポーリングループ開始 |
| loop (内部) | init/main_test.s | メインループ | ローカルラベル |

## 命名規約

- 動詞_目的語 形式を推奨 (例: update_ball)

## 自動生成ブロック

`make symbols` 実行で下記 AUTO セクションを更新。

<!-- AUTO-SYMBOLS:BEGIN -->
### 自動抽出シンボル一覧

| モジュール | ファイル | シンボル | 備考 |
|-----------|---------|---------|------|
| display | display/display.s | HK_display |  |
| display | display/display.s | HK_fb_clear |  |
| display | display/display.s | frame_buffer |  |
| display | display/player_board_draw.s | TS_player1_board_draw |  |
| display | display/player_board_draw.s | TS_player2_board_draw |  |
| display | display/result.s | MY_show_result |  |
| display | display/result.s | MY_show_result_init |  |
| display | display/rotate.s | MY_rotate_90 |  |
| display | display/rotate.s | MY_rotate_90_n |  |
| display | display/rotate.s | MY_x_rotate_buffer |  |
| display | display/rotate.s | MY_y_rotate_buffer |  |
| display | display/start.s | HK_start |  |
| display | display/start.s | HK_start_init |  |
| display | display/text.s | HK_read_text |  |
| display | display/text.s | HK_reset_text_position |  |
| display | display/text.s | HK_slide_text |  |
| display | display/text.s | HK_slide_text_rotate |  |
| display | display/text.s | HK_text |  |
| display | display/text.s | HK_text_delay |  |
| display | display/text.s | HK_text_start_time |  |
| display | display/text.s | HK_update_text_address |  |
| display | display/text.s | HK_write_text |  |
| display | display/write_number.s | HK_write_number |  |
| display | display/write_number.s | HK_write_number_in |  |
| display | display/write_number.s | HK_write_numbers |  |
| game | game/GoalJudg.s | OS_goalJudg |  |
| game | game/GoalJudg.s | OS_goalJudg_out |  |
| game | game/ball.s | KT_ball_init |  |
| game | game/ball.s | KT_ball_init_player1 |  |
| game | game/ball.s | KT_ball_init_player2 |  |
| game | game/ball.s | KT_ball_move |  |
| game | game/ball.s | KT_ball_player1_pushed |  |
| game | game/ball.s | KT_ball_player2_pushed |  |
| game | game/ball.s | KT_ball_pos_x |  |
| game | game/ball.s | KT_ball_pos_y |  |
| game | game/ball.s | KT_collision |  |
| game | game/player_board.s | TS_player1_board |  |
| game | game/player_board.s | TS_player1_mov |  |
| game | game/player_board.s | TS_player1_push_time |  |
| game | game/player_board.s | TS_player2_board |  |
| game | game/player_board.s | TS_player2_mov |  |
| game | game/player_board.s | TS_player2_push_time |  |
| game | game/player_board.s | TS_player_board |  |
| game | game/player_board.s | TS_player_board_init |  |
| game | game/player_board.s | TS_player_board_target_time |  |
| game | game/point.s | HK_add_point1 |  |
| game | game/point.s | HK_add_point2 |  |
| game | game/point.s | HK_point1 |  |
| game | game/point.s | HK_point2 |  |
| game | game/point.s | HK_reset_point |  |
| game | game/point.s | HK_win_point |  |
| game | game/point.s | HK_winner |  |
| game | game/score.s | MY_buffer_ischanged_init |  |
| game | game/score.s | MY_show_score |  |
| init | init/GPIO_init.s | GPIO_init |  |
| init | init/PWM_init.s | PWM_init |  |
| init | init/main_test.s | _start | エントリーポイント |
| input | input/switch.s | TS_cool_time |  |
| input | input/switch.s | TS_switch |  |
| input | input/switch.s | TS_switch_init |  |
| input | input/switch.s | TS_switch_out |  |
| input | input/switch.s | TS_switch_save |  |
| sound | sound/bgm/MS_bgm_flashman.s | MS_flashman |  |
| sound | sound/bgm/MS_bgm_flashman.s | MS_flashman_len |  |
| sound | sound/bgm/MS_bgm_fox_20th.s | MS_fox_20th |  |
| sound | sound/bgm/MS_bgm_fox_20th.s | MS_fox_20th_len |  |
| sound | sound/bgm/MS_bgm_list.s | MS_bgm_len_list |  |
| sound | sound/bgm/MS_bgm_list.s | MS_bgm_list |  |
| sound | sound/bgm/MS_bgm_saria.s | MS_saria |  |
| sound | sound/bgm/MS_bgm_saria.s | MS_saria_len |  |
| sound | sound/bgm/MS_bgm_title.s | MS_title |  |
| sound | sound/bgm/MS_bgm_title.s | MS_title_len |  |
| sound | sound/se/MS_SE.s | MS_SE |  |
| sound | sound/se/MS_SE.s | MS_SE_len |  |
| sound | sound/se/MS_play_SE.s | MS_SE_status |  |
| sound | sound/se/MS_play_SE.s | MS_play_SE |  |
| sound | sound/se/MS_play_SE.s | MS_play_SE_init |  |
| sound | sound/se/MS_play_bgm.s | MS_bgm_offset |  |
| sound | sound/se/MS_play_bgm.s | MS_play_bgm |  |
| sound | sound/se/MS_play_bgm.s | MS_play_bgm_init |  |
| sound | sound/se/MS_play_bgm.s | MS_play_bgm_target_time |  |
| sound | sound/se/MS_play_bgm.s | MS_set_bgm_target |  |
| sound | sound/se/MS_play_bgm.s | MS_shadow_target_time_update |  |
| sound | sound/se/MS_sound_effect.s | MS_sound_effect |  |

<!-- AUTO-SYMBOLS:END -->
