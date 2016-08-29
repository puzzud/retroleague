#include "system.h"

int main(void)
{
  init();
  
  SET_MEMORY(0x2122, 0xe0)
  SET_MEMORY(0x2122, 0x03)
  
  SET_MEMORY(0x2100, 0x0f)
  
  while(1)
  {
    ;
  }
  
  return 0;
}
