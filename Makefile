PROJECT_NAME = retroleague

SDIR = src
IDIR = include
LDIR = lib
CDIR = doc
TDIR = build
BDIR = bin

C_SRC := $(wildcard $(SDIR)/*.c)
A_SRC := $(wildcard $(SDIR)/*.asm)

C_ASM := $(patsubst %.c,%.asm,$(C_SRC))
C_OBJ := $(addprefix $(TDIR)/,$(notdir $(patsubst %.c,%.o,$(C_SRC))))
A_OBJ := $(addprefix $(TDIR)/,$(notdir $(patsubst %.asm,%.o,$(A_SRC))))

CC65_TARGET ?= snes

ifeq ($(CC65_TARGET),snes)
CPU      := 65816
LDCONFIG := lorom128.cfg
BIN_EXT  := smc
SNES_EMU ?= znes
EMU      := $(SNES_EMU)
endif

AS       := ca65
CC       := cc65
LD       := ld65
AFLAGS   := --cpu $(CPU) -I $(IDIR)
CFLAGS   := --cpu $(CPU) -I $(IDIR) -O3
LDFLAGS  := -C $(CDIR)/$(LDCONFIG) -L $(LDIR)
LDFLAGS2 := --lib $(CC65_TARGET).lib
PROGRAM  := $(PROJECT_NAME).$(BIN_EXT)

########################################

.SUFFIXES:
.PHONY: all clean
all: $(BDIR)/$(PROGRAM)

%.asm: %.c
	$(CC) $(CFLAGS) $< -o $@

$(TDIR)/%.o: $(SDIR)/%.asm
	$(AS) $(AFLAGS) $< -o $@

$(BDIR)/$(PROGRAM): $(C_OBJ) $(A_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDFLAGS2)

crc32: $(BDIR)/$(PROGRAM)
	@./get_crc32.sh $<

play: $(BDIR)/$(PROGRAM)
	$(EMU) $<

clean:
	@rm -f $(TDIR)/*.o $(BDIR)/$(PROGRAM)
