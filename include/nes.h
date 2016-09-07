//=============  
// NES Include
//==============
#ifndef NES_H
#define NES_H

#include "system.h"

// PPU defines

#define PPU_CTRL1         BYTE_FROM_ADDRESS(0x2000)
#define PPU_CTRL2         BYTE_FROM_ADDRESS(0x2001)
#define PPU_STATUS        BYTE_FROM_ADDRESS(0x2002)
#define PPU_SPR_ADDR      BYTE_FROM_ADDRESS(0x2003)
#define PPU_SPR_IO        BYTE_FROM_ADDRESS(0x2004)
#define PPU_VRAM_ADDR1    BYTE_FROM_ADDRESS(0x2005)
#define PPU_VRAM_ADDR2    BYTE_FROM_ADDRESS(0x2006)
#define PPU_VRAM_IO       BYTE_FROM_ADDRESS(0x2007)

// APU defines

#define APU_PULSE1CTRL    BYTE_FROM_ADDRESS(0x4000)         // Pulse #1 Control Register (W)
#define APU_PULSE1RAMP    BYTE_FROM_ADDRESS(0x4001)         // Pulse #1 Ramp Control Register (W)
#define APU_PULSE1FTUNE   BYTE_FROM_ADDRESS(0x4002)         // Pulse #1 Fine Tune (FT) Register (W)
#define APU_PULSE1CTUNE   BYTE_FROM_ADDRESS(0x4003)         // Pulse #1 Coarse Tune (CT) Register (W)
#define APU_PULSE2CTRL    BYTE_FROM_ADDRESS(0x4004)         // Pulse #2 Control Register (W)
#define APU_PULSE2RAMP    BYTE_FROM_ADDRESS(0x4005)         // Pulse #2 Ramp Control Register (W)
#define APU_PULSE2FTUNE   BYTE_FROM_ADDRESS(0x4006)         // Pulse #2 Fine Tune Register (W)
#define APU_PULSE2STUNE   BYTE_FROM_ADDRESS(0x4007)         // Pulse #2 Coarse Tune Register (W)
#define APU_TRICTRL1      BYTE_FROM_ADDRESS(0x4008)         // Triangle Control Register #1 (W)
#define APU_TRICTRL2      BYTE_FROM_ADDRESS(0x4009)         // Triangle Control Register #2 (?)
#define APU_TRIFREQ1      BYTE_FROM_ADDRESS(0x400A)         // Triangle Frequency Register #1 (W)
#define APU_TRIFREQ2      BYTE_FROM_ADDRESS(0x400B)         // Triangle Frequency Register #2 (W)
#define APU_NOISECTRL     BYTE_FROM_ADDRESS(0x400C)         // Noise Control Register #1 (W)
//#define APU_              BYTE_FROM_ADDRESS(0x400D)  // Unused (???)
#define APU_NOISEFREQ1    BYTE_FROM_ADDRESS(0x400E)         // Noise Frequency Register #1 (W)
#define APU_NOISEFREQ2    BYTE_FROM_ADDRESS(0x400F)         // Noise Frequency Register #2 (W)
#define APU_MODCTRL       BYTE_FROM_ADDRESS(0x4010)         // Delta Modulation Control Register (W)
#define APU_MODDA         BYTE_FROM_ADDRESS(0x4011)         // Delta Modulation D/A Register (W)
#define APU_MODADDR       BYTE_FROM_ADDRESS(0x4012)         // Delta Modulation Address Register (W)
#define APU_MODLEN        BYTE_FROM_ADDRESS(0x4013)         // Delta Modulation Data Length Register (W)
#define APU_SPR_DMA       BYTE_FROM_ADDRESS(0x4014)         // Sprite DMA Register (W)
#define APU_CHANCTRL      BYTE_FROM_ADDRESS(0x4015)         // Sound/Vertical Clock Signal Register (R)
#define APU_PAD1          BYTE_FROM_ADDRESS(0x4016)         // Joypad #1 (RW)
#define APU_PAD2          BYTE_FROM_ADDRESS(0x4017)         // Joypad #2/SOFTCLK (RW)

#define MMC5_PRG_MODE           BYTE_FROM_ADDRESS(0x5100)
#define MMC5_CHR_MODE           BYTE_FROM_ADDRESS(0x5101)
#define MMC5_PRG_RAM_PROT_1     BYTE_FROM_ADDRESS(0x5102)
#define MMC5_PRG_RAM_PROT_2     BYTE_FROM_ADDRESS(0x5103)
#define MMC5_EXRAM_MODE         BYTE_FROM_ADDRESS(0x5104)
#define MMC5_NTABLE_MAP         BYTE_FROM_ADDRESS(0x5105)
#define MMC5_FILL_MODE_TILE     BYTE_FROM_ADDRESS(0x5106)
#define MMC5_FILL_MODE_COLOR    BYTE_FROM_ADDRESS(0x5107)

#define MMC5_PRG_RAM_BANK       BYTE_FROM_ADDRESS(0x5113)
#define MMC5_PRG_BANK_0         BYTE_FROM_ADDRESS(0x5114)
#define MMC5_PRG_BANK_1         BYTE_FROM_ADDRESS(0x5115)
#define MMC5_PRG_BANK_2         BYTE_FROM_ADDRESS(0x5116)
#define MMC5_PRG_BANK_3         BYTE_FROM_ADDRESS(0x5117)

#define MMC5_SPR_CHR_BANK_0     BYTE_FROM_ADDRESS(0x5120)
#define MMC5_SPR_CHR_BANK_1     BYTE_FROM_ADDRESS(0x5121)
#define MMC5_SPR_CHR_BANK_2     BYTE_FROM_ADDRESS(0x5122)
#define MMC5_SPR_CHR_BANK_3     BYTE_FROM_ADDRESS(0x5123)
#define MMC5_SPR_CHR_BANK_4     BYTE_FROM_ADDRESS(0x5124)
#define MMC5_SPR_CHR_BANK_5     BYTE_FROM_ADDRESS(0x5125)
#define MMC5_SPR_CHR_BANK_6     BYTE_FROM_ADDRESS(0x5126)
#define MMC5_SPR_CHR_BANK_7     BYTE_FROM_ADDRESS(0x5127)
#define MMC5_BKGRD_CHR_BANK_0   BYTE_FROM_ADDRESS(0x5128)
#define MMC5_BKGRD_CHR_BANK_1   BYTE_FROM_ADDRESS(0x5129)
#define MMC5_BKGRD_CHR_BANK_2   BYTE_FROM_ADDRESS(0x512a)
#define MMC5_BKGRD_CHR_BANK_3   BYTE_FROM_ADDRESS(0x512b)

#define MMC5_UPPER_CHR_BANK     BYTE_FROM_ADDRESS(0x5130)

#define MMC5_VERT_SPLIT_MODE    BYTE_FROM_ADDRESS(0x5200)
#define MMC5_VERT_SPLIT_SCRL    BYTE_FROM_ADDRESS(0x5201)
#define MMC5_VERT_SPLIT_BANK    BYTE_FROM_ADDRESS(0x5202)
#define MMC5_IRQ_COUNTER        BYTE_FROM_ADDRESS(0x5203)
#define MMC5_IRQ_STATUS         BYTE_FROM_ADDRESS(0x5204)
#define MMC5_MULTI_1            BYTE_FROM_ADDRESS(0x5205)
#define MMC5_MULTI_2            BYTE_FROM_ADDRESS(0x5206)

#define MMC5_EXRAM              BYTE_FROM_ADDRESS(0x5c00)
#define MMC5_EXRAM_END          BYTE_FROM_ADDRESS(0x5fff)

// Video (PPU) RAM Addresses.
#define PPU_PATTERN_TABLE_0     BYTE_FROM_ADDRESS(0x0000)
#define PPU_PATTERN_TABLE_1     BYTE_FROM_ADDRESS(0x1000)
#define PPU_NAME_TABLE_0        BYTE_FROM_ADDRESS(0x2000)
#define PPU_ATTRIBUTE_TABLE_0   BYTE_FROM_ADDRESS(0x23C0)
#define PPU_NAME_TABLE_1        BYTE_FROM_ADDRESS(0x2400)
#define PPU_ATTRIBUTE_TABLE_1   BYTE_FROM_ADDRESS(0x27C0)
#define PPU_NAME_TABLE_2        BYTE_FROM_ADDRESS(0x2800)
#define PPU_ATTRIBUTE_TABLE_2   BYTE_FROM_ADDRESS(0x2bc0)
#define PPU_NAME_TABLE_3        BYTE_FROM_ADDRESS(0x2c00)
#define PPU_ATTRIBUTE_TABLE_3   BYTE_FROM_ADDRESS(0x2fc0)
#define PPU_UNUSED              BYTE_FROM_ADDRESS(0x3000)
#define PPU_IMAGE_PALETTE_1     BYTE_FROM_ADDRESS(0x3f00)
#define PPU_SPRITE_PALETTE_1    BYTE_FROM_ADDRESS(0x3f10)
#define PPU_PALETTE_MIRROR      BYTE_FROM_ADDRESS(0x3f20)

#define SCREEN_CHAR_WIDTH       32
#define SCREEN_CHAR_HEIGHT      30

#define NUMBER_OF_HARDWARE_SPRITES   64
#define HARDWARE_SPRITE_WIDTH        8
#define HARDWARE_SPRITE_HEIGHT       8
#define BYTES_PER_HARDWARE_SPRITE    4

#define NUMBER_OF_COLORS_PER_PALETTE_ENTRY   4
#define NUMBER_OF_ENTRIES_PER_PALETTE        4

#define GAMEPAD_BUTTON0         0x01
#define GAMEPAD_BUTTON1         0x02
#define GAMEPAD_BUTTON2         0x04
#define GAMEPAD_BUTTON3         0x08
#define GAMEPAD_UP              0x10
#define GAMEPAD_DOWN            0x20
#define GAMEPAD_LEFT            0x40
#define GAMEPAD_RIGHT           0x80

#define CONTROLLER_LEFT         GAMEPAD_LEFT
#define CONTROLLER_RIGHT        GAMEPAD_RIGHT
#define CONTROLLER_UP           GAMEPAD_UP
#define CONTROLLER_DOWN         GAMEPAD_DOWN
#define CONTROLLER_BUTTON0      GAMEPAD_BUTTON1
#define CONTROLLER_BUTTON1      GAMEPAD_BUTTON0
#define CONTROLLER_BUTTON2      GAMEPAD_BUTTON2
#define CONTROLLER_BUTTON3      GAMEPAD_BUTTON3

#endif
