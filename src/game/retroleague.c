#include "system.h"

#include <retroleague.h>

const unsigned char GameTitle[] = "THE RETRO LEAGUE";

unsigned char count;
unsigned char backgroundColor;
unsigned char foregroundColor;

extern unsigned char TitleScreenLogoImage[];

void Init(void)
{
  // Set up palette.
  foregroundColor = TITLE_SCREEN_COLOR_LOGO;
  SetCharacterColor(1, foregroundColor);
  
  backgroundColor = TITLE_SCREEN_COLOR_BG;
  SetBackgroundColor(backgroundColor);
  
  InitVideo();
  
  // TODO: Placement of this PrintText can be
  // critical with respect to InitVideo.
  
  DisableVideo();
  
  DrawImage(TitleScreenLogoImage, TITLE_SCREEN_X_LOGO, TITLE_SCREEN_Y_LOGO);
  
  foregroundColor = TITLE_SCREEN_COLOR_TEXT;
  SetCharacterColor(1, foregroundColor);

  PrintText(TITLE_SCREEN_START_TEXT, TITLE_SCREEN_X_START_TEXT, TITLE_SCREEN_Y_START_TEXT);
  
  EnableVideo();
}

void Update(void)
{
  if((ControllerButtonsPressed[0] & TITLE_SCREEN_START_BUTTON) > 0)
  {
    count = -2;
  }
  
  if(++count > 64)
  {
    count = 0;
  }
}
