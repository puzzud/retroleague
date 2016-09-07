// c64 video.c

#include "system.h"

void __fastcall__ InitVideo(void)
{
  
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  SET_MEMORY(53281l, color)
}

void __fastcall__ SetCharacterColor(unsigned char index, unsigned char color)
{
  // TODO: Determine best way to handle this function,
  // as C64 is not limited to character graphics being
  // of 4 different palette entries.
}

void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y)
{
  
}
