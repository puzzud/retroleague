;============== 
; NES Include
;==============

;; PPU defines

PPU_CTRL1       = $2000
PPU_CTRL2       = $2001
PPU_STATUS      = $2002
PPU_SPR_ADDR    = $2003
PPU_SPR_IO      = $2004
PPU_VRAM_ADDR1  = $2005
PPU_VRAM_ADDR2  = $2006
PPU_VRAM_IO     = $2007

;; APU defines

APU_PULSE1CTRL  = $4000         ; Pulse #1 Control Register (W)
APU_PULSE1RAMP  = $4001         ; Pulse #1 Ramp Control Register (W)
APU_PULSE1FTUNE = $4002         ; Pulse #1 Fine Tune (FT) Register (W)
APU_PULSE1CTUNE = $4003         ; Pulse #1 Coarse Tune (CT) Register (W)
APU_PULSE2CTRL  = $4004         ; Pulse #2 Control Register (W)
APU_PULSE2RAMP  = $4005         ; Pulse #2 Ramp Control Register (W)
APU_PULSE2FTUNE = $4006         ; Pulse #2 Fine Tune Register (W)
APU_PULSE2CTUNE = $4007         ; Pulse #2 Coarse Tune Register (W)
APU_TRICTRL1    = $4008         ; Triangle Control Register #1 (W)
APU_TRICTRL2    = $4009         ; Triangle Control Register #2 (?)
APU_TRIFREQ1    = $400A         ; Triangle Frequency Register #1 (W)
APU_TRIFREQ2    = $400B         ; Triangle Frequency Register #2 (W)
APU_NOISECTRL   = $400C         ; Noise Control Register #1 (W)
;;APU_ = $400D  ; Unused (???)
APU_NOISEFREQ1  = $400E         ; Noise Frequency Register #1 (W)
APU_NOISEFREQ2  = $400F         ; Noise Frequency Register #2 (W)
APU_MODCTRL     = $4010         ; Delta Modulation Control Register (W)
APU_MODDA       = $4011         ; Delta Modulation D/A Register (W)
APU_MODADDR     = $4012         ; Delta Modulation Address Register (W)
APU_MODLEN      = $4013         ; Delta Modulation Data Length Register (W)
APU_SPR_DMA     = $4014         ; Sprite DMA Register (W)
APU_CHANCTRL    = $4015         ; Sound/Vertical Clock Signal Register (R)
APU_PAD1        = $4016         ; Joypad #1 (RW)
APU_PAD2        = $4017         ; Joypad #2/SOFTCLK (RW)

MMC5_PRG_MODE         = $5100
MMC5_CHR_MODE         = $5101
MMC5_PRG_RAM_PROT_1   = $5102
MMC5_PRG_RAM_PROT_2   = $5103
MMC5_EXRAM_MODE       = $5104
MMC5_NTABLE_MAP       = $5105
MMC5_FILL_MODE_TILE   = $5106
MMC5_FILL_MODE_COLOR  = $5107

MMC5_PRG_RAM_BANK     = $5113
MMC5_PRG_BANK_0       = $5114
MMC5_PRG_BANK_1       = $5115
MMC5_PRG_BANK_2       = $5116
MMC5_PRG_BANK_3       = $5117

MMC5_SPR_CHR_BANK_0   = $5120
MMC5_SPR_CHR_BANK_1   = $5121
MMC5_SPR_CHR_BANK_2   = $5122
MMC5_SPR_CHR_BANK_3   = $5123
MMC5_SPR_CHR_BANK_4   = $5124
MMC5_SPR_CHR_BANK_5   = $5125
MMC5_SPR_CHR_BANK_6   = $5126
MMC5_SPR_CHR_BANK_7   = $5127
MMC5_BKGRD_CHR_BANK_0 = $5128
MMC5_BKGRD_CHR_BANK_1 = $5129
MMC5_BKGRD_CHR_BANK_2 = $512a
MMC5_BKGRD_CHR_BANK_3 = $512b

MMC5_UPPER_CHR_BANK   = $5130

MMC5_VERT_SPLIT_MODE  = $5200
MMC5_VERT_SPLIT_SCRL  = $5201
MMC5_VERT_SPLIT_BANK  = $5202
MMC5_IRQ_COUNTER      = $5203
MMC5_IRQ_STATUS       = $5204
MMC5_MULTI_1          = $5205
MMC5_MULTI_2          = $5206

MMC5_EXRAM            = $5c00
MMC5_EXRAM_END        = $5fff

; Video (PPU) RAM Addresses.
PPU_PATTERN_TABLE_0   = $0000
PPU_PATTERN_TABLE_1   = $1000
PPU_NAME_TABLE_0      = $2000
PPU_ATTRIBUTE_TABLE_0 = $23C0
PPU_NAME_TABLE_1      = $2400
PPU_ATTRIBUTE_TABLE_1 = $27C0
PPU_NAME_TABLE_2      = $2800
PPU_ATTRIBUTE_TABLE_2 = $2bc0
PPU_NAME_TABLE_3      = $2c00
PPU_ATTRIBUTE_TABLE_3 = $2fc0
PPU_UNUSED            = $3000
PPU_IMAGE_PALETTE_1   = $3f00
PPU_SPRITE_PALETTE_1  = $3f10
PPU_PALETTE_MIRROR    = $3f20

SCREEN_CHAR_WIDTH     = 32
SCREEN_CHAR_HEIGHT    = 30

NUMBER_OF_HARDWARE_SPRITES = 64
HARDWARE_SPRITE_WIDTH      = 8
HARDWARE_SPRITE_HEIGHT     = 8
BYTES_PER_HARDWARE_SPRITE  = 4

NUMBER_OF_COLORS_PER_PALETTE_ENTRY = 4
NUMBER_OF_ENTRIES_PER_PALETTE      = 4

GAMEPAD_BUTTON0         = $01
GAMEPAD_BUTTON1         = $02
GAMEPAD_BUTTON2         = $04
GAMEPAD_BUTTON3         = $08
GAMEPAD_UP              = $10
GAMEPAD_DOWN            = $20
GAMEPAD_LEFT            = $40
GAMEPAD_RIGHT           = $80

CONTROLLER_LEFT         = GAMEPAD_LEFT
CONTROLLER_RIGHT        = GAMEPAD_RIGHT
CONTROLLER_UP           = GAMEPAD_UP
CONTROLLER_DOWN         = GAMEPAD_DOWN
CONTROLLER_BUTTON0      = GAMEPAD_BUTTON1
CONTROLLER_BUTTON1      = GAMEPAD_BUTTON0
CONTROLLER_BUTTON2      = GAMEPAD_BUTTON2
CONTROLLER_BUTTON3      = GAMEPAD_BUTTON3
