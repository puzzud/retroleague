.import _Init
.import _Update

.importzp sp
.import __RAM_START__,__RAM_SIZE__

.export Reset

.include "nes.inc"

.segment "ZEROPAGE"

NmiStatus:
  .byte 0

.segment "CODE"

Reset:
  sei          ; disable IRQs
  cld          ; disable decimal mode
    
  lda #0
@clearMemory:
  sta $00,x     ;7
  sta $0100,x   ;28
  sta $0200,x
  sta $0300,x
  sta $0400,x
  sta $0500,x
  sta $0600,x
  sta $0700,x
  inx           ;5
  bne @clearMemory
  
  dex          ; ldx #$ff
  txs          ; Set up stack
  
  inx          ; X = 0
    
waitSync1:
  bit PPU_STATUS
@waitSync1Loop:
  bit PPU_STATUS
  bpl @waitSync1Loop

clearPalette:
  ldy #$3f
  sty PPU_VRAM_ADDR2
  stx PPU_VRAM_ADDR2
  
  lda #$0f
  ldx #32
@clearPaletteLoop:
  sta PPU_VRAM_IO
  dex
  bne @clearPaletteLoop

clearVram:
  txa
  ldy #$20
  sty PPU_VRAM_ADDR2
  sta PPU_VRAM_ADDR2
  
  ldy #16
@clearVramLoop:
  sta PPU_VRAM_IO
  inx
  bne @clearVramLoop
  dey
  bne @clearVramLoop

  ; Set parameter stack pointer.
  lda #<(__RAM_START__+__RAM_SIZE__)
  sta sp
  lda #>(__RAM_START__+__RAM_SIZE__)
  sta sp+1

waitSync2:
  bit PPU_STATUS
@waitSync2Loop:
  bit PPU_STATUS
  bpl @waitSync2Loop

  ; Enable NMI.
  lda #%10000000
  sta PPU_CTRL1

  lda #0
  sta PPU_VRAM_ADDR1
  sta PPU_VRAM_ADDR1

  jsr _Init
  
@mainLoop:
  jsr _Update

  jmp @mainLoop
  
;------------------------------------------------------------------
NmiRoutine:
  php
  pha
  txa
  pha
  tya
  pha
  
  ; TODO: Update video here.
  
NmiFinished:
  lda #1
  sta NmiStatus
  
  pla
  tay
  pla
  tax
  pla
  plp
  
  rti
  
;------------------------------------------------------------------
IrqRoutine:
  rti

.segment "VECTORS"
  .word NmiRoutine
  .word Reset
  .word IrqRoutine
