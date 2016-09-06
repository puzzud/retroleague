// nes video.c

#include "system.h"

extern const unsigned char GameTitle[];

const unsigned char Palette[] =
{
  0x1f, 0x30, 0x20, 0x10,
  0x1f, 0x30, 0x20, 0x10,
  0x1f, 0x30, 0x20, 0x10,
  0x1f, 0x30, 0x20, 0x10
};

unsigned char index;
unsigned char character;

void __fastcall__ InitVideo(void)
{
  //SetBackgroundColor(0);
  
  // Turn off the screen.
  *PPU_CTRL1 = 0;
  *PPU_CTRL2 = 0;

  // Load palette.
  *PPU_VRAM_ADDR2 = 0x3f;
  *PPU_VRAM_ADDR2 = 0x00;
  for(index = 0; index < sizeof(Palette); ++index)
  {
    *PPU_VRAM_IO = Palette[index];
  }
  
  PrintText(GameTitle, 0, 1);

  // Reset the scroll position.
  *PPU_VRAM_ADDR2 = 0;
  *PPU_VRAM_ADDR2 = 0;
  *PPU_VRAM_ADDR1 = 0;
  *PPU_VRAM_ADDR1 = 0;

  // Rurn on screen.
  *PPU_CTRL1 = 0x90;
  *PPU_CTRL2 = 0x1e;
}

void __fastcall__ SetBackgroundColor(unsigned char color)
{
  // Increase this value just so it's not black.
  color += 0x28;
  
  // TODO: Use palette shadow memory instead.
  // TODO: Set up mechanism to update palette during NMI.
  asm("lda $2002");
  
  SET_MEMORY(0x2006, 0x3f)
  SET_MEMORY(0x2006, 0x10)
  
  SET_MEMORY(0x2007, color)
  SET_MEMORY(0x2007, 0x0f)
  SET_MEMORY(0x2007, 0x0f)
  SET_MEMORY(0x2007, 0x0f)
}

void __fastcall__ PrintText(const unsigned char* text, unsigned char x, unsigned char y)
{
  // PPU 0x2020 is upper left corner of visible screen.
  *PPU_VRAM_ADDR2 = 0x20;
  *PPU_VRAM_ADDR2 = 0x20 + x;
  
  index = -1;
  do
  {
    character = text[++index];
    *PPU_VRAM_IO = character;
  }
  while(character != 0);
}
