	.include	"common.h"
	.section	.init
	.global		_start
_start:	
	bl	GPIO_init		@GPIO初期設定(spの設定も)
	bl	PWM_init		@PWM初期設定

	ldr	r0, =0
loop0:	
	ldr	r4, =TIMER_BASE
	ldr	r3, [r4, #CLO]
	ldr	r4, =target_time
	ldr	r5, [r4]
	cmp	r5, r3
	bgt	display

	add	r0, r0, #1
	ldr	r2, =HK_write_number_in
	str	r0, [r2]
	ldr	r5, =MY_rotate_90_n
	str	r0, [r5]
	bl	HK_write_numbers
	bl	MY_rotate_90
	ldr	r6, =D
	add	r3, r3, r6
	str	r3, [r4]
display:	
	bl	HK_display

	b	loop0

	.section .data
.equ	D, 1000 * ONE_MSEC
target_time:	.word	0
