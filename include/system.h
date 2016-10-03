#ifndef SYSTEM_H
#define SYSTEM_H

#if defined(__C64__)
#include "c64.h"
#endif

#if defined(__NES__)
#include "nes.h"
#endif

#if defined(__SNES__)
#include "snes.h"
#endif

#define BYTE_FROM_ADDRESS(A) ((unsigned char*)A)
#define GET_MEMORY(A)        *BYTE_FROM_ADDRESS(A);
#define SET_MEMORY(A, V)     *BYTE_FROM_ADDRESS(A) = V;

// Input
extern unsigned char ControllerButtons[];
extern unsigned char ControllerButtonsPressed[];

#pragma zpsym ("ControllerButtons")
#pragma zpsym ("ControllerButtonsPressed")

// Video
extern void __fastcall__ DisableVideo(void);
extern void __fastcall__ EnableVideo(void);
extern void __fastcall__ SetBackgroundColor(unsigned char color);
extern void __fastcall__ SetCharacterColor(unsigned char index, unsigned char color);
extern void __fastcall__ SetCharacterPrimaryColor(unsigned char setIndex, unsigned char color);
extern void __fastcall__ SetCharacterSecondaryColor(unsigned char index, unsigned char color);
extern void __fastcall__ SetPrintColor(unsigned char setIndex);
extern void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y);
extern void __fastcall__ DrawImage(const unsigned char* image, unsigned char x, unsigned char y);

// Audio
extern void __fastcall__ SetMusicVoice(unsigned char voiceIndex, const unsigned char* voiceStart);
extern void __fastcall__ StartMusic(void);
extern void __fastcall__ StopMusic(void);

#endif
