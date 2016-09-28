; c64 music_engine.asm

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

.importzp Voice1ControlCache
.importzp Voice2ControlCache
.importzp Voice3ControlCache

.include "c64.asm"

NUMBER_OF_VOICES = 3

.segment "CODE"

; NOTE: Platform specific (C64).
NOTE_FREQ_1_C  =   536 ; C-1
NOTE_FREQ_1_CS =   568 ; C#-1
NOTE_FREQ_1_D  =   602 ; D-1
NOTE_FREQ_1_DS =   637 ; D#-1
NOTE_FREQ_1_E  =   675 ; E-1
NOTE_FREQ_1_F  =   716 ; F-1
NOTE_FREQ_1_FS =   758 ; F#-1
NOTE_FREQ_1_G  =   803 ; G-1
NOTE_FREQ_1_GS =   851 ; G#-1
NOTE_FREQ_1_A  =   902 ; A-1
NOTE_FREQ_1_AS =   955 ; A#-1
NOTE_FREQ_1_B  =  1012 ; B-1
NOTE_FREQ_2_C  =  1072 ; C-2
NOTE_FREQ_2_CS =  1136 ; C#-2
NOTE_FREQ_2_D  =  1204 ; D-2
NOTE_FREQ_2_DS =  1275 ; D#-2
NOTE_FREQ_2_E  =  1351 ; E-2
NOTE_FREQ_2_F  =  1432 ; F-2
NOTE_FREQ_2_FS =  1517 ; F#-2
NOTE_FREQ_2_G  =  1607 ; G-2
NOTE_FREQ_2_GS =  1703 ; G#-2
NOTE_FREQ_2_A  =  1804 ; A-2
NOTE_FREQ_2_AS =  1911 ; A#-2
NOTE_FREQ_2_B  =  2025 ; B-2
NOTE_FREQ_3_C  =  2145 ; C-3
NOTE_FREQ_3_CS =  2273 ; C#-3
NOTE_FREQ_3_D  =  2408 ; D-3
NOTE_FREQ_3_DS =  2551 ; D#-3
NOTE_FREQ_3_E  =  2703 ; E-3
NOTE_FREQ_3_F  =  2864 ; F-3
NOTE_FREQ_3_FS =  3034 ; F#-3
NOTE_FREQ_3_G  =  3215 ; G-3
NOTE_FREQ_3_GS =  3406 ; G#-3
NOTE_FREQ_3_A  =  3608 ; A-3
NOTE_FREQ_3_AS =  3823 ; A#-3
NOTE_FREQ_3_B  =  4050 ; B-3
NOTE_FREQ_4_C  =  4291 ; C-4
NOTE_FREQ_4_CS =  4547 ; C#-4
NOTE_FREQ_4_D  =  4817 ; D-4
NOTE_FREQ_4_DS =  5103 ; D#-4
NOTE_FREQ_4_E  =  5407 ; E-4
NOTE_FREQ_4_F  =  5728 ; F-4
NOTE_FREQ_4_FS =  6069 ; F#-4
NOTE_FREQ_4_G  =  6430 ; G-4
NOTE_FREQ_4_GS =  6812 ; G#-4
NOTE_FREQ_4_A  =  7217 ; A-4
NOTE_FREQ_4_AS =  7647 ; A#-4
NOTE_FREQ_4_B  =  8101 ; B-4
NOTE_FREQ_5_C  =  8583 ; C-5
NOTE_FREQ_5_CS =  9094 ; C#-5
NOTE_FREQ_5_D  =  9634 ; D-5
NOTE_FREQ_5_DS = 10207 ; D#-5
NOTE_FREQ_5_E  = 10814 ; E-5
NOTE_FREQ_5_F  = 11457 ; F-5
NOTE_FREQ_5_FS = 12139 ; F#-5
NOTE_FREQ_5_G  = 12860 ; G-5
NOTE_FREQ_5_GS = 13625 ; G#-5
NOTE_FREQ_5_A  = 14435 ; A-5
NOTE_FREQ_5_AS = 15294 ; A#-5
NOTE_FREQ_5_B  = 16203 ; B-5
NOTE_FREQ_6_C  = 17167 ; C-6
NOTE_FREQ_6_CS = 18188 ; C#-6
NOTE_FREQ_6_D  = 19269 ; D-6
NOTE_FREQ_6_DS = 20415 ; D#-6
NOTE_FREQ_6_E  = 21629 ; E-6
NOTE_FREQ_6_F  = 22915 ; F-6
NOTE_FREQ_6_FS = 24278 ; F#-6
NOTE_FREQ_6_G  = 25721 ; G-6
NOTE_FREQ_6_GS = 27251 ; G#-6
NOTE_FREQ_6_A  = 28871 ; A-6
NOTE_FREQ_6_AS = 30588 ; A#-6
NOTE_FREQ_6_B  = 32407 ; B-6

;---------------------------------------
; C64 specific.
MusicEngineV1FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV1FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV2FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV2FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV3FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV3FreqTableLo = MusicEngineNoteFreqTableLo1C

;---------------------------------------
TargetInitializeMusic:
  lda #$08        ; Set Voice2/3 Waveform (high nibble) to 8.
  sta SID_PB1Hi
  sta SID_PB2Hi
  sta SID_PB3Hi
  
  lda #$09        ; Set Voice1/2/3 decay 2ms / attack 250ms.
  sta SID_AD1
  sta SID_AD2
  sta SID_AD3
  
  lda #$40        ; Set Voice1/2/3 sustain 114ms / release 6ms.
  sta SID_SUR1
  sta SID_SUR2
  sta SID_SUR3
  
  lda #0
  sta SID_PB1Lo   ; Set Voice1/2/3 Waveform (low byte) to 0.
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

  lda #15         ; Set volume 15 (max).
  sta SID_Amp

  rts
  
;------------------------------------------------------------------
.macro setVoiceFrequencyV1
  ; Macro for voice 1 frequency load.
  lda MusicEngineV1FreqTableHi,x
  sta SID_S1Hi
  lda MusicEngineV1FreqTableLo,x
  sta SID_S1Lo
.endmacro

.macro setVoiceFrequencyV2
  ; Macro for voice 2 frequency load.
  lda MusicEngineV2FreqTableHi,x
  sta SID_S2Hi
  lda MusicEngineV2FreqTableLo,x
  sta SID_S2Lo
.endmacro

.macro setVoiceFrequencyV3
  ; Macro for voice 3 frequency load.
  lda MusicEngineV3FreqTableHi,x
  sta SID_S3Hi
  lda MusicEngineV3FreqTableLo,x
  sta SID_S3Lo
.endmacro

.macro disableVoice1
  ; Disable Voice 1.
  lda Voice1ControlCache
  and #%11111110
  sta SID_Ctl1
  sta Voice1ControlCache
.endmacro

.macro disableVoice2
  ; Disable Voice 2.
  lda Voice2ControlCache
  and #%11111110
  sta SID_Ctl2
  sta Voice2ControlCache
.endmacro

.macro disableVoice3
  ; Disable Voice 3.
  lda Voice3ControlCache
  and #%11111110
  sta SID_Ctl3
  sta Voice3ControlCache
.endmacro
  
.macro enableVoice1
  ; Gate Voice 1.
  lda Voice1ControlCache
  ora #%00000001
  sta SID_Ctl1
  sta Voice1ControlCache
.endmacro

.macro enableVoice2
  ; Gate Voice 2.
  lda Voice2ControlCache
  ora #%00000001
  sta SID_Ctl2
  sta Voice2ControlCache
.endmacro

.macro enableVoice3
  ; Gate Voice 3.
  lda Voice3ControlCache
  ora #%00000001
  sta SID_Ctl3
  sta Voice3ControlCache
.endmacro

.include "../base/music_engine.asm"
