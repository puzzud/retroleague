// nes video.c

#include "system.h"

#define PALETTE_BYTE_SIZE     NUMBER_OF_COLORS_PER_PALETTE_ENTRY * NUMBER_OF_ENTRIES_PER_PALETTE

enum PaletteUpdateMode
{
  PALETTE_UPDATE_MODE_ALL = 0,
  PALETTE_UPDATE_MODE_CHARACTER,
  PALETTE_UPDATE_MODE_SPRITE
};

unsigned char CharacterPalette[PALETTE_BYTE_SIZE];
unsigned char SpritePalette[PALETTE_BYTE_SIZE];

unsigned char index;

extern unsigned char UpdatePaletteFlag;
#pragma zpsym ("UpdatePaletteFlag")

void __fastcall__ SetColor(unsigned char index, unsigned char color);
void __fastcall__ UpdatePalette(unsigned char id);

void __fastcall__ DisableVideo(void)
{
  // Turn off the screen.
  *PPU_CTRL1 = 0;
  *PPU_CTRL2 = 0;
}

void __fastcall__ EnableVideo(void)
{
  // Turn on screen.
  *PPU_CTRL1 = 0x90;
  *PPU_CTRL2 = 0x1e;
}

void __fastcall__ UpdatePalette(unsigned char updateMode)
{
  *PPU_VRAM_ADDR2 = 0x3f;
  
  index = 0;
  
  if(updateMode == PALETTE_UPDATE_MODE_CHARACTER)
  {
    *PPU_VRAM_ADDR2 = 0x00;
    
    for(; index < PALETTE_BYTE_SIZE; ++index)
    {
      *PPU_VRAM_IO = CharacterPalette[index];
    }
  }
  else
  if(updateMode == PALETTE_UPDATE_MODE_SPRITE)
  {
    *PPU_VRAM_ADDR2 = 0x10;
    
    for(; index < PALETTE_BYTE_SIZE; ++index)
    {
      *PPU_VRAM_IO = SpritePalette[index];
    }
  }
  else // PALETTE_UPDATE_MODE_ALL
  {
    *PPU_VRAM_ADDR2 = 0x00;
    
    for(; index < PALETTE_BYTE_SIZE; ++index)
    {
      *PPU_VRAM_IO = CharacterPalette[index];
    }
    
    for(index = 0; index < PALETTE_BYTE_SIZE; ++index)
    {
      *PPU_VRAM_IO = SpritePalette[index];
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
