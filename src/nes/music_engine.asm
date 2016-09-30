; nes music_engine.asm

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4

.importzp Pulse1ControlCache
.importzp Pulse2ControlCache
.importzp TriangleControlCache

.include "nes.asm"

NUMBER_OF_VOICES = 3

.segment "CODE"

; NOTE: Platform specific (NES).
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
; NES specific (accounts for lower triangle voice).
MusicEngineV1FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV1FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV2FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV2FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV3FreqTableHi = MusicEngineNoteFreqTableHi2C
MusicEngineV3FreqTableLo = MusicEngineNoteFreqTableLo2C

;------------------------------------------------------------------
.macro setVoiceFrequencyV1
  ; Macro for voice 1 frequency load.
  lda MusicEngineV1FreqTableHi,x
  sta APU_PULSE1CTUNE
  lda MusicEngineV1FreqTableLo,x
  sta APU_PULSE1FTUNE
.endmacro

.macro setVoiceFrequencyV2
  ; Macro for voice 2 frequency load.
  lda MusicEngineV2FreqTableHi,x
  sta APU_PULSE2CTUNE
  lda MusicEngineV2FreqTableLo,x
  sta APU_PULSE2FTUNE
.endmacro

.macro setVoiceFrequencyV3
  ; Macro for voice 3 frequency load.
  lda MusicEngineV3FreqTableHi,x
  sta APU_TRIFREQ2
  lda MusicEngineV3FreqTableLo,x
  sta APU_TRIFREQ1
.endmacro

.macro disableVoice1
  ; Disable Voice 1.
  lda Pulse1ControlCache
  and #%11110000
  sta APU_PULSE1CTRL
  sta Pulse1ControlCache
.endmacro

.macro disableVoice2
  ; Disable Voice 2.
  lda Pulse2ControlCache
  and #%11110000
  sta APU_PULSE2CTRL
  sta Pulse2ControlCache
.endmacro

.macro disableVoice3
  ; Disable Voice 3.
  lda TriangleControlCache
  and #%10000000
  sta APU_TRICTRL1
  sta TriangleControlCache
.endmacro
  
.macro enableVoice1
  ; Gate Voice 1.
  lda Pulse1ControlCache
  ora #%00001111
  sta APU_PULSE1CTRL
  sta Pulse1ControlCache
.endmacro

.macro enableVoice2
  ; Gate Voice 2.
  lda Pulse2ControlCache
  ora #%00001111
  sta APU_PULSE2CTRL
  sta Pulse2ControlCache
.endmacro

.macro enableVoice3
  ; Gate Voice 3.
  lda TriangleControlCache
  ora #%10000001
  sta APU_TRICTRL1
  sta TriangleControlCache
.endmacro

.include "../base/music_engine.asm"
