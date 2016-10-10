; apple2enh video.asm

.export _PrintColor

.export _InitializeVideo
.export _ClearScreen
.export _PrintText
.export _DrawImage

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.import _CHARSET
.import _SPRITES

.include "apple2.asm"

.segment "BSS"

_PrintColor:
  .res 1
  
ImageWidth:
  .res 1
  
ImageHeight:
  .res 1

.segment "ZEROPAGE"

PrintXPosition:
  .res 1

.segment "CODE"

;------------------------------------------------------------------
_InitializeVideo:
  jsr _ClearScreen
  
  lda #0
  sta CLRTEXT
  sta SETHIRES

  jsr InitializeCharacterGraphics
  ;jsr InitializeSprites

  rts

;------------------------------------------------------------------
InitializeCharacterGraphics:
  ; TODO: Temporarily reverses C64 character graphics
  ; for use in Apple II Hi-Res.
  lda #<_CHARSET
  sta ptr1
  lda #>_CHARSET
  sta ptr1+1
  
  ldx #0
@charLoop:

  ldy #0
  sty tmp1
@charSliceLoop:
  lda (ptr1),y
  
  ; Shift bits right from A into tmp1 from left.
  lsr
  rol tmp1
  lsr
  rol tmp1
  lsr
  rol tmp1
  lsr
  rol tmp1
  lsr
  rol tmp1
  lsr
  rol tmp1
  lsr
  rol tmp1
  
  ; Replace this character slice.
  lda tmp1
  and #%01111111 ; Normalize high color bit (mainly to avoid having to clear tmp1 every slice).
  sta (ptr1),y
  
  iny
  cpy #8
  bne @charSliceLoop
  
  ; Increment to next character bitmap.
  clc
  tya ; Y=8
  adc ptr1
  sta ptr1
  lda #0
  adc ptr1+1
  sta ptr1+1

  inx
  bne @charLoop
  
  rts

;------------------------------------------------------------------
InitializeSprites:

  rts

; _PrintText
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - text: (sp[2],sp[1]), Pointer to text string.
;  - x: sp[0], X position to write string.
;  - y: a, Y position to write string.
_PrintText:
  ;tax ; y

  asl
  asl
  asl
  sta tmp2  ; Y coordinate.
  
  ldy #0 ; x
  lda (sp),y
  sta PrintXPosition
  
@setTextPointer:
  clc ; (ptr+1,ptr)=&text
  lda #0
  ldy #1
  adc (sp),y
  sta ptr1
  lda #0
  iny
  adc (sp),y
  sta ptr1+1
  
  ldy #0
@printStringLoop:
  lda (ptr1),y
  beq @printStringDone
  
  tax
  lda CharsetTableLo,x
  sta ptr3
  lda CharsetTableHi,x
  sta ptr3+1

  sty tmp3

  ldx tmp2
  ldy #0
@printByteSliceLoop:

  lda ScreenLineOffsetTableLo,x
  sta ptr2
  lda ScreenLineOffsetTableHi,x
  sta ptr2+1
  
  lda (ptr3),y
  
  sty tmp1
  ldy PrintXPosition
  sta (ptr2),y
  ldy tmp1
  
  inx
  iny
  cpy #8
  bne @printByteSliceLoop
  
  inc PrintXPosition
  ldy tmp3
  
  iny
  jmp @printStringLoop

@printStringDone:

  jmp incsp3

; _DrawImage
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - image: (sp[2],sp[1]), Pointer to an image map.
;  - x: sp[0], X position to draw image (uppler left corner).
;  - y: a, Y position to draw image (uppler left corner)
_DrawImage:
  
  jmp incsp3

;------------------------------------------------------------------
FillScreen:
  
  rts
  
;------------------------------------------------------------------
_ClearScreen:
  lda #<HI_RES_PAGE_1
  sta ptr1
  lda #>HI_RES_PAGE_1
  sta ptr1+1
  
  ldy #0
  ldx #>HI_RES_PAGE_SIZE
  
  lda #0
@fillScreenLoop:
  sta (ptr1),y
  iny
  bne @fillScreenLoop
  inc ptr1+1
  dex
  bne @fillScreenLoop
  
  rts
  
;------------------------------------------------------------------
.macro sloTable loOrHi, n
  .local lineNumber
  .if .paramcount > 1
    lineNumber = n
  .else
    lineNumber = 0
  .endif
  
  .local _a
    _a = (lineNumber / 64)
  .local _d
    _d = (lineNumber - (64 * _a))
  .local _b
    _b = (_d / 8)
  .local _c
    _c = (_d - (8 * _b))
  
  .local address
  address = (HI_RES_PAGE_1 + (1024 * _c) + (128 * _b) + (SCREEN_LINE_WIDTH * _a))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if lineNumber < SCREEN_LINE_HEIGHT
    sloTable loOrHi, (lineNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro

;------------------------------------------------------------------
; Preprocessed table of video RAM addresses for each start of a line.
ScreenLineOffsetTableLo:
  sloTable 0

ScreenLineOffsetTableHi:
  sloTable 1

;------------------------------------------------------------------
.macro charsetTable loOrHi, n
  .local charNumber
  .if .paramcount > 1
    charNumber = n
  .else
    charNumber = 0
  .endif
  
  .local address
  address = (_CHARSET + (8 * charNumber))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if charNumber < 255; TODO: Crap, why can't 256 be used? This excludes character index 255.
    charsetTable loOrHi, (charNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro

;------------------------------------------------------------------
; Preprocessed table of character set character addresses.
CharsetTableLo:
  charsetTable 0

CharsetTableHi:
  charsetTable 1
