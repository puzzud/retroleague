.import _Init
.import _Update

.import _UpdateInput

.importzp sp
.import __BSS_START__, __BSS_SIZE__

.export Reset

.include "c64.inc"
  
.segment "CODE"

Reset:
  sei

  lda #%01111111
  sta CIA1_ICR
  sta CIA2_ICR

  lda CIA1_ICR
  lda CIA2_ICR

  lda VIC_IMR
  ora #%00000001
  sta VIC_IMR

  lda #248
  sta VIC_HLINE

  lda VIC_CTRL1
  ;ora #%10000000
  and #%01111111
  sta VIC_CTRL1

  ; Set up interrupt routine.
  lda #<DefaultInterrupt
  sta $fffe
  lda #>DefaultInterrupt
  sta $ffff

  lda #%00110101
  sta LORAM
  
  ; Set parameter stack pointer.
  lda #<(__BSS_START__+__BSS_SIZE__)
  sta sp
  lda #>(__BSS_START__+__BSS_SIZE__)
  sta sp+1

  cli

  jsr _Init
  
@mainLoop:
  jsr _UpdateInput

  jsr _Update
  
  ; Wait for the raster to reach line $f8 (248)
  ; This loop is keeping timing stable.
  
  ; Is the raster line $f8?
  ; If so, wait for the next full screen,
  ; preventing mistimings if called too fast.
@waitFrame:
  lda VIC_HLINE
  cmp #248
  beq @waitFrame

  ; Wait for the raster to reach line $f8
  ; (should be closer to the start of this line this way).
@waitStep2:
  lda VIC_HLINE
  cmp #248
  bne @waitStep2
  
  jmp @mainLoop

;==================================================================

;------------------------------------------------------------------
DefaultInterrupt:
  pha
  txa
  pha
  tya
  pha

  lda #$ff
  sta VIC_IRR
            
  pla
  tay
  pla
  tax
  pla

EmptyInterrupt:
  rti
