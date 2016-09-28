; nes audio.asm

.export _InitializeAudio
.export _SoundKillAll

.exportzp Pulse1ControlCache
.exportzp Pulse2ControlCache
.exportzp TriangleControlCache

.include "nes.asm"

.segment "ZEROPAGE"

; NES specific APU register caches
; (since they cannot be read?).
Pulse1ControlCache:
  .res 1
  
Pulse2ControlCache:
  .res 1
  
TriangleControlCache:
  .res 1

.segment "CODE"

;------------------------------------------------------------------
_InitializeAudio:
InitializeAudio:
  lda #%01111111
  sta APU_CHANCTRL
  
  rts

;------------------------------------------------------------------
_SoundKillAll:
SoundKillAll:
  lda Pulse1ControlCache
  and #%00001111
  sta APU_PULSE1CTRL
  sta Pulse1ControlCache
  
  lda Pulse2ControlCache
  and #%00001111
  sta APU_PULSE2CTRL
  sta Pulse2ControlCache
  
  lda TriangleControlCache
  and #%00000000
  sta APU_TRICTRL1
  sta TriangleControlCache
  
  rts
