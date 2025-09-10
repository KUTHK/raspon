# ========= 基本設定 =========
CROSS      ?= arm-none-eabi
AS         := $(CROSS)-gcc
LD         := $(CROSS)-gcc
OBJDUMP    := $(CROSS)-objdump
OBJCOPY    := $(CROSS)-objcopy

TARGET     := raspon.elf
MAP        := raspon.map

# ========= ディレクトリ =========
SRC_ROOT   := src
BUILD_DIR  := build

# ========= ソース自動収集 (.s) =========
ASM_SRCS   := $(shell find $(SRC_ROOT) -type f -name '*.s')
# 例: src/init/GPIO_init.s → build/src/init/GPIO_init.o
OBJS       := $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SRCS))

# ========= インクルードパス =========
INCLUDES   := -I$(SRC_ROOT)/include -I$(SRC_ROOT)/audio/data

# ========= フラグ（必要に応じて修正） =========
ASFLAGS    := -mcpu=cortex-m0 -mthumb -O2 $(INCLUDES)
LDFLAGS    := -mcpu=cortex-m0 -mthumb -nostartfiles -Wl,-Map=$(MAP)

# ========= ルール =========
.PHONY: all clean tree

all: $(TARGET)

$(TARGET): $(OBJS)
    @echo "[LD]  $@"
    $(LD) $(LDFLAGS) -o $@ $(OBJS)

# 各オブジェクト: build/ + ソースの相対パス
$(BUILD_DIR)/%.o: %.s
    @mkdir -p $(dir $@)
    @echo "[AS]  $<"
    $(AS) $(ASFLAGS) -c $< -o $@

# ツリー表示（確認用）
tree:
    @echo "ASM_SRCS:"
    @printf '%s\n' $(ASM_SRCS)
    @echo ""
    @echo "OBJS:"
    @printf '%s\n' $(OBJS)

clean:
    @echo "[CLEAN]"
    rm -rf $(BUILD_DIR) $(TARGET) $(MAP)

# ========= 追加（バイナリ/HEXが必要なら） =========
bin: $(TARGET)
    $(OBJCOPY) -O binary $(TARGET) raspon.bin

hex: $(TARGET)
    $(OBJCOPY) -O ihex $(TARGET) raspon.hex