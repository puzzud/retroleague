.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.export _init

.segment "CODE"
_init:
  clc             ; native mode
  xce
  rep #$10        ; X/Y 16-bit
  sep #$20        ; A 8-bit

  ; Clear PPU registers
  ldx #$33
@loop:
  stz $2100,x
  stz $4200,x
  dex
  bpl @loop
  
  rts
