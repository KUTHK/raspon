製作者 松本
common.h -- プログラム各所でよく使う定数を宣言したヘッダファイル
sound_source.h -- 純音の周波数を定義したヘッダファイル
GPIO_init.s -- スタックの初期設定とGPIOの初期設定を行うサブルーチン
PWM_init.s -- PWMのクロックソースの初期化と動作モードの初期設定を行うサブルーチン
MS_play_bgm.s -- bl MS_play_bgm で呼び出すサブルーチン，SEが鳴っていない間のみBGMを再生する
MS_play_SE.s -- bl MS_play_SE で呼び出すサブルーチン，SEを再生する
MS_bgm_list.s -- BGMを鳴らすための，データセクションを記述したファイル
MS_bgm_flashman.s -- BGMのデータ本体
MS_bgm_fox_20th.s -- BGMのデータ本体
MS_bgm_title.s -- BGMのデータ本体
MS_bgm_saria.s -- BGMのデータ本体
MS_SE.s -- SEを鳴らすための，データセクションを記述したファイル

製作者 久保田
ball.s -- ボールに関係する処理全般を扱うプログラム

製作者 寺内
switch.s -- スイッチが押されているかを返すプログラムTS_switch_outに下位bitから順にボタンの押下情報を保持
player_board.s -- 2人のプレイヤーのボードを動かすサブルーチン,スイッチが押されていればボードの中心座標が左右に動く
player_board_draw.s -- player1とplayer2をディスプレイ上に描画するためのファイル

作成者 林
display.s -- frame_buffer を一定周期でマトリックス LED に表示する処理
point.s -- 得点を保持、加算、リセットを行う処理
start.s -- start 画面の制御
text.s -- マトリックス LED に表示する文字列の制御
write_number.s -- frame_buffer に数値配列を書き込む処理

作成者 奥平
GoalJuge.s -- ボールの座標から得点判定を行うプログラム

作成者 森岡
result.s -- リザルト画面のframe_bufferを生成するサブルーチン
rotate.s -- frame_buffer全体を回転させるサブルーチン
score.s -- 現在の得点をframe_bufferに書き込むサブルーチン
play_movie.s -- frame_buffer配列の値を順番にアニメーションみたいに書き込むサブルーチン