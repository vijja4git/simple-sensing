

# Makefile for MS51 / 8051 firmware using SDCC
# Builds main.c into build/main.hex

PROJECT := main
BUILD_DIR := build

CC := sdcc
PACKIHX := packihx

# 8051 target options
CFLAGS := -mmcs51 --std-sdcc11 --opt-code-size

SRC := $(PROJECT).c
REL := $(BUILD_DIR)/$(PROJECT).rel
IHX := $(BUILD_DIR)/$(PROJECT).ihx
HEX := $(BUILD_DIR)/$(PROJECT).hex

.PHONY: all clean flash

all: $(HEX)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(REL): $(SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(IHX): $(REL)
	$(CC) $(CFLAGS) $< -o $@

$(HEX): $(IHX)
	$(PACKIHX) $< > $@
	@echo "Built: $(HEX)"

clean:
	rm -rf $(BUILD_DIR)
	@echo "Cleaned build files"

flash:
	@echo "Flash step not configured. Use Nuvoton ICP/ISP tool to flash $(HEX)."