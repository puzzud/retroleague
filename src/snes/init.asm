.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits
.smart  ; Track rep and sep

.import _Init
.import _Update

.importzp sp
.import __BSS_START__,__BSS_SIZE__

.segment "CODE"

.include "snes.inc"

Reset:
  sei              ; disable interrupts
  
  clc              ; native mode
  xce

  rep #$08         ; decimal mode off
  ;rep #$10         ; X/Y 16-bit
  sep #$10         ; X/Y 8-bit
  sep #$20         ; A 8-bit

  ldx #$ff      ; Set up the CPU routine stack
  txs
    
  ; Clear PPU registers
  ldx #$33
@clearPpuLoop:
  stz REG_INIDISP,x
  stz REG_NMITIMEN,x
  dex
  bpl @clearPpuLoop
  
  sec
  xce
  
  ; Set parameter stack pointer.
  lda #<(__BSS_START__+__BSS_SIZE__)
  sta sp
  lda #>(__BSS_START__+__BSS_SIZE__)
  sta sp+1
  
  jsr _Init
  
  cli
  
@mainLoop:
  jsr _Update
  bra @mainLoop

.segment "VECTORS"
  .word 0, 0, 0, 0, 0, 0, 0, 0
  .word 0, 0, 0, 0, 0, 0, Reset, 0
