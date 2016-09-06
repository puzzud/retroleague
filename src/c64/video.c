// c64 video.c

#include "system.h"

void __fastcall__ InitVideo(void)
{
  SetBackgroundColor(0);
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  SET_MEMORY(53281l, color)
}

void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y)
{
  
}
