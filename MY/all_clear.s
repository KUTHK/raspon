/*----------------------------------
マトリックスLEDを全部消す
----------------------------------*/

	.include	"common.h"
	.section	.text
	.global		all_clear

all_clear:
	push	{r1, r14}

	@ 全列消灯
	mov	r1, #(1 << COL1_PORT)
	orr	r1, r1, #(1 << COL2_PORT)
	orr	r1, r1, #(1 << COL3_PORT)
	orr	r1, r1, #(1 << COL4_PORT)
	orr	r1, r1, #(1 << COL5_PORT)
	orr	r1, r1, #(1 << COL6_PORT)
	orr	r1, r1, #(1 << COL7_PORT)
	orr	r1, r1, #(1 << COL8_PORT)
	str	r1, [r0, #GPCLR0]

	@ 全行消灯
	mov	r1, #(1 << ROW1_PORT)
	orr	r1, r1, #(1 << ROW2_PORT)
	orr	r1, r1, #(1 << ROW3_PORT)
	orr	r1, r1, #(1 << ROW4_PORT)
	orr	r1, r1, #(1 << ROW5_PORT)
	orr	r1, r1, #(1 << ROW6_PORT)
	orr	r1, r1, #(1 << ROW7_PORT)
	orr	r1, r1, #(1 << ROW8_PORT)
	str	r1, [r0, #GPSET0]

	pop	{r1, r15}
