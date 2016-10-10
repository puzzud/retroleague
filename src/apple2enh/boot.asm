.import Reset

.include "util.asm"

; EXEHDR is expected to be at $4000.
.segment "EXEHDR"

  jmp Reset
