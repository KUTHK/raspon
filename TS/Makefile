AS = arm-none-eabi-as
LD = arm-none-eabi-ld
LDFLAGS = -m armelf
OC = arm-none-eabi-objcopy
OCFLAGS = -O binary

%.o: %.s
	$(AS) $< -o $@

main_test.elf: main_test.o display.o GPIO_init.o PWM_init.o ball.o player_board.o player_board_draw.o switch.o LED.o GoalJudg.o MS_play_bgm.o MS_play_SE.o MS_bgm_list.o MS_bgm_fox_20th.o MS_bgm_flashman.o MS_bgm_saria.o MS_SE.o score.o point.o rotate.o write_number.o start.o text.o
	$(LD) $(LDFLAGS)  main_test.o display.o GPIO_init.o PWM_init.o ball.o player_board.o player_board_draw.o switch.o LED.o GoalJudg.o MS_play_bgm.o MS_play_SE.o MS_bgm_list.o MS_bgm_fox_20th.o MS_bgm_flashman.o MS_bgm_saria.o MS_SE.o score.o point.o rotate.o write_number.o start.o text.o -o$@
main_test.img: main_test.elf
	$(OC) $+ $(OCFLAGS) $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.img
