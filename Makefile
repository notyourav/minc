TARGET = minc
TOOLCHAIN_DIR := tools/toolchain

SRC_DIR ?= src
BUILD_DIR ?= build

ASM_SRCS := src/startup.asm src/mons.asm
C_SRCS := src/main.c src/debug.c

E :=

# Tools

SHA1 := $(shell { command -v sha1sum || command -v shasum; } 2>/dev/null) -c

HAS_WINE := $(shell wine --version 2>/dev/null)
HAS_WINE64 := $(shell wine64 --version 2>/dev/null)

ifdef HAS_WINE
	WINE := wine
	SREC_CAT := srec_cat
	POKEMINID := PokeMiniD
	POKEFLASH := pokeflash
else ifdef HAS_WINE64
	WINE := wine64
	SREC_CAT := srec_cat
	POKEMINID := PokeMiniD
	POKEFLASH := pokeflash
else
	WINE :=
	POKEMINID := $(TOOLCHAIN_DIR)/bin-windows/PokeMiniD
	SREC_CAT := $(TOOLCHAIN_DIR)/bin-windows/srec_cat
	POKEFLASH := $(TOOLCHAIN_DIR)/bin-windows/pokeflash
endif

C88_DIR := $(TOOLCHAIN_DIR)/c88tools/bin
AS88 := $(WINE) $(C88_DIR)/as88.exe 
C88 := $(WINE) $(C88_DIR)/c88.exe
CC88 := $(WINE) $(C88_DIR)/cc88.exe
LC88 := $(WINE) $(C88_DIR)/lc88.exe
LK88 := $(WINE) $(C88_DIR)/lk88.exe 


# Intermediates

COMPILED_ASM := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.c.asm,$(C_SRCS))
ASM_OBJS := $(patsubst $(SRC_DIR)/%.asm,$(BUILD_DIR)/%.asm.obj,$(ASM_SRCS))

C_OBJS := $(COMPILED_ASM:.c.asm=.c.obj) 

OBJS := $(C_OBJS) $(ASM_OBJS) # only one we care about


# Flags

CFLAGS += -O2 -Iinclude -Itools/toolchain/include
LCFLAGS += -e -d pokemini -M
LKFLAGS += 
ASFLAGS +=


# Targets

# Clear the default suffixes
.SUFFIXES:
# Delete files that weren't built properly
.DELETE_ON_ERROR:

.PHONY: dir all clean
all: dir $(TARGET).min #$(shell dd conv=notrunc if=baserom.min of=$(TARGET).min count=1 bs=8448)
	@printf "\e[34mSuccess.\n\033[0m"

dir:
	mkdir -p $(BUILD_DIR)

clean:
	rm -f -r $(BUILD_DIR)
	rm -f $(TARGET).out $(TARGET).abs $(TARGET).map $(TARGET).hex
	rm -f $(TARGET).min


# Assembly / Compilation

$(TARGET).out: $(OBJS)
	@$(LK88) $(LKFLAGS) $(OBJS) -o $@ $(E)

$(BUILD_DIR)/%.c.obj: $(SRC_DIR)/%.c
	@echo $(SRC_DIR)/$*.c
	@$(C88) $(CFLAGS) $(SRC_DIR)/$*.c -o $(BUILD_DIR)/$*.c.asm $(E)
	@$(AS88) $(ASFLAGS) $(BUILD_DIR)/$*.c.asm -o $@ $(E)

$(BUILD_DIR)/%.asm.obj: $(SRC_DIR)/%.asm
	@echo $(SRC_DIR)/$*.asm
	@$(AS88) $(ASFLAGS) $(SRC_DIR)/$*.asm -o $@ $(E)


# Make ROM

%.min: %.hex
	@$(SREC_CAT) $< -o $@ -binary $(E)

%.hex %.map: %.out
	@$(LC88) $(LCFLAGS) -f2 -o $@ $< $(E)

%.abs %.map: %.out
	@$(LC88) $(LCFLAGS) -o $@ $< $(E)
