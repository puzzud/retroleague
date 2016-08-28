extern void init( void );

int main (void)
{
  init();
  
  // Set background color to $03e0.
  *((unsigned char*)0x2122) = 0xe0;
  *((unsigned char*)0x2122) = 0x03;
  
  // Maximum screen brightness.
  *((unsigned char*)0x2100) = 0x0f;
  
  while(1)
  {
    ;
  }
  
  return 0;
}
