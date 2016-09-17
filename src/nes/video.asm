; nes video.asm

.export _PrintText
.export _DrawImage

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.include "nes.inc"

.segment "ZEROPAGE"

ImageWidth:
  .res 1
  
ImageHeight:
  .res 1

.segment "CODE"

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
  bcc @setVramAddress
  lda #0
  adc ptr2+1
  sta ptr2+1

@setVramAddress:  
  lda ptr2+1
  sta PPU_VRAM_ADDR2
  lda ptr2
  sta PPU_VRAM_ADDR2
  
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
  lda (ptr1),y ; PPU_VRAM_IO=a=text[++y]
  sta PPU_VRAM_IO
  bne @printTextLoop
  
  ; A = 0
  sta PPU_VRAM_ADDR2
  sta PPU_VRAM_ADDR2
  sta PPU_VRAM_ADDR1
  sta PPU_VRAM_ADDR1

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
  bcc @endBaseVramAddress
  lda #0
  adc ptr2+1
  sta ptr2+1
@endBaseVramAddress:

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
  
  jmp @drawImageYLoop

@endDrawImage:
  jmp incsp4
  
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

; Preprocessed table of PPU name table addresses for each start of a line.
ScreenLineOffsetTableLo:
  sloTable 0

ScreenLineOffsetTableHi:
  sloTable 1
