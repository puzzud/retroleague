PROJECT_NAME = retroleague

SDIR = src
IDIR = include
LDIR = lib
TDIR = build
BDIR = bin

C_SRC := $(wildcard $(SDIR)/*.c)
A_SRC := $(wildcard $(SDIR)/*.asm)

C_ASM := $(patsubst %.c,%.asm,$(C_SRC))
C_OBJ := $(addprefix $(TDIR)/,$(notdir $(patsubst %.c,%.o,$(C_SRC))))
A_OBJ := $(addprefix $(TDIR)/,$(notdir $(patsubst %.asm,%.o,$(A_SRC))))

CC65_TARGET ?= snes
PROGRAM = $(PROJECT_NAME).smc
TARGET_LIB = snes.lib

ifdef CC65_TARGET
AS       = ca65
CC       = cc65
LD       = ld65
AFLAGS   = --cpu 65816 -I $(IDIR)
CFLAGS   = --cpu 65816 -I $(IDIR) -O3
LDFLAGS  = -C doc/lorom128.cfg -L $(LDIR)
LDFLAGS2 = --lib $(TARGET_LIB)
else
CC      = gcc
endif

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

clean:
	@rm -f $(TDIR)/*.o $(BDIR)/$(PROGRAM)
