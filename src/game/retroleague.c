#include "system.h"

const unsigned char GameTitle[] = "THE RETRO LEAGUE";

unsigned char count;
unsigned char backgroundColor;
unsigned char foregroundColor;

void Init(void)
{
  // Set up palette.
  foregroundColor = 0x30;
  SetCharacterColor(1, foregroundColor);
  
  backgroundColor = 0x1f;
  SetBackgroundColor(backgroundColor);
  
  InitVideo();
  
  // TODO: Placement of this PrintText can be
  // critical with respect to InitVideo.
  PrintText(GameTitle, 0, 0);
}

void Update(void)
{
  if((ControllerButtonsPressed[0] & CONTROLLER_BUTTON0) > 0)
  {
    count = -2;
  }
  
  if(++count > 64)
  {
    count = 0;
    
    SetBackgroundColor(++backgroundColor);
    
    foregroundColor += 4;
    SetCharacterColor(1, foregroundColor);
  }
}
