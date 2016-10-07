; nes video.asm

.export _PrintColorSet
.export _ClearScreen
.export _PrintText
.export _DrawImage

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.include "nes.asm"

.segment "ZEROPAGE"

ImageWidth:
  .res 1
  
ImageHeight:
  .res 1
  
_PrintColorSet:
  .res 1

.segment "BSS"
  
.segment "CODE"

; _PrintText
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - text: (sp[2],sp[1]), Pointer to text string.
;  - x: sp[0], X position to write string.
;  - y: a, Y position to write string.
_PrintText:
  sta tmp2 ; y
  
  ldy #0 ; x
  lda (sp),y
  sta tmp1
  
  ldx tmp2
  
  lda ScreenLineOffsetTableHi,x
  sta ptr2+1
  lda ScreenLineOffsetTableLo,x
  sta ptr2
  
  ; A = ptr2
  clc
  adc tmp1 ; x
  sta ptr2
  bcc @endAddXOffsetToCharVram
  lda #0
  adc ptr2+1
  sta ptr2+1
@endAddXOffsetToCharVram:
  
  lda PPU_STATUS
  
@setVramAddress:  
  lda ptr2+1
  sta PPU_VRAM_ADDR2
  lda ptr2
  sta PPU_VRAM_ADDR2
  
  clc ; (ptr+1,ptr)=&text
  lda #0
  ldy #1
  adc (sp),y
  sta ptr1
  lda #0
  iny
  adc (sp),y
  sta ptr1+1
  
  ldy #$ff
@printTextLoop:
  iny
  lda (ptr1),y ; PPU_VRAM_IO=a=text[++y]
  beq @endPrintTextLoop
  sta PPU_VRAM_IO
  bne @printTextLoop
@endPrintTextLoop:
  dey
  sty tmp3 ; index for loop.
  
  ldy tmp1 ; x
  ldx tmp2 ; y
@printColorLoop:
  jsr SetCharacterAttribute
  
  iny
  dec tmp3
  bne @printColorLoop
  
  ; A = 0
  sta PPU_VRAM_ADDR2
  sta PPU_VRAM_ADDR2
  sta PPU_VRAM_ADDR1
  sta PPU_VRAM_ADDR1

  jmp incsp3

; SetCharacterAttribute
; Sets the corresponding attribute table half-nibble to _PrintColorSet.
;
; inputs:
;  - x: y, x coordinate.
;  - y: x, y coordinate.
;
; modifies:
;  - AttributePointer: address to attribute byte to modify.
;  - AttributeQuadrantNumber: which of the 4 attribute quadrants to modify.
;  - AttributeTemp: temporary variable for SetCharacterAttribute.
;
; preserves:
;  - a
;  - x
;  - y
.segment "ZEROPAGE"

AttributePointer:
  .res 2

AttributeQuadrantNumber:
  .res 1
  
AttributeTemp:
  .res 1

.segment "CODE"

SetCharacterAttribute:
  pha
  txa
  pha
  tya
  pha
  
  ; Note that the high value on a standard NES will not change.
  lda #>(PPU_ATTRIBUTE_TABLE_0)
  sta AttributePointer+1
  lda ScreenColorLineOffsetTableLo,x
  sta AttributePointer

  tya ; x /= 4
  lsr
  lsr
  clc
  adc AttributePointer
  sta AttributePointer
@endAddXOffsetToColorVram:
 
@getQuadrantNumber:
  ; Calculate attribute byte quadrant number.
  lda #0
  sta AttributeQuadrantNumber
 
@getAttributeRow:
  inx ; NOTE: First line compensation. Also, X is modified here!
  txa ; y % 4
  and #%11
  cmp #2
  bcc @getAttributeColumn
  inc AttributeQuadrantNumber
  inc AttributeQuadrantNumber
@getAttributeColumn:
  tya ; x % 4
  and #%11
  cmp #2
  bcc @endGetQuadrantNumber
  inc AttributeQuadrantNumber
@endGetQuadrantNumber:

  lda PPU_STATUS

  lda AttributePointer+1
  sta PPU_VRAM_ADDR2
  lda AttributePointer
  sta PPU_VRAM_ADDR2
  
  ; Get existing attribute.
  lda PPU_VRAM_IO
  
  ldy #0
  sty AttributeTemp
  
  ldx AttributeQuadrantNumber
  beq @endShiftDownAttributesLoop
  
  clc
@shiftDownAttributesLoop:
  ror
  ror AttributeTemp
  ror
  ror AttributeTemp
  
  dex
  bne @shiftDownAttributesLoop
@endShiftDownAttributesLoop:
  
  and #%11111100
  ora _PrintColorSet

  ldx AttributeQuadrantNumber
  beq @endShiftUpAttributesLoop
  
  ;clc ; NOTE: Technially, no C clear needed.
@shiftUpAttributesLoop:
  rol AttributeTemp
  rol
  rol AttributeTemp
  rol
  
  dex
  bne @shiftUpAttributesLoop
@endShiftUpAttributesLoop:
  
  ldx PPU_STATUS
  
  ldx AttributePointer+1
  stx PPU_VRAM_ADDR2
  ldx AttributePointer
  stx PPU_VRAM_ADDR2
  
  sta PPU_VRAM_IO
  
  pla
  tay
  pla
  tax
  pla
  
  rts

; _DrawImage
; Prints text string to an X,Y coordinate on the screen.
;
; inputs:
;  - image: (sp[2],sp[1]), Pointer to an image map.
;  - x: sp[0], X position to draw image (uppler left corner).
;  - y: a, Y position to draw image (uppler left corner)
_DrawImage:
  sta tmp2 ; y
  
  clc ; (ptr+1,ptr)=&image
  lda #0
  ldy #1
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
  ldx tmp2 ; y

  lda ScreenLineOffsetTableHi,x
  sta ptr2+1
  lda ScreenLineOffsetTableLo,x
  sta ptr2
  
  ; Add x offset to screen start address.
  ldy #0 ; x
  lda (sp),y
  sta tmp1
  
  clc
  adc ptr2
  sta ptr2
  bcc @endBaseVramAddress
  lda #0
  adc ptr2+1
  sta ptr2+1
@endBaseVramAddress:

  lda PPU_STATUS

  ldx #0
@drawImageYLoop:
  lda ptr2+1
  sta PPU_VRAM_ADDR2
  lda ptr2
  sta PPU_VRAM_ADDR2
  
  ldy #$ff
@drawImageXLoop:
  iny
  cpy ImageWidth
  beq @drawImageXLoopEnd
  
  lda (ptr1),y
  sta PPU_VRAM_IO
  jmp @drawImageXLoop
@drawImageXLoopEnd:

  sty tmp3 ; index for loop.

  stx tmp4
  
  ldy tmp1 ; x
  ldx tmp2 ; y
@printColorLoop:
  jsr SetCharacterAttribute
  
  iny
  dec tmp3
  bne @printColorLoop
  
  ldx tmp4
  
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
  
  ; Move ptr2 to next line.
  clc
  lda ptr2
  adc #SCREEN_CHAR_WIDTH
  sta ptr2
  lda #0
  adc ptr2+1
  sta ptr2+1
  
  inc tmp2 ; ++y NOTE: Modifying cached y parameter.
  
  jmp @drawImageYLoop

@endDrawImage:
  jmp incsp3

;------------------------------------------------------------------
_ClearScreen:
  lda #' '
  jsr FillScreen
  
  rts
  
;------------------------------------------------------------------
FillScreen:
  ldy #>(PPU_NAME_TABLE_0+SCREEN_CHAR_WIDTH)
  sty PPU_VRAM_ADDR2
  sty ptr1+1
  ldy #<(PPU_NAME_TABLE_0+SCREEN_CHAR_WIDTH)
  sty PPU_VRAM_ADDR2
  sty ptr1
  
  ldy #0
@vramLoopY:
  ldx #0
@vramLoopX:
  sta PPU_VRAM_IO
  inx
  cpx #SCREEN_CHAR_WIDTH
  bne @vramLoopX
  iny
  cpy #(SCREEN_CHAR_HEIGHT-1)
  bne @vramLoopY
  
  rts
  
;------------------------------------------------------------------
; NOTE: This macro seems to compensate for non-visible top 1 line of name table.
.macro sloTable loOrHi, n
  .local lineNumber
  .if .paramcount > 1
    lineNumber = n
  .else
    lineNumber = 0
  .endif
  
  .local address
  address = (PPU_NAME_TABLE_0 + SCREEN_CHAR_WIDTH + (lineNumber * SCREEN_CHAR_WIDTH))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if lineNumber < SCREEN_CHAR_HEIGHT - 1
    sloTable loOrHi, (lineNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro

;------------------------------------------------------------------
; NOTE: This macro compensates for non-visible top 1 line of name table.
; TODO: Fix this macro to produce the table below!
.macro scloTable loOrHi, n
  .local lineNumber
  .if .paramcount > 1
    lineNumber = n
  .else
    lineNumber = 0
  .endif
  
  .local attributeLineWidth
  attributeLineWidth = SCREEN_CHAR_WIDTH / 4
  
  .local address
  address = (PPU_ATTRIBUTE_TABLE_0 + (((lineNumber + 1) / 4) * attributeLineWidth))

  .if loOrHi = 0
    .byte <(address)
  .endif
  
  .if loOrHi = 1
    .byte >(address)
  .endif
  
  .if lineNumber < SCREEN_CHAR_HEIGHT - 1
    scloTable loOrHi, (lineNumber+1) ; NOTE: Wrapping parameter in parentheses is critical (bug?).
  .endif
.endmacro


; Preprocessed table of PPU name table addresses for each start of a line.
ScreenLineOffsetTableLo:
  sloTable 0

ScreenLineOffsetTableHi:
  sloTable 1  

; Preprocessed table of PPU attribute table addresses for each start of a line.
ScreenColorLineOffsetTableLo:
  scloTable 0
  
; ScreenColorLineOffsetTableHi:
;   scloTable 1
  