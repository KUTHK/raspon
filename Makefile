AS       = arm-none-eabi-as
LD       = arm-none-eabi-ld
LDFLAGS  = -m armelf --section-start=.init=0x8000 -e _start -nostdlib
OC       = arm-none-eabi-objcopy
OCFLAGS  = -O binary

# ソースは src/ 以下に散在。ベース名は一意なので VPATH で解決。
VPATH = \
	src:src/init:src/display:src/main \
	src/game/ball:src/game/player:src/game/logic:src/game/scenes \
	src/audio/play:src/audio/data

# インクルード（.include）検索パス
ASINC = -Isrc/include -Isrc/audio/data

# 明示的なオブジェクト列（順序も固定）
OBJS = \
	main.o display.o GPIO_init.o PWM_init.o \
	ball.o player_board.o player_board_draw.o switch.o GoalJudg.o \
	MS_play_bgm.o MS_play_SE.o \
	MS_bgm_list.o MS_bgm_fox_20th.o MS_bgm_flashman.o MS_bgm_title.o MS_bgm_saria.o MS_SE.o \
	score.o point.o rotate.o write_number.o start.o text.o result.o

all: kernel7.img

# .s → .o
%.o: %.s
	@echo "[AS]  $<"
	$(AS) -mcpu=cortex-a7 $(ASINC) $< -o $@

# 明示リストでリンク
raspon.elf: $(OBJS)
	@echo "[LD]  $@"
	$(LD) $(LDFLAGS) $(OBJS) -o $@

# ELF → イメージ
kernel7.img: raspon.elf
	@echo "[OBJCOPY] $@"
	$(OC) raspon.elf $(OCFLAGS) $@

.PHONY: clean
clean:
	rm -f *.o *.elf *.img
