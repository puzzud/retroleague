// nes video.c

#include "system.h"

#define PALETTE_SIZE     NUMBER_OF_COLORS_PER_PALETTE_ENTRY * NUMBER_OF_ENTRIES_PER_PALETTE

enum PaletteUpdateMode
{
  PALETTE_UPDATE_MODE_ALL = 0,
  PALETTE_UPDATE_MODE_CHARACTER,
  PALETTE_UPDATE_MODE_SPRITE
};

unsigned char CharacterPalette[PALETTE_SIZE];
unsigned char SpritePalette[PALETTE_SIZE];

extern unsigned char PrintColorSet;
#pragma zpsym ("PrintColorSet")

extern unsigned char UpdatePaletteFlag;
#pragma zpsym ("UpdatePaletteFlag")

unsigned char VideoIndex;

void __fastcall__ UpdatePalette(unsigned char id);

void __fastcall__ DisableVideo(void)
{
  // Turn off the screen.
  *PPU_CTRL1 = 0;
  *PPU_CTRL2 = 0;
}

void __fastcall__ EnableVideo(void)
{
  *PPU_VRAM_ADDR1 = 0x00;
  *PPU_VRAM_ADDR1 = 0x00;
  *PPU_VRAM_ADDR2 = 0x00;
  *PPU_VRAM_ADDR2 = 0x00;
  
  // Turn on screen.
  *PPU_CTRL1 = 0x90;
  *PPU_CTRL2 = 0x1e;
}

void __fastcall__ UpdatePalette(unsigned char updateMode)
{
  *PPU_VRAM_ADDR2 = 0x3f;
  
  VideoIndex = 0;
  
  if(updateMode == PALETTE_UPDATE_MODE_CHARACTER)
  {
    *PPU_VRAM_ADDR2 = 0x00;
    
    for(; VideoIndex < PALETTE_SIZE; ++VideoIndex)
    {
      *PPU_VRAM_IO = CharacterPalette[VideoIndex];
    }
  }
  else
  if(updateMode == PALETTE_UPDATE_MODE_SPRITE)
  {
    *PPU_VRAM_ADDR2 = 0x10;
    
    for(; VideoIndex < PALETTE_SIZE; ++VideoIndex)
    {
      *PPU_VRAM_IO = SpritePalette[VideoIndex];
    }
  }
  else // PALETTE_UPDATE_MODE_ALL
  {
    *PPU_VRAM_ADDR2 = 0x00;
    
    for(; VideoIndex < PALETTE_SIZE; ++VideoIndex)
    {
      *PPU_VRAM_IO = CharacterPalette[VideoIndex];
    }
    
    for(VideoIndex = 0; VideoIndex < PALETTE_SIZE; ++VideoIndex)
    {
      *PPU_VRAM_IO = SpritePalette[VideoIndex];
    }
  }
  
  // TODO: Why is this needed?
  *PPU_VRAM_ADDR2 = 0;
  *PPU_VRAM_ADDR2 = 0;
  
  UpdatePaletteFlag = 0;
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  // Write to sprite cache palette entry 0
  // (should act as background).
  SpritePalette[0] =
  CharacterPalette[0 * NUMBER_OF_COLORS_PER_PALETTE_ENTRY] =
  CharacterPalette[1 * NUMBER_OF_COLORS_PER_PALETTE_ENTRY] =
  CharacterPalette[2 * NUMBER_OF_COLORS_PER_PALETTE_ENTRY] =
  CharacterPalette[3 * NUMBER_OF_COLORS_PER_PALETTE_ENTRY] = color;
  
  // Flag video engine to update palette.
  UpdatePaletteFlag = 1;
}

void __fastcall__ SetCharacterColor(unsigned char index, unsigned char color)
{ 
  CharacterPalette[index] = color;
  
  // Flag video engine to update palette.
  UpdatePaletteFlag = 1;
}

void __fastcall__ SetCharacterPrimaryColor(unsigned char setIndex, unsigned char color)
{ 
  CharacterPalette[(setIndex * 4) + 1] = color;
  
  // Flag video engine to update palette.
  UpdatePaletteFlag = 1;
}

void __fastcall__ SetCharacterSecondaryColor(unsigned char index, unsigned char color)
{
  VideoIndex = 1 + index;
  CharacterPalette[VideoIndex] = color;
  
  VideoIndex += NUMBER_OF_COLORS_PER_PALETTE_ENTRY;
  CharacterPalette[VideoIndex] = color;
  
  VideoIndex += NUMBER_OF_COLORS_PER_PALETTE_ENTRY;
  CharacterPalette[VideoIndex] = color;
  
  VideoIndex += NUMBER_OF_COLORS_PER_PALETTE_ENTRY;
  CharacterPalette[VideoIndex] = color;
  
  // Flag video engine to update palette.
  UpdatePaletteFlag = 1;
}

void __fastcall__ SetPrintColor(unsigned char setIndex)
{
  PrintColorSet = setIndex;
}
