; A 4 digit string representing a 16 bit word.
; This string is not null terminated. 
.macro wtostr w
  .byte <(((w / 1000) .mod 10) + $30) 
  .byte <(((w / 100)  .mod 10) + $30) 
  .byte <(((w / 10)   .mod 10) + $30) 
  .byte <(((w / 1)    .mod 10) + $30)
.endmacro

; A 4 digit string representing a 16 bit word.
; This string is null terminated.
.macro wtostrz w
  wtostr w
  .byte $00
.endmacro
