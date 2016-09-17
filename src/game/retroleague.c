#include "system.h"

const unsigned char GameTitle[] = "THE RETRO LEAGUE";

unsigned char count;
unsigned char backgroundColor;
unsigned char foregroundColor;

extern unsigned char TitleScreenLogoImage[];

void Init(void)
{
  // Set up palette.
  foregroundColor = 0x28;
  SetCharacterColor(1, foregroundColor);
  
  backgroundColor = 0x1f;
  SetBackgroundColor(backgroundColor);
  
  InitVideo();
  
  // TODO: Placement of this PrintText can be
  // critical with respect to InitVideo.
  
  DisableVideo();
  
  DrawImage(TitleScreenLogoImage, 6, 1);

  PrintText("PRESS START", 10, 18);
  
  EnableVideo();
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
  }
}
