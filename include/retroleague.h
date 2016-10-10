#ifndef RETRO_LEAGUE_H
#define RETRO_LEAGUE_H

#include <system.h>

#if defined(__APPLE2ENH__)
#include <apple2.h>

#define TITLE_SCREEN_COLOR_BG       0
#define TITLE_SCREEN_COLOR_LOGO     0
#define TITLE_SCREEN_COLOR_TEXT     0

#define TITLE_SCREEN_X_LOGO         10
#define TITLE_SCREEN_Y_LOGO         1
#define TITLE_SCREEN_X_START_TEXT   14
#define TITLE_SCREEN_Y_START_TEXT   18

#define TITLE_SCREEN_START_TEXT     "PRESS BUTTON"
#define TITLE_SCREEN_START_BUTTON   CONTROLLER_BUTTON0

#define INTRO_SCREEN_COLOR_BG       0
#define INTRO_SCREEN_COLOR_TEXT     0

#define INTRO_SCREEN_Y_START_TEXT   TITLE_SCREEN_Y_START_TEXT - 1
#endif

#if defined(__C64__)
#include <c64.h>

#define TITLE_SCREEN_COLOR_BG       COLOR_BLACK
#define TITLE_SCREEN_COLOR_LOGO     COLOR_YELLOW
#define TITLE_SCREEN_COLOR_TEXT     COLOR_WHITE

#define TITLE_SCREEN_X_LOGO         10
#define TITLE_SCREEN_Y_LOGO         1
#define TITLE_SCREEN_X_START_TEXT   14
#define TITLE_SCREEN_Y_START_TEXT   18

#define TITLE_SCREEN_START_TEXT     "PRESS BUTTON"
#define TITLE_SCREEN_START_BUTTON   CONTROLLER_BUTTON0

#define INTRO_SCREEN_COLOR_BG       COLOR_BLACK
#define INTRO_SCREEN_COLOR_TEXT     COLOR_WHITE

#define INTRO_SCREEN_Y_START_TEXT   TITLE_SCREEN_Y_START_TEXT - 1
#endif

#if defined(__NES__)
#include <nes.h>

#define TITLE_SCREEN_COLOR_BG       0x0d
#define TITLE_SCREEN_COLOR_LOGO     0x28
#define TITLE_SCREEN_COLOR_TEXT     0x20

#define TITLE_SCREEN_X_LOGO         6
#define TITLE_SCREEN_Y_LOGO         1
#define TITLE_SCREEN_X_START_TEXT   10
#define TITLE_SCREEN_Y_START_TEXT   18

#define TITLE_SCREEN_START_TEXT     "PRESS  START"
#define TITLE_SCREEN_START_BUTTON   CONTROLLER_BUTTON2

#define INTRO_SCREEN_COLOR_BG       0x0d
#define INTRO_SCREEN_COLOR_TEXT     0x20

#define INTRO_SCREEN_Y_START_TEXT   TITLE_SCREEN_Y_START_TEXT
#endif

#endif
