common.h -- プログラム各所でよく使う定数を宣言したヘッダファイル
sound_source.h -- 純音の周波数を定義したヘッダファイル
GPIO_init.s -- スタックの初期設定とGPIOの初期設定を行うサブルーチン
PWM_init.s -- PWMのクロックソースの初期化と動作モードの初期設定を行うサブルーチン
MS_play_bgm.s -- bl MS_play_bgm で呼び出すサブルーチン，SEが鳴っていない間のみBGMを再生する
MS_play_SE.s -- bl MS_play_SE で呼び出すサブルーチン，SEを再生する
MS_bgm_list.s -- BGMを鳴らすための，データセクションを記述したファイル
MS_bgm_flashman.s -- BGMのデータ本体
MS_bgm_fox_20th.s -- BGMのデータ本体
MS_bgm_saria.s -- BGMのデータ本体
MS_SE.s -- SEを鳴らすための，データセクションを記述したファイル