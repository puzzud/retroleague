; ASM file to include character graphics and sprite graphics for C64.

.export _CHARSET
.export _SPRITES

.segment "RODATA"

_CHARSET:
  .incbin "graphics/c64/chr0.chr"

_SPRITES:
  
