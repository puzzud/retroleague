; nes video.asm

.export _PrintText

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.include "nes.inc"

.segment "ZEROPAGE"

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
