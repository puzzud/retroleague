; c64 video.asm

.export _PrintColor

.export _InitializeVideo
.export _PrintText
.export _DrawImage

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.import _CHARSET
.import _SPRITES

.include "c64.inc"

.segment "BSS"

_PrintColor:
  .res 1
  
ImageWidth:
  .res 1
  
ImageHeight:
  .res 1

.segment "ZEROPAGE"

.segment "CODE"

;------------------------------------------------------------------
_InitializeVideo:
  
  lda #COLOR_BLACK
  sta _PrintColor
  
  lda #' '
  jsr FillScreen

  jsr InitializeCharacterGraphics
  jsr InitializeSprites

  rts

;------------------------------------------------------------------
InitializeCharacterGraphics:
  ;VIC bank
  lda CIA2_PRA
  and #%11111100  ; bank 3  base vic mem = $c000
  sta CIA2_PRA
  
  ;block interrupts 
  ;since we turn ROMs off this would result in crashes if we didn't
  sei
  
  ;set charset
  lda #%00111100  ; screen mem = $c000 + $0c00 = $cc00
                  ; char mem   = $c000 + $f000 = $f000
  sta VIC_VIDEO_ADR

  ;save old configuration
  lda LORAM
  pha

  ;only RAM
  ;to copy under the IO rom
  lda #%00110000
  sta LORAM

  ;take source address from CHARSET
  lda #<_CHARSET
  sta ptr1
  lda #>_CHARSET
  sta ptr1+1
  
  ;now copy
  jsr CopyCharacterSet
  
  ;restore ROMs
  pla
  sta LORAM

  cli
  
  ;enable multi color charset
  lda VIC_CTRL2
  ora #%00010000
  sta VIC_CTRL2
  
  rts

;------------------------------------------------------------------
InitializeSprites:
  ; Init sprite registers.
  ; No visible sprites.
  lda #$0
  sta VIC_SPR_ENA
  
  ; All sprites normal scale.
  sta VIC_SPR_EXP_X
  sta VIC_SPR_EXP_Y
  
  ; Take source address from SPRITES.
  lda #<_SPRITES
  sta ptr1
  lda #>_SPRITES
  sta ptr1+1
  
  sei
  
  ; Save old configuration.
  lda LORAM
  pha

  ; Only RAM to copy under the IO ROM.
  lda #%00110000
  sta LORAM
  
  jsr CopySprites

  ; Restore ROMs.
  pla
  sta LORAM

  cli

  rts

;------------------------------------------------------------------
CopyCharacterSet:
  ; Set target address ($f000).
  lda #<CHARACTER_GRAPHICS_TARGET
  sta ptr2
  lda #>CHARACTER_GRAPHICS_TARGET
  sta ptr2+1

  ldx #$00
  ldy #$00
  lda #0
  sta tmp1

@nextLine:
  lda (ptr1),Y
  sta (ptr2),Y
  inx
  iny
  cpx #$08
  bne @nextLine
  cpy #$00
  bne @pageBoundaryNotReached
  
  ; The next 256 bytes have been reached, increase high byte.
  inc ptr1+1
  inc ptr2+1

@pageBoundaryNotReached:

  ; Only copy 254 chars to keep IRQ vectors intact.
  inc tmp1
  lda tmp1
  cmp #254
  beq @copyCharsetDone
  ldx #$00
  jmp @nextLine

@copyCharsetDone:
  rts

;------------------------------------------------------------------
CopySprites:
  ldy #$00
  ldx #$00

  lda #<SPRITE_GRAPHICS_TARGET
  sta ptr2
  lda #>SPRITE_GRAPHICS_TARGET
  sta ptr2+1
    
  ; 4 sprites per loop.
@spriteLoop:
  lda (ptr1),y
  sta (ptr2),y
  iny
  bne @spriteLoop
  inx
  inc ptr1+1
  inc ptr2+1
  cpx #NUMBER_OF_SPRITES_DIV_4
  bne @spriteLoop

  rts

; _PrintText
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - text: (sp[2],sp[1]), Pointer to text string.
;  - x: sp[0], X position to write string.
;  - y: a, Y position to write string.
_PrintText:
  jsr pusha ; TODO: It should be possible to not push A and just transfer it to X.

  ldy #0 ; Y = 0; y
  lda (sp),y
  tax
  
  lda ScreenLineOffsetTableHi,x
  sta ptr2+1
  lda ScreenLineOffsetTableLo,x
  sta ptr2
  
  ; A = ptr2
  clc
  ldy #1 ; x
  adc (sp),y
  sta ptr2
  bcc @setTextPointer
  lda #0
  adc ptr2+1
  sta ptr2+1

@setTextPointer:
  clc ; (ptr+1,ptr)=&text
  lda #0
  ldy #2
  adc (sp),y
  sta ptr1
  lda #0
  iny
  adc (sp),y
  sta ptr1+1
  
  ldy #$ff
@printTextLoop:
  iny
  lda (ptr1),y ; (ptr2+1,ptr2)=a=text[++y]
  sta (ptr2),y
  bne @printTextLoop

  ; Switch ptr2 to point to color RAM.
  clc
  lda ptr2
  adc #<(SCREEN_COLOR-SCREEN_CHAR)
  sta ptr2
  lda ptr2+1
  adc #>(SCREEN_COLOR-SCREEN_CHAR)
  sta ptr2+1
  
  lda _PrintColor
@printTextColorLoop:
  dey
  sta (ptr2),y
  bne @printTextColorLoop

  jmp incsp4

; _DrawImage
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - image: (sp[2],sp[1]), Pointer to an image map.
;  - x: sp[0], X position to draw image (uppler left corner).
;  - y: a, Y position to draw image (uppler left corner)
_DrawImage:
  jsr pusha ; TODO: It should be possible to not push A and just transfer it to X.
  
  clc ; (ptr+1,ptr)=&image
  lda #0
  ldy #2
  adc (sp),y
  sta ptr1
  lda #0
  iny
  adc (sp),y
  sta ptr1+1
  
  ; Retrieve image dimensions.
  ldy #0
  lda (ptr1),y
  sta ImageWidth
  iny
  lda (ptr1),y
  sta ImageHeight
  
  ; Move ptr1 beyond header.
  clc
  lda ptr1
  adc #2
  sta ptr1
  lda #0
  adc ptr1+1
  sta ptr1+1
  
  ; Set up base target VRAM address.
  ldy #0 ; Y = 0; y
  lda (sp),y
  tax

  lda ScreenLineOffsetTableHi,x
  sta ptr2+1
  lda ScreenLineOffsetTableLo,x
  sta ptr2
  
  ; Add x offset to screen start address.
  clc
  ldy #1 ; x
  adc (sp),y
  sta ptr2
  lda #0
  adc ptr2+1
  sta ptr2+1
  
  ; Calculate color RAM.
  clc
  lda ptr2
  adc #<(SCREEN_COLOR-SCREEN_CHAR)
  sta ptr3
  lda ptr2+1
  adc #>(SCREEN_COLOR-SCREEN_CHAR)
  sta ptr3+1

  ldx #0
@drawImageYLoop:
  
  ldy #$ff
@drawImageXLoop:
  iny
  cpy ImageWidth
  beq @drawImageXLoopEnd
  
  lda (ptr1),y
  sta (ptr2),y
  lda _PrintColor
  sta (ptr3),y
  
  jmp @drawImageXLoop
@drawImageXLoopEnd:
  
  inx
  cpx ImageHeight
  bcs @endDrawImage
  
  ; Move ptr1 to start of next line.
  clc
  lda ptr1
  adc ImageWidth
  sta ptr1
  lda #0
  adc ptr1+1
  sta ptr1+1
  
  ; Move ptr2 and ptr3 to next line.
  clc
  lda ptr2
  adc #SCREEN_CHAR_WIDTH
  sta ptr2
  lda #0
  adc ptr2+1
  sta ptr2+1
  
  clc
  lda ptr3
  adc #SCREEN_CHAR_WIDTH
  sta ptr3
  lda #0
  adc ptr3+1
  sta ptr3+1
  
  jmp @drawImageYLoop

@endDrawImage:
  jmp incsp4

;------------------------------------------------------------------
FillScreen:
  pha

  ; Fill character memory.
  ; Algorithm assumes even pages,
  ; thus -1 to high byte and zeroing of low byte of address.
  lda #>(SCREEN_CHAR+SCREEN_CHAR_SIZE-1)
  sta ptr1+1
  tax ; Set up X to be part of loop as a secondary decrementer.
  ldy #0 ; Also, setting Y's starting value in loop.
  sty ptr1
  
  pla
@fillScreenCharacterLoop:
  dey
  sta (ptr1),y
  bne @fillScreenCharacterLoop
  dex
  cpx #>SCREEN_CHAR-1
  beq @endFillScreenCharacter
  stx ptr1+1
  bne @fillScreenCharacterLoop
@endFillScreenCharacter:

  ; Fill color memory.
  lda #>(SCREEN_COLOR+SCREEN_CHAR_SIZE-1)
  sta ptr1+1
  tax
  
  lda #0
  sta ptr1
  tay
  
  lda _PrintColor
@fillScreenColorLoop:
  dey
  sta (ptr1),y
  bne @fillScreenColorLoop
  dex
  cpx #>SCREEN_COLOR-1
  beq @endFillScreenColor
  stx ptr1+1
  bne @fillScreenColorLoop
@endFillScreenColor:
  
  rts
  
;------------------------------------------------------------------
.macro sloTable loOrHi, n
  .local lineNumber
  .if .paramcount > 1
    lineNumber = n
  .else
    lineNumber = 0
  .endif
  
  .local address
  address = (SCREEN_CHAR + (SCREEN_CHAR_WIDTH * lineNumber))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if lineNumber < SCREEN_CHAR_HEIGHT
    sloTable loOrHi, (lineNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro

;------------------------------------------------------------------
.macro scloTable loOrHi, n
  .local lineNumber
  .if .paramcount > 1
    lineNumber = n
  .else
    lineNumber = 0
  .endif
  
  .local address
  address = (SCREEN_COLOR + (SCREEN_CHAR_WIDTH * lineNumber))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if lineNumber < SCREEN_CHAR_HEIGHT
    scloTable loOrHi, (lineNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro

;------------------------------------------------------------------
; Preprocessed table of video RAM addresses for each start of a line.
ScreenLineOffsetTableLo:
  sloTable 0

ScreenLineOffsetTableHi:
  sloTable 1

;------------------------------------------------------------------
; Preprocessed table of video color RAM addresses for each start of a line.
ScreenColorLineOffsetTableLo:
  scloTable 0

ScreenColorLineOffsetTableHi:
  scloTable 1
