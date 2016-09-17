#ifndef RETRO_LEAGUE_H
#define RETRO_LEAGUE_H

#include <system.h>

#if defined(__C64__)
#include <c64.h>

#define TITLE_SCREEN_COLOR_BG       COLOR_BLACK
#define TITLE_SCREEN_COLOR_LOGO     COLOR_YELLOW
#define TITLE_SCREEN_COLOR_TEXT     COLOR_WHITE
#endif

#if defined(__NES__)
#include <nes.h>

#define TITLE_SCREEN_COLOR_BG       0x0d
#define TITLE_SCREEN_COLOR_LOGO     0x28
#define TITLE_SCREEN_COLOR_TEXT     0x20
#endif

#endif
