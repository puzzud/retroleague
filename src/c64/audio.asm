; c64 audio.asm

.import _InitializeMusicEngine

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
  jsr InitializeVoices
  jsr _InitializeMusicEngine

  rts

;------------------------------------------------------------------
InitializeVoices:
  ; Set Voice2/3 Waveform (high nibble) to 8.
  lda #$08
  sta SID_PB1Hi
  sta SID_PB2Hi
  sta SID_PB3Hi
  
  ; Set Voice1/2/3 decay 2ms / attack 250ms.
  lda #$09
  sta SID_AD1
  sta SID_AD2
  sta SID_AD3
  
  ; Set Voice1/2/3 sustain 114ms / release 6ms.
  lda #$40
  sta SID_SUR1
  sta SID_SUR2
  sta SID_SUR3
  
  ; Set Voice1/2/3 Waveform (low byte) to 0.
  lda #0
  sta SID_PB1Lo
  sta SID_PB2Lo
  sta SID_PB3Lo

  ; Gate all Voices silent.
  ; Also, set their waveforms.
  lda #%01000000 ; pulse
  
  sta SID_Ctl1
  sta Voice1ControlCache
  
  sta SID_Ctl2
  sta Voice2ControlCache
  
  lda #%00010000 ; triangle
  sta SID_Ctl3
  sta Voice3ControlCache

  ; Set volume 15 (max).
  lda #15
  sta SID_Amp

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
