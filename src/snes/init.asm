.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.import _Init
.import _Update

.importzp sp
.import __BSS_START__,__BSS_SIZE__

.export _Reset

.segment "CODE"

_Reset:
  sei              ; disable interrupts
  
  clc              ; native mode
  xce

  rep #$18         ; X/Y 16-bi, decimal mode off
  sep #$20         ; A 8-bit
  
  ldx #$1ff        ; Set up the CPU routine stack
  txs
  
  lda #<(__BSS_START__+__BSS_SIZE__)
  sta sp
  lda #>(__BSS_START__+__BSS_SIZE__)
  sta sp+1         ; Set argument stack ptr
  
  ; Clear PPU registers
  ldx #$33
@clearPpuLoop:
  stz $2100,x
  stz $4200,x
  dex
  bpl @clearPpuLoop
  
  jsr _Init
  
@mainLoop:
  jsr _Update
  bra @mainLoop
