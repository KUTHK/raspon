AS = arm-none-eabi-as
LD = arm-none-eabi-ld
LDFLAGS = -m armelf
OC = arm-none-eabi-objcopy
OCFLAGS = -O binary

# ディレクトリパス
CORE_DIR = ../core
DISPLAY_DIR = ../display
GAME_DIR = ../game
INPUT_DIR = ../input
SOUND_DIR = ../sound
UI_DIR = ../ui
INCLUDE_DIR = ../include

# インクルードパス
ASFLAGS = -I$(INCLUDE_DIR)

# ソースファイル
CORE_FILES = $(wildcard $(CORE_DIR)/*.s)
DISPLAY_FILES = $(wildcard $(DISPLAY_DIR)/*.s)
GAME_FILES = $(wildcard $(GAME_DIR)/*.s)
INPUT_FILES = $(wildcard $(INPUT_DIR)/*.s)
BGM_FILES = $(wildcard $(SOUND_DIR)/bgm/*.s)
SE_FILES = $(wildcard $(SOUND_DIR)/se/*.s)
UI_FILES = $(wildcard $(UI_DIR)/*.s)

# オブジェクトファイル
OBJ_FILES = $(patsubst $(CORE_DIR)/%.s,%.o,$(CORE_FILES)) \
            $(patsubst $(DISPLAY_DIR)/%.s,%.o,$(DISPLAY_FILES)) \
            $(patsubst $(GAME_DIR)/%.s,%.o,$(GAME_FILES)) \
            $(patsubst $(INPUT_DIR)/%.s,%.o,$(INPUT_FILES)) \
            $(patsubst $(SOUND_DIR)/bgm/%.s,%.o,$(BGM_FILES)) \
            $(patsubst $(SOUND_DIR)/se/%.s,%.o,$(SE_FILES)) \
            $(patsubst $(UI_DIR)/%.s,%.o,$(UI_FILES))

%.o: $(CORE_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(DISPLAY_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(GAME_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(INPUT_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(SOUND_DIR)/bgm/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(SOUND_DIR)/se/%.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: $(UI_DIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

main_test.elf: $(OBJ_FILES)
	$(LD) $(LDFLAGS)  main_test.o display.o GPIO_init.o PWM_init.o ball.o player_board.o player_board_draw.o switch.o LED.o GoalJudg.o MS_play_bgm.o MS_play_SE.o MS_bgm_list.o MS_bgm_fox_20th.o MS_bgm_flashman.o MS_bgm_title.o MS_bgm_saria.o MS_SE.o score.o point.o rotate.o write_number.o start.o text.o result.o -o$@
main_test.img: main_test.elf
	$(OC) $+ $(OCFLAGS) $@


.PHONY: clean
clean:
	rm -f *.o *.elf *.img
