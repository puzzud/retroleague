#include "system.h"

#include <retroleague.h>

const unsigned char GameTitle[] = "THE RETRO LEAGUE";

unsigned char count;

extern unsigned char TitleScreenLogoImage[];

void Init(void)
{
  // Set up palette.
  SetCharacterPrimaryColor(0, TITLE_SCREEN_COLOR_TEXT);
  SetCharacterPrimaryColor(1, TITLE_SCREEN_COLOR_LOGO);
  
  SetBackgroundColor(TITLE_SCREEN_COLOR_BG);
  
  DisableVideo();
  
  SetPrintColor(1);
  DrawImage(TitleScreenLogoImage, TITLE_SCREEN_X_LOGO, TITLE_SCREEN_Y_LOGO);
  
  SetPrintColor(0);
  PrintText(TITLE_SCREEN_START_TEXT, TITLE_SCREEN_X_START_TEXT, TITLE_SCREEN_Y_START_TEXT);
  
  EnableVideo();
  
  StartMusic();
}

void Update(void)
{
  if((ControllerButtonsPressed[0] & TITLE_SCREEN_START_BUTTON) > 0)
  {
    count = -2;
    
    SetBackgroundColor(TITLE_SCREEN_COLOR_TEXT);
    
    StopMusic();
  }
  
  if(++count > 64)
  {
    count = 0;
  }
}
