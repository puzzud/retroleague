; nes input.asm

.export _UpdateInput

.exportzp _ControllerButtons
.exportzp _ControllerButtonsPressed

.include "nes.asm"

.segment "ZEROPAGE"

_ControllerButtons:
  .res 2
  
_ControllerButtonsPrevious:
  .res 2
  
_ControllerButtonsPressed:
  .res 2

.segment "CODE"

_UpdateInput:
  ldx #1
  stx APU_PAD1
  dex
  stx APU_PAD1
  
@joysticksLoop:
  lda _ControllerButtons,x
  sta _ControllerButtonsPrevious,x

  ldy #0
@gamepadButtonsLoop:
  lda APU_PAD1,x
  lsr
  ror _ControllerButtons,x
  iny
  cpy #8
  bne @gamepadButtonsLoop
  
  lda _ControllerButtonsPrevious,x
  eor #$ff
  and _ControllerButtons,x
  sta _ControllerButtonsPressed,x
  
  inx
  cpx #2 ; Number of gamepads.
  bne @joysticksLoop
  
  rts
