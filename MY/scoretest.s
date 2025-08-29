	.include	"common.h"
	.section	.init
	.global		_start
_start:	
	bl	GPIO_init		@GPIO初期設定(spの設定も)
	bl	PWM_init		@PWM初期設定
/*
	@仮の点数
	ldr	r1, =HK_point1
	ldr	r2, =0
	str	r2, [r1]
	ldr	r1, =HK_point2
	ldr	r2, =0
	str	r2, [r1]
*/	
loop0:	
	bl	HK_display
	bl	MY_show_score
endif:
	b	loop0

	.section .data
	.global	main_status
main_status:	.word 0
