; c64 input.asm

.export _UpdateInput

.exportzp _ControllerButtons
.exportzp _ControllerButtonsPressed

.include "c64.asm"

.segment "ZEROPAGE"

_ControllerButtons:
  .res 2
  
_ControllerButtonsPrevious:
  .res 2
  
_ControllerButtonsPressed:
  .res 2

.segment "CODE"

_UpdateInput:
  ldx #0

@joystickLoop:
  lda _ControllerButtons,x
  sta _ControllerButtonsPrevious,x
  
  lda CIA1_DDRA,x
  tay
  
  cli
  
  lda #$00
  sta CIA1_DDRA,x
  
  lda CIA1_PRA,x
  eor #$ff
  and #%00011111
  sta _ControllerButtons,x
  
  tya
  sta CIA1_DDRA,x
  
  sei
  
  lda _ControllerButtonsPrevious,x
  eor #$ff
  and _ControllerButtons,x
  sta _ControllerButtonsPressed,x
  
  inx
  cpx #2 ; Number of joysticks.
  bne @joystickLoop
  
  rts
