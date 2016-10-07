#include "system.h"

#include <retroleague.h>

extern unsigned char TitleScreenLogoImage[];

extern unsigned char VOICE_1_START[];
extern unsigned char VOICE_2_START[];
extern unsigned char VOICE_3_START[];

void Init(void);

void TitleScreenInit(void);
void TitleScreenUpdate(void);
void IntroScreenInit(void);
void IntroScreenUpdate(void);

void Init(void)
{
  CurrentScreenInit = &TitleScreenInit;
  CurrentScreenUpdate = &TitleScreenUpdate;
  InitScreen = 1;
}

void TitleScreenInit(void)
{
  DisableVideo();
  
  // Set up palette.
  SetCharacterPrimaryColor(0, TITLE_SCREEN_COLOR_TEXT);
  SetCharacterPrimaryColor(1, TITLE_SCREEN_COLOR_LOGO);
  
  SetBackgroundColor(TITLE_SCREEN_COLOR_BG);
  
  SetPrintColor(1);
  DrawImage(TitleScreenLogoImage, TITLE_SCREEN_X_LOGO, TITLE_SCREEN_Y_LOGO);
  
  SetPrintColor(0);
  PrintText(TITLE_SCREEN_START_TEXT, TITLE_SCREEN_X_START_TEXT, TITLE_SCREEN_Y_START_TEXT);
  
  EnableVideo();
  
  SetMusicVoice(0, VOICE_1_START);
  SetMusicVoice(1, VOICE_2_START);
  SetMusicVoice(2, VOICE_3_START);
  StartMusic();
}

void TitleScreenUpdate(void)
{
  if((ControllerButtonsPressed[0] & TITLE_SCREEN_START_BUTTON) > 0)
  {
    StopMusic();
    
    CurrentScreenInit = &IntroScreenInit;
    CurrentScreenUpdate = &IntroScreenUpdate;
    InitScreen = 1;
  }
}

void IntroScreenInit(void)
{
  DisableVideo();
  
  // Set up palette.
  SetCharacterPrimaryColor(0, INTRO_SCREEN_COLOR_TEXT);
  
  SetBackgroundColor(INTRO_SCREEN_COLOR_BG);
  
  ClearScreen();
  
  SetPrintColor(0);
  PrintText("ROB:", 0, INTRO_SCREEN_Y_START_TEXT + 0);
  PrintText("WELCOME TO THE RETRO LEAGUE", 0, INTRO_SCREEN_Y_START_TEXT + 1);
  PrintText("VIDEO GAME!", 0, INTRO_SCREEN_Y_START_TEXT + 2);
  PrintText("I'M JUNGLE RAT ROB AND", 0, INTRO_SCREEN_Y_START_TEXT + 3);
  PrintText("JOINING ME IS HUGUES.", 0, INTRO_SCREEN_Y_START_TEXT + 4);
  
  PrintText("HUGUES:", 0, INTRO_SCREEN_Y_START_TEXT + 6);
  PrintText("WHAT'S UP, DOC?!", 0, INTRO_SCREEN_Y_START_TEXT + 7);
  
  EnableVideo();
}

void IntroScreenUpdate(void)
{
  
}
