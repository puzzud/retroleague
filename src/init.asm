.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.import _main

.export _init
.export __STARTUP__

.segment "CODE"

__STARTUP__:
_init:
  sei              ; disable interrupts
  
  clc              ; native mode
  xce

  rep #$18         ; X/Y 16-bi, decimal mode off
  sep #$20         ; A 8-bit
  
  ;ldx #$1fff       ; Set up the stack
  ;txs
  
  ; Clear PPU registers
  ldx #$33
@loop:
  stz $2100,x
  stz $4200,x
  dex
  bpl @loop

  jmp _main
