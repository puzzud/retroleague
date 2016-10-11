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
NOTE_FREQ_1_C  = 3419 ; C-1
NOTE_FREQ_1_CS = 3227 ; C#-1
NOTE_FREQ_1_D  = 3046 ; D-1
NOTE_FREQ_1_DS = 2875 ; D#-1
NOTE_FREQ_1_E  = 2714 ; E-1
NOTE_FREQ_1_F  = 2561 ; F-1
NOTE_FREQ_1_FS = 2417 ; F#-1
NOTE_FREQ_1_G  = 2281 ; G-1
NOTE_FREQ_1_GS = 2153 ; G#-1
NOTE_FREQ_1_A  = 2032 ; A-1
NOTE_FREQ_1_AS = 1918 ; A#-1
NOTE_FREQ_1_B  = 1810 ; B-1
NOTE_FREQ_2_C  = 1709 ; C-2
NOTE_FREQ_2_CS = 1613 ; C#-2
NOTE_FREQ_2_D  = 1522 ; D-2
NOTE_FREQ_2_DS = 1437 ; D#-2
NOTE_FREQ_2_E  = 1356 ; E-2
NOTE_FREQ_2_F  = 1280 ; F-2
NOTE_FREQ_2_FS = 1208 ; F#-2
NOTE_FREQ_2_G  = 1140 ; G-2
NOTE_FREQ_2_GS = 1076 ; G#-2
NOTE_FREQ_2_A  = 1015 ; A-2
NOTE_FREQ_2_AS = 958  ; A#-2
NOTE_FREQ_2_B  = 904  ; B-2
NOTE_FREQ_3_C  = 854  ; C-3
NOTE_FREQ_3_CS = 806  ; C#-3
NOTE_FREQ_3_D  = 760  ; D-3
NOTE_FREQ_3_DS = 718  ; D#-3
NOTE_FREQ_3_E  = 677  ; E-3
NOTE_FREQ_3_F  = 639  ; F-3
NOTE_FREQ_3_FS = 603  ; F#-3
NOTE_FREQ_3_G  = 569  ; G-3
NOTE_FREQ_3_GS = 537  ; G#-3
NOTE_FREQ_3_A  = 507  ; A-3
NOTE_FREQ_3_AS = 478  ; A#-3
NOTE_FREQ_3_B  = 451  ; B-3
NOTE_FREQ_4_C  = 426  ; C-4
NOTE_FREQ_4_CS = 402  ; C#-4
NOTE_FREQ_4_D  = 379  ; D-4
NOTE_FREQ_4_DS = 358  ; D#-4
NOTE_FREQ_4_E  = 338  ; E-4
NOTE_FREQ_4_F  = 319  ; F-4
NOTE_FREQ_4_FS = 301  ; F#-4
NOTE_FREQ_4_G  = 284  ; G-4
NOTE_FREQ_4_GS = 268  ; G#-4
NOTE_FREQ_4_A  = 253  ; A-4
NOTE_FREQ_4_AS = 238  ; A#-4
NOTE_FREQ_4_B  = 225  ; B-4
NOTE_FREQ_5_C  = 212  ; C-5
NOTE_FREQ_5_CS = 200  ; C#-5
NOTE_FREQ_5_D  = 189  ; D-5
NOTE_FREQ_5_DS = 178  ; D#-5
NOTE_FREQ_5_E  = 168  ; E-5
NOTE_FREQ_5_F  = 159  ; F-5
NOTE_FREQ_5_FS = 150  ; F#-5
NOTE_FREQ_5_G  = 141  ; G-5
NOTE_FREQ_5_GS = 133  ; G#-5
NOTE_FREQ_5_A  = 126  ; A-5
NOTE_FREQ_5_AS = 118  ; A#-5
NOTE_FREQ_5_B  = 112  ; B-5
NOTE_FREQ_6_C  = 105  ; C-6
NOTE_FREQ_6_CS = 99   ; C#-6
NOTE_FREQ_6_D  = 94   ; D-6
NOTE_FREQ_6_DS = 88   ; D#-6
NOTE_FREQ_6_E  = 83   ; E-6
NOTE_FREQ_6_F  = 79   ; F-6
NOTE_FREQ_6_FS = 74   ; F#-6
NOTE_FREQ_6_G  = 70   ; G-6
NOTE_FREQ_6_GS = 66   ; G#-6
NOTE_FREQ_6_A  = 62   ; A-6
NOTE_FREQ_6_AS = 58   ; A#-6
NOTE_FREQ_6_B  = 55   ; B-6

;---------------------------------------
MusicEngineV1FreqTableHi = MusicEngineNoteFreqTableHi2C
MusicEngineV1FreqTableLo = MusicEngineNoteFreqTableLo2C

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

;------------------------------------------------------------------
_ProcessTone:
  lda MusicEngineV1SpeakerDelayLo
  ora MusicEngineV1SpeakerDelayHi
  beq @endPlayTone
  
  ; Set duration
  ldx #4
  
@playToneLoop:
  ; Load wavelength / pitch.
  ldy MusicEngineV1SpeakerDelayHi
  sty tmp1
  ldy MusicEngineV1SpeakerDelayLo
  
  lda SPEAKER
  
@playToneDelay:
  dey
  beq @endDecrementDelay
  cpy #$ff
  bne @endDecrementDelay
  dec tmp1
@endDecrementDelay:

  tya
  ora tmp1
  bne @playToneDelay

  dex
  bne @playToneLoop
  
@endPlayTone:
  rts
