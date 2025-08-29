    .section .text
    .global LED_ON
LED_ON:
    push {r0-r12,r14}
    ldr     r0, =0x3f200000     @ GPIO 制御用の番地


    @ GPIO #10 に 1 を出力
    mov     r1, #(1 << 10)
    str     r1, [r0, #0x1C]
    pop {r0-r12,r15}

    .global LED_OFF
LED_OFF:
    push {r0-r12,r14}
    ldr     r0, =0x3f200000     @ GPIO 制御用の番地


    @ GPIO #10 に 0 を出力
    mov     r1, #(1 << 10)
    str     r1, [r0, #0x28]
    pop {r0-r12,r15}
