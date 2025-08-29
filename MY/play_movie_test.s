	.include	"common.h"
	.section	.init
	.global		_start
_start:	
	bl	GPIO_init		@GPIO初期設定(spの設定も)
	bl	PWM_init		@PWM初期設定

loop0:	
	bl	MY_play_movie
	bl	HK_display
	b	loop0

	.section .data
