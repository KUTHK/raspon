	.section .init
	.global _start
	.include "common.h"

_start:
	bl	GPIO_init

	bl HK_start_init

	loop:
		bl	HK_start
		bl	HK_display
	b	loop



