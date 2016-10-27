.import _Init

.import _LoadFile
.import _CHARSET

.import _UpdateInput
.import _InitializeVideo

.import _ProcessMusic
.import _ProcessTone

.importzp _MusicStatus

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.importzp sp
.import __BSS_START__, __BSS_SIZE__

.export Reset

.exportzp _InitScreen
.exportzp _CurrentScreenInit
.exportzp _CurrentScreenUpdate

.include "apple2.asm"

.segment "ZEROPAGE"

_InitScreen:
  .res 1
  
_CurrentScreenInit:
  .res 2
  
_CurrentScreenUpdate:
  .res 2

.segment "BSS"

.segment "CODE"

Reset:
  sei

  ; Set parameter stack pointer.
  lda #<(__BSS_START__+__BSS_SIZE__)
  sta sp
  lda #>(__BSS_START__+__BSS_SIZE__)
  sta sp+1

  jsr _InitializeVideo
  jsr _InitializeAudio

  cli

  jsr _Init
  
@mainLoop:
  jsr _UpdateInput
  
@waitFrame:
  lda RDVBLBAR
  bmi @waitFrame

  lda _InitScreen
  beq @endInit
  
  lda #>(@postInit-1)
  pha
  lda #<(@postInit-1)
  pha
  jmp (_CurrentScreenInit)
@postInit:
  lda #0
  sta _InitScreen
@endInit:
  
  lda #>(@endUpdate-1)
  pha
  lda #<(@endUpdate-1)
  pha
  jmp (_CurrentScreenUpdate)
@endUpdate:
  
  lda _MusicStatus
  beq @endProcessMusic
  jsr _ProcessMusic
  jsr _ProcessTone
@endProcessMusic:
  
  jmp @mainLoop
