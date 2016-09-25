; c64 fileio.asm

.export _LoadFile

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.include "c64.inc"

.segment "ZEROPAGE"

; Reserve kernal zeropage RAM.
; TODO: This block could probably be reduced,
; given some investigation.
.org $90
  .res $fb-$90+1
.reloc

.segment "BSS"

.org $314
  .res $0332-$0314+2
.reloc

FileNameCache:
  .res 16

.segment "CODE"

; _LoadFile
; Loads a file by name to a specific address.
;
; inputs:
;  - fileName: (sp[3],sp[2]), Pointer to a file name string.
;  - address: (x,a), Pointer to a location to load file data.
_LoadFile:
  jsr pushax
    
  ; (ptr1)=fileName
  ldy #3
  jsr ldaxysp
  sta ptr1
  stx ptr1+1
  
  ; (ptr2)=address
  jsr ldax0sp
  sta ptr2
  stx ptr2+1

  ; (ptr3)=FileNameCache
  lda #<FileNameCache
  sta ptr3
  lda #>FileNameCache
  sta ptr3+1
  
  ldy #$ff
@getFileNameLength:
  iny
  lda (ptr1),y
  sta (ptr3),y
  bne @getFileNameLength
  iny
  lda #0
  sta (ptr3),y
  dey

  sei
  
  lda VIC_IMR
  pha
  and #%11111110
  sta VIC_IMR
  
  lda LORAM
  pha
  ora #%00000010
  sta LORAM
  
  cli
  
  lda #0
  jsr $ff90
  
  ;lda #$7f  ;suppress any irq&nmi
  ;sta $dc0d ;to disallow abort load by R/S
  ;sta $dc0e
  ;jsr $ff8a
  
  ; Set (fileName, A = string length)
  tya
  ldx #<FileNameCache
  ldy #>FileNameCache
  jsr $ffbd     ; call SETNAM
  
  ; Device (number).
  lda #1        ; file number
  ldx $ba       ; last used device number
  bne @skipDefaultDeviceNumber
  ldx #8        ; default to device 8
@skipDefaultDeviceNumber:
  ldy #0        ; 0 means: load to new address
  jsr $ffba     ; call SETLFS
  
  ; Load (address).
  ; TODO: Figure out why the write address needs to be incremented by 2.
  clc
  lda ptr2
  adc #2
  tax
  lda #0
  adc ptr2+1
  tay
  lda #0        ; 0 means: load to memory (not verify)
  jsr $ffd5     ; call LOAD
  
  bcs @error    ; if carry set, a load error has happened
  bcc @endLoadFile
@error:
  ; Accumulator contains BASIC error code

  ; most likely errors:
  ; A = $05 (DEVICE NOT PRESENT)
  ; A = $04 (FILE NOT FOUND)
  ; A = $1D (LOAD ERROR)
  ; A = $00 (BREAK, RUN/STOP has been pressed during loading)

  sta VIC_BG_COLOR0
  
@endLoadFile:
  lda #1    ; file number
  jsr $ffc3 ; call CLOSE
  
  sei

  pla
  sta LORAM

  pla
  sta VIC_IMR

  cli
  
  jmp incsp4
