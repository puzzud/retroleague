# retroleague
An game programmed in C and 6502 & 65816 Assembly.

**Requirements:**
 - BASH / Unix environment (eg Linux, Mac OS X, Cygwin)
 - GNU make
 - cc65

**Optional:**
 - C64 emulator
 - SNES emulator

**Instructions:**
 - Clone cc65 project (https://github.com/cc65/cc65.git).
 - cd cc65; make
 - export CC65_HOME=/path/to/cc65
 - export PATH=$PATH:$CC65_HOME
 - cd retroleague; make
 - Open retroleague/bin/retroleague.* in an appropriate emulator.

**To Do:**
 - Add a step to patch and build snes.lib (replacing need to supply binary and have build_snes_runtime_lib.sh).
 - Determine how to get function parameters to work correctly with SNES builds--cc65 runtime library code not using 65816 architecture correctly?
 - Make build process give SMC images a valid CRC checksum header value at build time.
 - Make build process give SMC images a header name value based on the project.
 