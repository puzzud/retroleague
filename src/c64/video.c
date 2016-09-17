// c64 video.c

#include "system.h"

extern unsigned char PrintColor;

void __fastcall__ InitVideo(void)
{
  
}

void __fastcall__ DisableVideo(void)
{
  
}

void __fastcall__ EnableVideo(void)
{
  
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  SET_MEMORY(VIC_BG_COLOR0, color)
  SET_MEMORY(VIC_BORDERCOLOR, color)
}

void __fastcall__ SetCharacterColor(unsigned char index, unsigned char color)
{
  // TODO: Determine best way to handle this function,
  // as C64 is not limited to character graphics being
  // of 4 different palette entries.
  
  if(index > 0)
  {
    if(index == 1)
    {
      PrintColor = color;
    }
    else
    {
      //SET_MEMORY(VIC_BG_COLOR1 + index - 1, color)
    }
  }
  else
  {
    // ?
  }
}

void __fastcall__ DrawImage(const unsigned char* image, unsigned char x, unsigned char y)
{
  
}
