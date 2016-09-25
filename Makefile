PROJECT_NAME = retroleague

CC65_TARGET ?= nes

CTARGET = __$(shell echo $(CC65_TARGET) | tr a-z A-Z)__

SDIR = src
IDIR = include
LDIR = lib
CDIR = cfg
TDIR = build
BDIR = bin

SRC := $(wildcard $(SDIR)/game/*.c)
SRC += $(wildcard $(SDIR)/game/*.asm)
SRC += $(wildcard $(SDIR)/$(CC65_TARGET)/*.c)
SRC += $(wildcard $(SDIR)/$(CC65_TARGET)/*.asm)

ASM := $(patsubst %.c,%_c.asm,$(SRC))
OBJ := $(addprefix $(TDIR)/$(CC65_TARGET)/,$(notdir $(patsubst %.asm,%.o,$(ASM))))

ifeq ($(CC65_TARGET),c64)
CPU      := 6502
LDCONFIG := c64.cfg
BIN_EXT  := prg
C64_EMU  ?= x64
EMU      := $(C64_EMU)
PROGRAM  := $(PROJECT_NAME).$(BIN_EXT)
EXECUTABLE  := $(BDIR)/$(PROJECT_NAME).d64
TARGET_RULE := $(EXECUTABLE)
endif

ifeq ($(CC65_TARGET),nes)
CPU      := 6502
LDCONFIG := nes_nrom.cfg
BIN_EXT  := nes
NES_EMU  ?= fceux
EMU      := $(NES_EMU)
PROGRAM  := $(PROJECT_NAME).$(BIN_EXT)
EXECUTABLE := $(BDIR)/$(PROGRAM)
endif

ifeq ($(CC65_TARGET),snes)
CPU      := 65816
LDCONFIG := snes_lorom128.cfg
BIN_EXT  := smc
SNES_EMU ?= zsnes
EMU      := $(SNES_EMU)
PROGRAM  := $(PROJECT_NAME).$(BIN_EXT)
EXECUTABLE := $(BDIR)/$(PROGRAM)
endif

AS       := ca65
CC       := cc65
LD       := ld65
AFLAGS   := --cpu $(CPU) -I $(IDIR)
CFLAGS   := --cpu $(CPU) -I $(IDIR) -O3 -D$(CTARGET)
LDFLAGS  := -C $(CDIR)/$(LDCONFIG) -L $(LDIR)
LDFLAGS2 := --lib $(CC65_TARGET).lib

########################################

.SUFFIXES:
.PHONY: all clean
all: $(EXECUTABLE)

#.PRECIOUS: %_c.asm
%_c.asm: %.c
	$(CC) $(CFLAGS) $< -o $@

$(TDIR)/$(CC65_TARGET):
	@mkdir $@

$(TDIR)/$(CC65_TARGET)/%.o: $(SDIR)/game/%.asm | $(TDIR)/$(CC65_TARGET)
	$(AS) $(AFLAGS) $< -o $@

$(TDIR)/$(CC65_TARGET)/%.o: $(SDIR)/$(CC65_TARGET)/%.asm | $(TDIR)/$(CC65_TARGET)
	$(AS) $(AFLAGS) $< -o $@

$(BDIR)/$(PROGRAM): $(OBJ)
	$(LD) -Ln $(BDIR)/vice.lbl $(LDFLAGS) -o $@ $^ $(LDFLAGS2)

$(BDIR)/$(PROJECT_NAME).d64: $(BDIR)/$(PROGRAM)
	@c1541 -format $(PROJECT_NAME),"88 2a" d64 $@ -write $< $(PROJECT_NAME)

crc32: $(BDIR)/$(PROGRAM)
	@./get_crc32.sh $<

play: $(BDIR)/$(PROGRAM)
	$(EMU) $<

clean:
	@rm -fr $(TDIR)/$(CC65_TARGET)
	@rm -f $(BDIR)/$(PROGRAM)
