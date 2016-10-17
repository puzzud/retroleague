; apple2enh music_engine.asm

.export _ProcessTone

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

.importzp Voice1ControlCache
.importzp Voice2ControlCache
.importzp Voice3ControlCache

.include "apple2.asm"

NUMBER_OF_VOICES = 3

.segment "ZEROPAGE"

MusicEngineV1SpeakerDelayLo:
  .res 1
  
MusicEngineV1SpeakerDelayHi:
  .res 1

.segment "CODE"

; NOTE: Platform specific (NES?).
NOTE_FREQ_1_C  = 976 ; C-1
NOTE_FREQ_1_CS = 921 ; C#-1
NOTE_FREQ_1_D  = 869 ; D-1
NOTE_FREQ_1_DS = 821 ; D#-1
NOTE_FREQ_1_E  = 774 ; E-1
NOTE_FREQ_1_F  = 731 ; F-1
NOTE_FREQ_1_FS = 690 ; F#-1
NOTE_FREQ_1_G  = 651 ; G-1
NOTE_FREQ_1_GS = 614 ; G#-1
NOTE_FREQ_1_A  = 580 ; A-1
NOTE_FREQ_1_AS = 547 ; A#-1
NOTE_FREQ_1_B  = 516 ; B-1
NOTE_FREQ_2_C  = 487 ; C-2
NOTE_FREQ_2_CS = 460 ; C#-2
NOTE_FREQ_2_D  = 434 ; D-2
NOTE_FREQ_2_DS = 410 ; D#-2
NOTE_FREQ_2_E  = 386 ; E-2
NOTE_FREQ_2_F  = 365 ; F-2
NOTE_FREQ_2_FS = 344 ; F#-2
NOTE_FREQ_2_G  = 325 ; G-2
NOTE_FREQ_2_GS = 306 ; G#-2
NOTE_FREQ_2_A  = 289 ; A-2
NOTE_FREQ_2_AS = 273 ; A#-2
NOTE_FREQ_2_B  = 257 ; B-2
NOTE_FREQ_3_C  = 243 ; C-3
NOTE_FREQ_3_CS = 229 ; C#-3
NOTE_FREQ_3_D  = 216 ; D-3
NOTE_FREQ_3_DS = 204 ; D#-3
NOTE_FREQ_3_E  = 192 ; E-3
NOTE_FREQ_3_F  = 182 ; F-3
NOTE_FREQ_3_FS = 171 ; F#-3
NOTE_FREQ_3_G  = 162 ; G-3
NOTE_FREQ_3_GS = 152 ; G#-3
NOTE_FREQ_3_A  = 144 ; A-3
NOTE_FREQ_3_AS = 136 ; A#-3
NOTE_FREQ_3_B  = 128 ; B-3
NOTE_FREQ_4_C  = 121 ; C-4
NOTE_FREQ_4_CS = 114 ; C#-4
NOTE_FREQ_4_D  = 107 ; D-4
NOTE_FREQ_4_DS = 101 ; D#-4
NOTE_FREQ_4_E  = 95 ; E-4
NOTE_FREQ_4_F  = 90 ; F-4
NOTE_FREQ_4_FS = 85 ; F#-4
NOTE_FREQ_4_G  = 80 ; G-4
NOTE_FREQ_4_GS = 75 ; G#-4
NOTE_FREQ_4_A  = 71 ; A-4
NOTE_FREQ_4_AS = 67 ; A#-4
NOTE_FREQ_4_B  = 63 ; B-4
NOTE_FREQ_5_C  = 60 ; C-5
NOTE_FREQ_5_CS = 56 ; C#-5
NOTE_FREQ_5_D  = 53 ; D-5
NOTE_FREQ_5_DS = 50 ; D#-5
NOTE_FREQ_5_E  = 47 ; E-5
NOTE_FREQ_5_F  = 44 ; F-5
NOTE_FREQ_5_FS = 42 ; F#-5
NOTE_FREQ_5_G  = 39 ; G-5
NOTE_FREQ_5_GS = 37 ; G#-5
NOTE_FREQ_5_A  = 35 ; A-5
NOTE_FREQ_5_AS = 33 ; A#-5
NOTE_FREQ_5_B  = 31 ; B-5
NOTE_FREQ_6_C  = 29 ; C-6
NOTE_FREQ_6_CS = 27 ; C#-6
NOTE_FREQ_6_D  = 26 ; D-6
NOTE_FREQ_6_DS = 24 ; D#-6
NOTE_FREQ_6_E  = 23 ; E-6
NOTE_FREQ_6_F  = 21 ; F-6
NOTE_FREQ_6_FS = 20 ; F#-6
NOTE_FREQ_6_G  = 19 ; G-6
NOTE_FREQ_6_GS = 18 ; G#-6
NOTE_FREQ_6_A  = 17 ; A-6
NOTE_FREQ_6_AS = 16 ; A#-6
NOTE_FREQ_6_B  = 15 ; B-6

;---------------------------------------
MusicEngineV1FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV1FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV2FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV2FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV3FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV3FreqTableLo = MusicEngineNoteFreqTableLo1C
  
;------------------------------------------------------------------
.macro setVoiceFrequencyV1
  ; Macro for voice 1 frequency load.
  lda MusicEngineV1FreqTableLo,x
  sta MusicEngineV1SpeakerDelayLo
  lda MusicEngineV1FreqTableHi,x
  sta MusicEngineV1SpeakerDelayHi
.endmacro

.macro setVoiceFrequencyV2
  ; Macro for voice 2 frequency load.
.endmacro

.macro setVoiceFrequencyV3
  ; Macro for voice 3 frequency load.
.endmacro

.macro disableVoice1
  ; Disable Voice 1.
  lda #0
  sta MusicEngineV1SpeakerDelayLo
  sta MusicEngineV1SpeakerDelayHi
.endmacro

.macro disableVoice2
  ; Disable Voice 2.
.endmacro

.macro disableVoice3
  ; Disable Voice 3.
.endmacro
  
.macro enableVoice1
  ; Gate Voice 1.
.endmacro

.macro enableVoice2
  ; Gate Voice 2.
.endmacro

.macro enableVoice3
  ; Gate Voice 3.
.endmacro

.include "../base/music_engine.asm"

.segment "ZEROPAGE"

.segment "CODE"

;------------------------------------------------------------------
_ProcessTone:
  lda MusicEngineV1SpeakerDelayLo
  ora MusicEngineV1SpeakerDelayHi
  beq @endPlayTone
  
  ; Set pitch.
  ldx MusicEngineV1SpeakerDelayHi
  stx tmp2
  ldx MusicEngineV1SpeakerDelayLo
  
  ; Set duration.
  ldy #3
  sty tmp1
  
@playToneLoop:
  lda SPEAKER
  
@playToneDelay:
  dey
  bne @decrementDelay
  
  dec tmp1
  beq @endPlayTone

@decrementDelay:
  dex
  beq @endDecrementDelay
  cpx #$ff
  bne @endDecrementDelay
  lda tmp2
  beq @endDecrementDelay
  dec tmp2
@endDecrementDelay:

  txa
  ora tmp2
  bne @playToneDelay
  
@blah:
  lda MusicEngineV1SpeakerDelayHi
  sta tmp2
  ldx MusicEngineV1SpeakerDelayLo
  jmp @playToneLoop
  
@endPlayTone:
  rts
