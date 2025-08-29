# make name.o で .o ファイルの作成
# make name.elf で .elf ファイルの作成
# make name.img で .img ファイルの作成
# make name で name.img を作成し、kernel7.img にコピー
# make umount で USB の抜き取り

# マクロ定義
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
LDFLAGS = -T ../raspbian.lds -m armelf


# サブルーチンを name.o の形で追加していく
SUB_LOUTINE = GPIO_init.o display.o write_number.o text.o start.o rotate.o point.o
#SUB_LOUTINE = GPIO_init.o display.o write_number.o position.o point.o text.o start.o rotate.o

# 自分の学籍番号を書く
NAME = 250358n

# .sから.oを生成する型規則
%.o: %.s
	$(AS) $< -o $@

%.elf: %.o $(SUB_LOUTINE)
	$(LD) -m armelf $< $(SUB_LOUTINE) -o $@

%.img: %.elf
	$(OBJCOPY) $< -O binary $@

all: $(TEST_FILE)


.PHONY: clean copy-light

clean:
	rm -f *.o *.elf *~ a.out *.img

%: %.img
	cp $< /media/$(NAME)/boot/kernel7.img
#	cp	$< ~/tsclient/D/kernel7.img

umount:
	umount /media/$(NAME)/boot/
