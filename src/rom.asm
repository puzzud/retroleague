.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.import _main

.segment "HEADER"      ; +$7FE0 in file
  .byte "ROM NAME"     ; ROM name. NOTE: Can be changed.

.segment "ROMINFO"     ; +$7FD5 in file
  .byte $30            ; LoROM, fast-capable
  .byte 0              ; no battery RAM
  .byte $07            ; 128K ROM
  .byte 0,0,0,0
  .word $AAAA,$5555    ; dummy checksum and complement
                       ; TODO: 

.segment "VECTORS"
  .word 0, 0, 0, 0, 0, 0, 0, 0
  .word 0, 0, 0, 0, 0, 0, _main, 0
