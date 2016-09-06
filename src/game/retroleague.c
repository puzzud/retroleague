#include "system.h"

const unsigned char GameTitle[] = "THE RETRO LEAGUE";

void Init(void)
{
  InitVideo();
}

void Update(void)
{
  PrintText(GameTitle, 0, 0);
}
