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

extern void __fastcall__ InitVideo(void);
extern void __fastcall__ SetBackgroundColor(unsigned char color);
extern void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y);

#endif
