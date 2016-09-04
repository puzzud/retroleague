#include "system.h"

void __fastcall__ InitVideo(void);
void __fastcall__ SetBackgroundColor(unsigned char color);

void Init(void)
{
  InitVideo();
}

void Update(void)
{
  
}

void InitVideo(void)
{
  SetBackgroundColor(0);
}

void SetBackgroundColor(unsigned char color)
{
#if defined(__C64__)
  SET_MEMORY(53281l, color)
#endif

#if defined(__NES__) 
  color += 0x28; // Increase this value just so it's not black.
  
  // TODO: Use palette shadow memory instead.
  // TODO: Set up mechanism to update palette
  // during NMI.
  asm( "LDA $2002" );
  
  SET_MEMORY(0x2006, 0x3f)
  SET_MEMORY(0x2006, 0x10)
  
  SET_MEMORY(0x2007, color)
  SET_MEMORY(0x2007, 0x0f)
  SET_MEMORY(0x2007, 0x0f)
  SET_MEMORY(0x2007, 0x0f)
#endif
}
