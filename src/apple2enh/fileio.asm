; apple2enh fileio.asm

.export _LoadFile

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.include "apple2.asm"

.segment "ZEROPAGE"

.segment "BSS"

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
  
  jmp incsp4
