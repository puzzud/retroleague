; c64 audio.asm

.export _InitializeAudio
.export _SoundKillAll

.exportzp Voice1ControlCache
.exportzp Voice2ControlCache
.exportzp Voice3ControlCache

.include "c64.asm"

.segment "ZEROPAGE"

; Caching of gating / waveform type SID registers
; for each voice, because reading from them
; is apparently unreliable.
Voice1ControlCache:
  .res 1
  
Voice2ControlCache:
  .res 1
  
Voice3ControlCache:
  .res 1

.segment "CODE"

;------------------------------------------------------------------
_InitializeAudio:
InitializeAudio:
  rts

;------------------------------------------------------------------
_SoundKillAll:
SoundKillAll:
  lda #0
  tax
@loop1:
  sta SID_S1Lo,x
  inx
  cpx #14
  bne @loop1

  ldx #2
@loop2:
  sta SID_FltLo,x
  dex
  bpl @loop2
  
  rts
