# make name.o で .o ファイルの作成
# make name.elf で .elf ファイルの作成
# make name.img で .img ファイルの作成
# make name で name.img を作成し、kernel7.img にコピー
# make umount で USB の抜き取り

# マクロ定義
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy


# サブルーチンを name.o の形で追加していく
SUB_LOUTINE = GPIO_init.o PWM_init.o MS_play_bgm.o MS_play_SE.o MS_bgm_list.o MS_bgm_fox_20th.o MS_bgm_flashman.o MS_bgm_title.o MS_bgm_saria.o MS_SE.o

# .sから.oを生成する型規則
%.o: %.s
	$(AS) $< -o $@

%.elf: %.o $(SUB_LOUTINE)
	$(LD) -m armelf $< $(SUB_LOUTINE) -o $@

%.img: %.elf
	$(OBJCOPY) $< -O binary $@

.PHONY: clean

clean:
	rm -f *.o *.elf *~ a.out *.img
