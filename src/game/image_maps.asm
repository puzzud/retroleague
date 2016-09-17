.export _TitleScreenLogoImage

.segment "RODATA"

_TitleScreenLogoImage:
  .byte 21
  .byte 14
  .include "../graphics/trl_logo_merged.map"
