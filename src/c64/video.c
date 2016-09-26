// c64 video.c

#include "system.h"

#define NUMBER_OF_CHARACTER_COLOR_SETS      4
#define PALETTE_SIZE                        NUMBER_OF_CHARACTER_COLOR_SETS

extern unsigned char PrintColor;

extern void __fastcall__ LoadFile(unsigned char* fileName, unsigned char* address);
extern void InitializeVideo();

extern unsigned char CHARSET[];

unsigned char VideoIndex;

unsigned char CharacterPalette[NUMBER_OF_CHARACTER_COLOR_SETS]; 

void __fastcall__ DisableVideo(void)
{
  *VIC_CTRL2 |= 0x10;
}

void __fastcall__ EnableVideo(void)
{
  *VIC_CTRL2 &= 0xef;
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  SET_MEMORY(VIC_BG_COLOR0, color)
  SET_MEMORY(VIC_BORDERCOLOR, color)
}

void __fastcall__ SetCharacterColor(unsigned char index, unsigned char color)
{
  SetCharacterPrimaryColor(index, color);
}

void __fastcall__ SetCharacterPrimaryColor(unsigned char setIndex, unsigned char color)
{ 
  CharacterPalette[setIndex] = color;
}

void __fastcall__ SetCharacterSecondaryColor(unsigned char index, unsigned char color)
{
  *(VIC_BG_COLOR1 - 1 + index) = color;
}

void __fastcall__ SetPrintColor(unsigned char setIndex)
{
  PrintColor = CharacterPalette[setIndex];
}
