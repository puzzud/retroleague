.import Reset

.include "util.asm"

; EXEHDR is expected to be at $0801
; NOTE: This block should be 15 or less bytes long.
.segment "EXEHDR"

; BASIC boot (SYS Reset)
BasicBoot:
  .word @firstBasicLine
@firstBasicLine:
  .word 10                  ; 10, BASIC line number.
  
  .byte $9e                 ; SYS + "####"
  wtostr Reset
  .asciiz ""
  
  .byte $00,$00,$00,$00     ; End of Basic program.
