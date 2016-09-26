.import __PRG_NUM__
.import __CHR_NUM__
.import __MIRRORING__
.import __HAS_SRAM__
.import __MAPPER_NUM__

.include "nes.asm"

.segment "HEADER"

iNesHeader:
  .byte 'N','E','S'     ; "NES"
  .byte $1a             ; DOS EOF ($1a)
  
  .byte <(__PRG_NUM__)  ; N x 16KB PRG-ROM
  .byte <(__CHR_NUM__)  ; N X  8KB CHR-ROM
  
  ; Set mapper and mirroring, etc.
  .byte <(__MAPPER_NUM__ & $0f) | <(__MIRRORING__) | <(__HAS_SRAM__ << 1)
  .byte <(__MAPPER_NUM__ << 4)
  
  ; Various flags; most not used or recognized.
  .res 8,0
