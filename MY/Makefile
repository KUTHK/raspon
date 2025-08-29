AS = arm-none-eabi-as
LD = arm-none-eabi-ld
LDFLAGS = -m armelf
OC = arm-none-eabi-objcopy
OCFLAGS = -O binary

%.o: %.s
	$(AS) $< -o $@

resulttest.elf: resulttest.o result.o display.o GPIO_init.o PWM_init.o score.o point.o rotate.o write_number.o start.o text.o
	$(LD) $(LDFLAGS) resulttest.o result.o display.o GPIO_init.o PWM_init.o  score.o point.o rotate.o write_number.o start.o text.o -o$@
resulttest.img: resulttest.elf
	$(OC) $+ $(OCFLAGS) $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.img
