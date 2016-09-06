// SNES video.c

#include "system.h"

void __fastcall__ InitVideo(void)
{
  SetBackgroundColor(0);
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  color += 0xc0;
  
  SET_MEMORY(0x2122, color)
  SET_MEMORY(0x2122, 0x03)
  
  SET_MEMORY(0x2100, 0x0f)
}

void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y)
{
  
}
