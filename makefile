GCC = riscv64-linux-gnu-gcc
AS = riscv64-linux-gnu-as
QEMU = qemu-riscv64
LDFLAGS = -static

LAB ?= lab01

BUILD_DIR = build/$(LAB)

ASM_SRC = software/$(LAB)/$(LAB).s
C_SRC   = software/$(LAB)/main.c

ASM_OBJ = $(BUILD_DIR)/$(LAB).o
C_OBJ   = $(BUILD_DIR)/main.o
OUTPUT  = $(BUILD_DIR)/exe

.PHONY: all
all: $(OUTPUT)

$(BUILD_DIR):
	mkdir -p $@

$(ASM_OBJ): $(ASM_SRC) | $(BUILD_DIR)
	$(AS) $(ASM_SRC) -o $@

$(C_OBJ): $(C_SRC) | $(BUILD_DIR)
	$(GCC) -c $(C_SRC) -o $@

$(OUTPUT): $(ASM_OBJ) $(C_OBJ)
	$(GCC) $(LDFLAGS) $(ASM_OBJ) $(C_OBJ) -o $@

.PHONY: run
run: $(OUTPUT)
	$(QEMU) $(OUTPUT)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)