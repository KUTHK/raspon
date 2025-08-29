AS = arm-none-eabi-as
LD = arm-none-eabi-ld
LDFLAGS = -m armelf
OC = arm-none-eabi-objcopy
OCFLAGS = -O binary

%.o: %.s
	$(AS) $< -o $@

main_test.elf: main_test.o display.o GPIO_init.o ball.o player_board.o player_board_draw.o switch.o
	$(LD) $(LDFLAGS)  main_test.o display.o GPIO_init.o ball.o player_board.o player_board_draw.o switch.o -o $@
main_test.img: main_test.elf
	$(OC) $+ $(OCFLAGS) $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.img


