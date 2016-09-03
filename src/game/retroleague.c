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
}
