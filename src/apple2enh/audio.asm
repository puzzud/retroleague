; apple2enh audio.asm

.import _InitializeMusicEngine

.export _InitializeAudio
.export _SoundKillAll

.exportzp Voice1ControlCache

.include "apple2.asm"

.segment "ZEROPAGE"

Voice1ControlCache:
  .res 1

.segment "CODE"

;------------------------------------------------------------------
_InitializeAudio:
InitializeAudio:
  jsr InitializeVoices
  jsr _InitializeMusicEngine

  rts

;------------------------------------------------------------------
InitializeVoices:
  rts
  
;------------------------------------------------------------------
_SoundKillAll:
SoundKillAll:
  lda #0
  sta Voice1ControlCache
  
  rts
