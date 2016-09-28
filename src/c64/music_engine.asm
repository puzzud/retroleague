; c64 music_engine.asm

.export _InitializeMusic
.export _ProcessMusic

.export _MusicEngineV1MusicStart
.export _MusicEngineV1MusicEnd
.export _MusicEngineV2MusicStart
.export _MusicEngineV2MusicEnd
.export _MusicEngineV3MusicStart
.export _MusicEngineV3MusicEnd

.export _MusicEngineV1TimeToRelease
.export _MusicEngineV2TimeToRelease
.export _MusicEngineV3TimeToRelease

.autoimport on
  
.importzp sp, sreg, regsave, regbank
.importzp tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack longbranch

.import _SoundKillAll

.import VOICE_1_START_1
.import VOICE_1_END_1
.import VOICE_2_START_1
.import VOICE_2_END_1
.import VOICE_3_START_1
.import VOICE_3_END_1

.include "c64.asm"

NUMBER_OF_VOICES = 3

.segment "BSS"

_MusicEngineV1MusicStart:
MusicEngineV1MusicStart:
  .res 2

_MusicEngineV1MusicEnd:
MusicEngineV1MusicEnd:
  .res 2

_MusicEngineV2MusicStart:
MusicEngineV2MusicStart:
  .res 2

_MusicEngineV2MusicEnd:
MusicEngineV2MusicEnd:
  .res 2

_MusicEngineV3MusicStart:
MusicEngineV3MusicStart:
  .res 2

_MusicEngineV3MusicEnd:
MusicEngineV3MusicEnd:
  .res 2

_MusicEngineV1TimeToRelease:
MusicEngineV1TimeToRelease:
  .res 1

_MusicEngineV2TimeToRelease:
MusicEngineV2TimeToRelease:
  .res 1

_MusicEngineV3TimeToRelease:
MusicEngineV3TimeToRelease:
  .res 1

.segment "ZEROPAGE"

MusicEngineV1Position:
  .res 2
  
MusicEngineV2Position:
  .res 2
  
MusicEngineV3Position:
  .res 2

MusicEngineV1Duration:
  .res 1

MusicEngineV2Duration:
  .res 1

MusicEngineV3Duration:
  .res 1

MusicEngineV1Active:
  .res 1

MusicEngineV2Active:
  .res 1

MusicEngineV3Active:
  .res 1

MusicEngineV1TimeToReleaseCounter:
  .res 1

MusicEngineV2TimeToReleaseCounter:
  .res 1

MusicEngineV3TimeToReleaseCounter:
  .res 1

MusicEngineV1DurationCounter:
  .res 1

MusicEngineV2DurationCounter:
  .res 1

MusicEngineV3DurationCounter:
  .res 1

MusicEngineTempFetch:
  .res 1
  
; C64 MULE music engine.
;
; It provides the following major routines:
; _InitializeMusic
; _ProcessMusic

; The encoding for the music is as follows:
; - The first byte fetched will always contain an index to a note table, based on the lower 6 bits.
; - The first byte's 7th bit indicates a duration change (how much music time this byte takes up).
;   - If a duration change is indicated, a second byte is fetched.
;   - The second byte's value acts as a delay (duration) counter, which is decremented every music engine frame.
;   - While this duration counter is positive, no more bytes from the corresponding voice's music data are processed.
;   - Once the duration is zero (non-positive), music data fetching commences, restarting the cycle with the first byte fetch.
; - The first byte's 6th bit indicates a voice gate change.
;   - High will start the silencing or release of the voice.
;   - Low will either start the voice attack or will maintain the voice's active status.
; - Unless a duration change is made, all byte fetches are considered the 'first' byte.

; - Durations:
;   - $0c: 1/8 note.
;   - $c0: 8 beats rest.
NOTE_LENGTH_1_96TH = 1
NOTE_LENGTH_1_32ND = NOTE_LENGTH_1_96TH * 3 ; 3
NOTE_LENGTH_1_16TH = NOTE_LENGTH_1_32ND * 2 ; 6
NOTE_LENGTH_1_8TH  = NOTE_LENGTH_1_16TH * 2 ; 12
NOTE_LENGTH_1_4TH  = NOTE_LENGTH_1_8TH  * 2 ; 24
NOTE_LENGTH_1_HALF = NOTE_LENGTH_1_4TH  * 2 ; 48
NOTE_LENGTH_1      = NOTE_LENGTH_1_HALF * 2 ; 96

NOTE_CONTROL_LENGTH = %10000000
NOTE_CONTROL_GATE   = %01000000

; Note tables:
NOTE_C  = 0
NOTE_CS = 1
NOTE_D  = 2
NOTE_DS = 3
NOTE_E  = 4
NOTE_F  = 5
NOTE_FS = 6
NOTE_G  = 7
NOTE_GS = 8
NOTE_A  = 9
NOTE_AS = 10
NOTE_B  = 11

NUMBER_OF_NOTES_IN_OCTAVE = 12
OCTAVE = NUMBER_OF_NOTES_IN_OCTAVE

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

MusicEngineNoteFreqTableHi1C:
  .byte >NOTE_FREQ_1_C
  .byte >NOTE_FREQ_1_CS
  .byte >NOTE_FREQ_1_D
  .byte >NOTE_FREQ_1_DS
  .byte >NOTE_FREQ_1_E
  .byte >NOTE_FREQ_1_F
  .byte >NOTE_FREQ_1_FS
  .byte >NOTE_FREQ_1_G
  .byte >NOTE_FREQ_1_GS
  .byte >NOTE_FREQ_1_A
  .byte >NOTE_FREQ_1_AS
  .byte >NOTE_FREQ_1_B
  .byte >NOTE_FREQ_2_C
  .byte >NOTE_FREQ_2_CS
  .byte >NOTE_FREQ_2_D
  .byte >NOTE_FREQ_2_DS
  .byte >NOTE_FREQ_2_E
  .byte >NOTE_FREQ_2_F
  .byte >NOTE_FREQ_2_FS
  .byte >NOTE_FREQ_2_G
  .byte >NOTE_FREQ_2_GS
  .byte >NOTE_FREQ_2_A
  .byte >NOTE_FREQ_2_AS
  .byte >NOTE_FREQ_2_B      
  .byte >NOTE_FREQ_3_C
  .byte >NOTE_FREQ_3_CS
  .byte >NOTE_FREQ_3_D
  .byte >NOTE_FREQ_3_DS
  .byte >NOTE_FREQ_3_E
  .byte >NOTE_FREQ_3_F
  .byte >NOTE_FREQ_3_FS
  .byte >NOTE_FREQ_3_G
  .byte >NOTE_FREQ_3_GS
  .byte >NOTE_FREQ_3_A
  .byte >NOTE_FREQ_3_AS
  .byte >NOTE_FREQ_3_B
  .byte >NOTE_FREQ_4_C
  .byte >NOTE_FREQ_4_CS
  .byte >NOTE_FREQ_4_D
  .byte >NOTE_FREQ_4_DS
  .byte >NOTE_FREQ_4_E
  .byte >NOTE_FREQ_4_F
  .byte >NOTE_FREQ_4_FS
  .byte >NOTE_FREQ_4_G
  .byte >NOTE_FREQ_4_GS
  .byte >NOTE_FREQ_4_A
  .byte >NOTE_FREQ_4_AS
  .byte >NOTE_FREQ_4_B
  .byte >NOTE_FREQ_5_C
  .byte >NOTE_FREQ_5_CS
  .byte >NOTE_FREQ_5_D
  .byte >NOTE_FREQ_5_DS
  .byte >NOTE_FREQ_5_E
  .byte >NOTE_FREQ_5_F
  .byte >NOTE_FREQ_5_FS
  .byte >NOTE_FREQ_5_G
  .byte >NOTE_FREQ_5_GS
  .byte >NOTE_FREQ_5_A
  .byte >NOTE_FREQ_5_AS
  .byte >NOTE_FREQ_5_B
  .byte >NOTE_FREQ_6_C
  .byte >NOTE_FREQ_6_CS
  .byte >NOTE_FREQ_6_D
  .byte >NOTE_FREQ_6_DS
  .byte >NOTE_FREQ_6_E
  .byte >NOTE_FREQ_6_F
  .byte >NOTE_FREQ_6_FS
  .byte >NOTE_FREQ_6_G
  .byte >NOTE_FREQ_6_GS
  .byte >NOTE_FREQ_6_A
  .byte >NOTE_FREQ_6_AS
  .byte >NOTE_FREQ_6_B

MusicEngineNoteFreqTableLo1C:
  .byte <NOTE_FREQ_1_C
  .byte <NOTE_FREQ_1_CS
  .byte <NOTE_FREQ_1_D
  .byte <NOTE_FREQ_1_DS
  .byte <NOTE_FREQ_1_E
  .byte <NOTE_FREQ_1_F
  .byte <NOTE_FREQ_1_FS
  .byte <NOTE_FREQ_1_G
  .byte <NOTE_FREQ_1_GS
  .byte <NOTE_FREQ_1_A
  .byte <NOTE_FREQ_1_AS
  .byte <NOTE_FREQ_1_B
  .byte <NOTE_FREQ_2_C
  .byte <NOTE_FREQ_2_CS
  .byte <NOTE_FREQ_2_D
  .byte <NOTE_FREQ_2_DS
  .byte <NOTE_FREQ_2_E
  .byte <NOTE_FREQ_2_F
  .byte <NOTE_FREQ_2_FS
  .byte <NOTE_FREQ_2_G
  .byte <NOTE_FREQ_2_GS
  .byte <NOTE_FREQ_2_A
  .byte <NOTE_FREQ_2_AS
  .byte <NOTE_FREQ_2_B 
  .byte <NOTE_FREQ_3_C
  .byte <NOTE_FREQ_3_CS
  .byte <NOTE_FREQ_3_D
  .byte <NOTE_FREQ_3_DS
  .byte <NOTE_FREQ_3_E
  .byte <NOTE_FREQ_3_F
  .byte <NOTE_FREQ_3_FS
  .byte <NOTE_FREQ_3_G
  .byte <NOTE_FREQ_3_GS
  .byte <NOTE_FREQ_3_A
  .byte <NOTE_FREQ_3_AS
  .byte <NOTE_FREQ_3_B
  .byte <NOTE_FREQ_4_C
  .byte <NOTE_FREQ_4_CS
  .byte <NOTE_FREQ_4_D
  .byte <NOTE_FREQ_4_DS
  .byte <NOTE_FREQ_4_E
  .byte <NOTE_FREQ_4_F
  .byte <NOTE_FREQ_4_FS
  .byte <NOTE_FREQ_4_G
  .byte <NOTE_FREQ_4_GS
  .byte <NOTE_FREQ_4_A
  .byte <NOTE_FREQ_4_AS
  .byte <NOTE_FREQ_4_B
  .byte <NOTE_FREQ_5_C
  .byte <NOTE_FREQ_5_CS
  .byte <NOTE_FREQ_5_D
  .byte <NOTE_FREQ_5_DS
  .byte <NOTE_FREQ_5_E
  .byte <NOTE_FREQ_5_F
  .byte <NOTE_FREQ_5_FS
  .byte <NOTE_FREQ_5_G
  .byte <NOTE_FREQ_5_GS
  .byte <NOTE_FREQ_5_A
  .byte <NOTE_FREQ_5_AS
  .byte <NOTE_FREQ_5_B
  .byte <NOTE_FREQ_6_C
  .byte <NOTE_FREQ_6_CS
  .byte <NOTE_FREQ_6_D
  .byte <NOTE_FREQ_6_DS
  .byte <NOTE_FREQ_6_E
  .byte <NOTE_FREQ_6_F
  .byte <NOTE_FREQ_6_FS
  .byte <NOTE_FREQ_6_G
  .byte <NOTE_FREQ_6_GS
  .byte <NOTE_FREQ_6_A
  .byte <NOTE_FREQ_6_AS
  .byte <NOTE_FREQ_6_B

MusicEngineNoteFreqTableHi2C = MusicEngineNoteFreqTableHi1C + (NUMBER_OF_NOTES_IN_OCTAVE * 1)
MusicEngineNoteFreqTableHi3C = MusicEngineNoteFreqTableHi1C + (NUMBER_OF_NOTES_IN_OCTAVE * 2)
MusicEngineNoteFreqTableHi4C = MusicEngineNoteFreqTableHi1C + (NUMBER_OF_NOTES_IN_OCTAVE * 3)
MusicEngineNoteFreqTableHi5C = MusicEngineNoteFreqTableHi1C + (NUMBER_OF_NOTES_IN_OCTAVE * 4)
MusicEngineNoteFreqTableHi6C = MusicEngineNoteFreqTableHi1C + (NUMBER_OF_NOTES_IN_OCTAVE * 5)

MusicEngineNoteFreqTableLo2C = MusicEngineNoteFreqTableLo1C + (NUMBER_OF_NOTES_IN_OCTAVE * 1)
MusicEngineNoteFreqTableLo3C = MusicEngineNoteFreqTableLo1C + (NUMBER_OF_NOTES_IN_OCTAVE * 2)
MusicEngineNoteFreqTableLo4C = MusicEngineNoteFreqTableLo1C + (NUMBER_OF_NOTES_IN_OCTAVE * 3)
MusicEngineNoteFreqTableLo5C = MusicEngineNoteFreqTableLo1C + (NUMBER_OF_NOTES_IN_OCTAVE * 4)
MusicEngineNoteFreqTableLo6C = MusicEngineNoteFreqTableLo1C + (NUMBER_OF_NOTES_IN_OCTAVE * 5)

;---------------------------------------
MusicEngineV1FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV1FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV2FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV2FreqTableLo = MusicEngineNoteFreqTableLo1C

MusicEngineV3FreqTableHi = MusicEngineNoteFreqTableHi1C
MusicEngineV3FreqTableLo = MusicEngineNoteFreqTableLo1C

;---------------------------------------
_InitializeMusic:
InitializeMusic:
  lda #$08        ; Set Voice2 Waveform (high nibble) to 8.
  sta SID_PB2Hi
  sta SID_PB3Hi
  
  lda #$00        ; Set Voice2 decay 2ms / attack 6ms.
  sta SID_AD2
  sta SID_AD3
  
  lda #$40        ; Set Voice2 sustain 114ms / release 6ms.
  sta SID_SUR2
  sta SID_SUR3
  
  ;lda #$07        ; Set Voice3 decay 2ms / attack 240ms.
  ;sta SID_AD3

  lda #$09        ; Set Voice1 decay 2ms / attack 250ms.
  sta SID_AD1
  
  lda #0
  sta SID_PB2Lo    ; Set Voice2 Waveform (low byte) to 0.
  sta SID_SUR1     ; Set Voice1 sustain 6m / release 6m.
  ;sta SID_SUR3     ; Set Voice3 sustain 6m / release 6m.
  
  lda #$1e
  sta MusicEngineV1TimeToRelease
  sta MusicEngineV2TimeToRelease
  sta MusicEngineV3TimeToRelease

  lda #<VOICE_1_START_1
  sta MusicEngineV1MusicStart
  lda #>VOICE_1_START_1
  sta MusicEngineV1MusicStart+1
  
  lda #<VOICE_1_END_1
  sta MusicEngineV1MusicEnd
  lda #>VOICE_1_END_1
  sta MusicEngineV1MusicEnd+1
  
  lda #<VOICE_2_START_1
  sta MusicEngineV2MusicStart
  lda #>VOICE_2_START_1
  sta MusicEngineV2MusicStart+1
  
  lda #<VOICE_2_END_1
  sta MusicEngineV2MusicEnd
  lda #>VOICE_2_END_1
  sta MusicEngineV2MusicEnd+1
  
  lda #<VOICE_3_START_1
  sta MusicEngineV3MusicStart
  lda #>VOICE_3_START_1
  sta MusicEngineV3MusicStart+1

  lda #<VOICE_3_END_1
  sta MusicEngineV3MusicEnd
  lda #>VOICE_3_END_1
  sta MusicEngineV3MusicEnd+1
  
  ; Start of what this routine should do.
  ; NOTE: Everything prior needs to at least be more generic.
  lda MusicEngineV1MusicStart      ; Load music vectors into music engine voice music data vector (counters).
  sta MusicEngineV1Position
  lda MusicEngineV1MusicStart+1
  sta MusicEngineV1Position+1

  lda MusicEngineV2MusicStart
  sta MusicEngineV2Position
  lda MusicEngineV2MusicStart+1
  sta MusicEngineV2Position+1

  lda MusicEngineV3MusicStart
  sta MusicEngineV3Position
  lda MusicEngineV3MusicStart+1
  sta MusicEngineV3Position+1

  lda #0
  sta MusicEngineV1Active ; Disable all voice music processing.
  sta MusicEngineV2Active
  sta MusicEngineV3Active

  sta SID_Ctl1    ; Gate all Voices silent.
  sta SID_Ctl2
  sta SID_Ctl3

  lda #15      ; Set volume 15 (max).
  sta SID_Amp

  rts

; Start of all voice/music processing.
_ProcessMusic:
ProcessMusic:
CheckVoice1:
  lda MusicEngineV1Active
  beq A_70EC

  jmp CheckVoice2

A_70EC:
  lda MusicEngineV1MusicEnd
  cmp MusicEngineV1Position
  bne @processVoice1

  lda MusicEngineV1MusicEnd+1
  cmp MusicEngineV1Position+1
  bne @processVoice1

  ; Loop?
  ;jmp @resetMusicVectors
  ;jmp SoundKillAll

; Reset music engine vectors to currently set base music data vectors.
@resetMusicVectors:
  lda MusicEngineV1MusicStart
  sta MusicEngineV1Position
  lda MusicEngineV1MusicStart+1
  sta MusicEngineV1Position+1

  lda MusicEngineV2MusicStart
  sta MusicEngineV2Position
  lda MusicEngineV2MusicStart+1
  sta MusicEngineV2Position+1

  lda MusicEngineV3MusicStart
  sta MusicEngineV3Position
  lda MusicEngineV3MusicStart+1
  sta MusicEngineV3Position+1

  lda #0
  sta MusicEngineV1Active
  sta MusicEngineV2Active
  sta MusicEngineV3Active

; Start music data processing (of voice 1).
@processVoice1:
  ldy #0                            ;     Y=0            // Reset Y as counter.
  lda (MusicEngineV1Position),y
  sta MusicEngineTempFetch          ;     MusicEngineTempFetch=A       // Backup this byte for later analysis.
  and #%00111111                    ;     // Cutoff bits 6 & 7.
  tax                               ;     // The first six bits of this byte are the music note index.
  lda MusicEngineV1FreqTableHi,x    ;     // Load Voice  1 Frequency HI byte.
  sta SID_S1Hi
  lda MusicEngineV1FreqTableLo,x    ;     // Load Voice  1 Frequency LO byte.
  sta SID_S1Lo
                                    ;     // Now check bit 7.
  bit MusicEngineTempFetch
  bpl A_7180

  iny                               ;       Y++           // Fetch and store next byte.
  lda (MusicEngineV1Position),y
  sta MusicEngineV1Duration

  inc MusicEngineV1Position         ;       (MusicEngineV1Position+1,MusicEngineV1Position)++ // Increase music pointer.
  bne A_7180
  inc MusicEngineV1Position+1
A_7180:
  inc MusicEngineV1Position
  bne A_7186
  inc MusicEngineV1Position+1

A_7186:                                   ;     // Now check bit 6.      [7186]
  bit MusicEngineTempFetch
  bvc A_7192

  lda #$00                          ;       // Disable Voice 1.
  sta SID_Ctl1

  beq A_7197

A_7192:
  lda #%0100001                     ;       //Gate Voice 1 and select sawtooth wave.
  sta SID_Ctl1

A_7197:
  lda MusicEngineV1TimeToRelease
  sta MusicEngineV1TimeToReleaseCounter

  lda MusicEngineV1Duration
  sta MusicEngineV1DurationCounter

  lda #1
  sta MusicEngineV1Active

CheckVoice2:
  lda MusicEngineV2Active
  beq A_71B0

  jmp CheckVoice3

A_71B0:
  lda MusicEngineV2MusicEnd
  cmp MusicEngineV2Position
  bne @processVoice2

  lda MusicEngineV2MusicEnd+1
  cmp MusicEngineV2Position+1
  bne @processVoice2

  lda MusicEngineV2MusicStart          ; // Reset music data address (counter).
  sta MusicEngineV2Position
  lda MusicEngineV2MusicStart+1
  sta MusicEngineV2Position+1

; Start music data processing (of voice 2).
@processVoice2:
  ldy #0
  lda (MusicEngineV2Position),y
  sta MusicEngineTempFetch
  and #%00111111
  tax
  lda MusicEngineV2FreqTableHi,x
  sta SID_S2Hi
  lda MusicEngineV2FreqTableLo,x
  sta SID_S2Lo
  
  bit MusicEngineTempFetch
  bpl A_71EF

  iny
  lda (MusicEngineV2Position),y
  sta MusicEngineV2Duration
  inc MusicEngineV2Position
  bne A_71EF

  inc MusicEngineV2Position+1
A_71EF:
  inc MusicEngineV2Position
  bne A_71F5

  inc MusicEngineV2Position+1
A_71F5:
  bit MusicEngineTempFetch
  bvc A_7201

  lda #$00
  sta SID_Ctl2
  beq A_7206

A_7201:
  lda #%01000001
  sta SID_Ctl2
A_7206:
  lda MusicEngineV2TimeToRelease
  sta MusicEngineV2TimeToReleaseCounter

  lda MusicEngineV2Duration
  sta MusicEngineV2DurationCounter

  lda #1
  sta MusicEngineV2Active

CheckVoice3:
  lda MusicEngineV3Active
  beq A_721F

  jmp ProcessMusicDurAndRel

A_721F:
  lda MusicEngineV3MusicEnd
  cmp MusicEngineV3Position
  bne @processVoice3
  
  lda MusicEngineV3MusicEnd+1
  cmp MusicEngineV3Position+1
  bne @processVoice3

  lda MusicEngineV3MusicStart
  sta MusicEngineV3Position
  lda MusicEngineV3MusicStart+1
  sta MusicEngineV3Position+1

@processVoice3:
  ldy #0
  lda (MusicEngineV3Position),y
  sta MusicEngineTempFetch
  and #%00111111
  tax
  lda MusicEngineV3FreqTableHi,x
  sta SID_S3Hi
  lda MusicEngineV3FreqTableLo,x
  sta SID_S3Lo
  
  bit MusicEngineTempFetch
  bpl V3A_71EF

  iny
  lda (MusicEngineV3Position),y
  sta MusicEngineV3Duration
  inc MusicEngineV3Position
  bne V3A_71EF

  inc MusicEngineV3Position+1
V3A_71EF:
  inc MusicEngineV3Position
  bne V3A_71F5

  inc MusicEngineV3Position+1
V3A_71F5:
  bit MusicEngineTempFetch
  bvc V3A_7201

  lda #$00
  sta SID_Ctl3
  beq V3A_7206

V3A_7201:
  lda #%01000001
  sta SID_Ctl3
V3A_7206:
  lda MusicEngineV3TimeToRelease
  sta MusicEngineV3TimeToReleaseCounter

  lda MusicEngineV3Duration
  sta MusicEngineV3DurationCounter

  lda #1
  sta MusicEngineV3Active

; Process music engine voice time to release and duration.
ProcessMusicDurAndRel:
  lda MusicEngineV1TimeToReleaseCounter
  bne A_7266

  lda #$00                                             ;   // Disable Voice 1.
  sta SID_Ctl1
  beq A_7269
A_7266:
  dec MusicEngineV1TimeToReleaseCounter                ;   MusicEngineV1TimeToReleaseCounter--

A_7269:
  lda MusicEngineV1DurationCounter                     ; A=MusicEngineV1DurationCounter
  cmp #1
  beq A_7276

  dec MusicEngineV1DurationCounter                     ;   MusicEngineV1DurationCounter--
  jmp J_727E

A_7276:
  lda #$00                                             ;   A=0 // Disable Voice 1.
  sta SID_Ctl1
  sta MusicEngineV1Active

J_727E:
  lda MusicEngineV2TimeToReleaseCounter
  bne A_728A

  lda #$00
  sta SID_Ctl2
  beq A_728D
A_728A:
  dec MusicEngineV2TimeToReleaseCounter

A_728D:
  lda MusicEngineV2DurationCounter
  cmp #1
  beq A_729A

  dec MusicEngineV2DurationCounter
  jmp J_72A2

A_729A:
  lda #$00
  sta SID_Ctl2
  sta MusicEngineV2Active

J_72A2:
  lda MusicEngineV3TimeToReleaseCounter
  bne A_72AE

  lda #$00
  sta SID_Ctl3
  beq A_72B1
A_72AE:
  dec MusicEngineV3TimeToReleaseCounter

A_72B1:
  lda MusicEngineV3DurationCounter
  cmp #1
  beq A_72BC

  dec MusicEngineV3DurationCounter
  rts

A_72BC:
  lda #$00
  sta SID_Ctl3
  sta MusicEngineV3Active
  rts
