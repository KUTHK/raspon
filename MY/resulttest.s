	.include	"common.h"
	.section	.init
	.global		_start
_start:	
	bl	GPIO_init		@GPIO初期設定(spの設定も)
	bl	PWM_init		@PWM初期設定

	@bl	MY_show_result_init

	bl	HK_start_init
/*
	ldr	r0, =HK_winner
	ldr	r1, =1
	str	r1, [r0]
*/


loop0:	
	@bl	MY_show_result
	bl	HK_start
	bl	HK_display
endif:
	b	loop0

	.section .data
