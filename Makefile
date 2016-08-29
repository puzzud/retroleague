PROJECT_NAME = retroleague

SDIR = src
IDIR = include
LDIR = lib
TDIR = build
BDIR = bin

C_SRC = src/retroleague.c

A_SRC = src/init.asm \
        src/rom.asm

C_ASM := $(C_SRC:.c=.asm)
C_OBJ := $(C_ASM:.asm=.o)
A_OBJ := $(A_SRC:.asm=.o)
            
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

%.o: %.asm
	$(AS) $(AFLAGS) $< -o $@

$(BDIR)/$(PROGRAM): $(C_OBJ) $(A_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDFLAGS2)

clean:
	@rm -f $(SDIR)/*.o $(SDIR)/$(PROJECT_NAME).asm $(TDIR)/*.o $(TDIR)/$(PROJECT_NAME).asm $(BDIR)/$(PROGRAM)
