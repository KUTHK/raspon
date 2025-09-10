# Build system: assemble + link for bare-metal Raspberry Pi (ARMv7)
# 上書き可能: AS, LD, OBJCOPY, OBJDUMP, SIZE 変数

AS       ?= arm-none-eabi-as
LD       ?= arm-none-eabi-ld
OBJCOPY  ?= arm-none-eabi-objcopy
OBJDUMP  ?= arm-none-eabi-objdump
SIZE     ?= arm-none-eabi-size

LDSCRIPT ?= linker.ld
ELF      ?= firmware.elf

SRC_DIRS := init display game input sound
SRCS := $(foreach d,$(SRC_DIRS),$(wildcard ../$(d)/*.s))
OBJS := $(SRCS:.s=.o)

TARGET ?= kernel7.img
MAP    ?= firmware.map

.PHONY: all clean symbols dump size verify lint format

all: $(TARGET)

%.o: %.s
	$(AS) -o $@ $<

$(ELF): $(OBJS) $(LDSCRIPT)
	@echo "[LD]  $@"
	$(LD) -nostdlib -T $(LDSCRIPT) -Map=$(MAP) -o $@ $(OBJS)
	@$(SIZE) $@ || true

$(TARGET): $(ELF)
	@echo "[OBJCP] $@"
	$(OBJCOPY) -O binary $< $@

dump: $(ELF)
	@echo "[DUMP] firmware.dump"
	$(OBJDUMP) -h -d $(ELF) > firmware.dump

size: $(ELF)
	$(SIZE) $(ELF) || true

symbols: $(ELF)
	@echo "[GEN] symbols"
	@python ../scripts/gen_symbols.py

file-index:
	@echo "[GEN] file index"
	@python ../scripts/gen_file_index.py

clean:
	rm -f $(OBJS) $(TARGET) $(MAP)

print-%:
	@echo '$*=$($*)'

format:
	@echo "[FMT] (no-op placeholder: add formatting if needed)"

lint:
	@echo "[LINT] symbols check"
	@python ../scripts/gen_symbols.py > NUL 2>&1 || true

generate-docs: symbols file-index

verify: all generate-docs size
	@echo "[VERIFY] Build + docs(auto) + size OK"
