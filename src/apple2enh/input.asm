; apple2enh input.asm

.export _UpdateInput

.exportzp _ControllerButtons
.exportzp _ControllerButtonsPressed

.include "apple2.asm"

.segment "ZEROPAGE"

_ControllerButtons:
  .res 2
  
_ControllerButtonsPrevious:
  .res 2
  
_ControllerButtonsPressed:
  .res 2

ZERO:
  .res 1
  
ONE:
  .res 1

.segment "CODE"

_UpdateInput:
UpdateInput:
  lda _ControllerButtons
  sta _ControllerButtonsPressed

  ldx #0
  stx ONE
  stx ZERO
  
  ldx #127
  lda PDLTRIG
@loop:
  lda PADDLE0
  and #%10000000
  asl
  rol
  adc ZERO
  sta ZERO
  
  lda PADDLE1
  and #%10000000
  asl
  rol
  adc ONE
  sta ONE
  
  dex
  bne @loop
  
@checkAxes:
  stx _ControllerButtons ; x should be 0.

@checkXAxis:
  lda #127
  sec
  sbc ZERO
  ;sta ZERO

  ;cmp #92
  ;beq @doneCheckingXAxis
  cmp #92+9
  bcs @pressingLeft
  
@pressingRight:
  cmp #92-10
  bcs @doneCheckingXAxis
  lda _ControllerButtons
  ora #%00001000
  sta _ControllerButtons
  jmp @doneCheckingXAxis
  
@pressingLeft:
  lda _ControllerButtons
  ora #%00000100
  sta _ControllerButtons
@doneCheckingXAxis:

@checkYAxis:
  lda #127
  sec
  sbc ONE
  ;sta ONE
  
  ;cmp #93
  ;beq @doneCheckingYAxis
  cmp #93+9
  bcs @pressingUp
  
@pressingDown:
  cmp #93-10
  bcs @doneCheckingYAxis
  bcs @pressingUp
  lda _ControllerButtons
  ora #%00000010
  sta _ControllerButtons
  jmp @doneCheckingYAxis
  
@pressingUp:
  lda _ControllerButtons
  ora #%00000001
  sta _ControllerButtons
@doneCheckingYAxis:

  lda _ControllerButtonsPrevious
  eor #$ff
  and _ControllerButtons
  sta _ControllerButtonsPressed

  ; button3,button2,button1,button0,right,left,down,up
  
  rts
