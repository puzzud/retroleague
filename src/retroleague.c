#include "system.h"

void __fastcall__ InitVideo(void);
void __fastcall__ SetBackgroundColor(void);

void Init(void)
{
  InitVideo();
}

void Update(void)
{
  
}

void InitVideo(void)
{
  SetBackgroundColor();
  
  // Maximum screen brightness.
  SET_MEMORY(0x2100, 0x0f)
}

void SetBackgroundColor(void)
{
  // Set background color to $03e0.
  SET_MEMORY(0x2122, 0xe0)
  SET_MEMORY(0x2122, 0x03)
}
