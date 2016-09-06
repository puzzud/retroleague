// Acquired from https://github.com/PeterLemon/SNES
//============== (Key: R=Read, W=Write, D=Double Read/Write) 
// SNES Include
//==============
#ifndef SNES_H
#define SNES_H

#include "system.h"

// Memory Map
#define WRAM    BYTE_FROM_ADDRESS(0x0000)         // WRAM Mirror ($7E0000-$7E1FFF)                        8KB/RW

// PPU Picture Processing Unit Ports (Write-Only)
#define REG_INIDISP      BYTE_FROM_ADDRESS(0x2100)  // Display Control 1                                     1B/W
#define REG_OBSEL        BYTE_FROM_ADDRESS(0x2101)    // Object Size & Object Base                             1B/W
#define REG_OAMADDL      BYTE_FROM_ADDRESS(0x2102)  // OAM Address (Lower 8-Bit)                             2B/W
#define REG_OAMADDH      BYTE_FROM_ADDRESS(0x2103)  // OAM Address (Upper 1-Bit) & Priority Rotation         1B/W
#define REG_OAMDATA      BYTE_FROM_ADDRESS(0x2104)  // OAM Data Write                                        1B/W D
#define REG_BGMODE       BYTE_FROM_ADDRESS(0x2105)   // BG Mode & BG Character Size                           1B/W
#define REG_MOSAIC       BYTE_FROM_ADDRESS(0x2106)   // Mosaic Size & Mosaic Enable                           1B/W
#define REG_BG1SC        BYTE_FROM_ADDRESS(0x2107)    // BG1 Screen Base & Screen Size                         1B/W
#define REG_BG2SC        BYTE_FROM_ADDRESS(0x2108)    // BG2 Screen Base & Screen Size                         1B/W
#define REG_BG3SC        BYTE_FROM_ADDRESS(0x2109)    // BG3 Screen Base & Screen Size                         1B/W
#define REG_BG4SC        BYTE_FROM_ADDRESS(0x210A)    // BG4 Screen Base & Screen Size                         1B/W
#define REG_BG12NBA      BYTE_FROM_ADDRESS(0x210B)  // BG1/BG2 Character Data Area Designation               1B/W
#define REG_BG34NBA      BYTE_FROM_ADDRESS(0x210C)  // BG3/BG4 Character Data Area Designation               1B/W
#define REG_BG1HOFS      BYTE_FROM_ADDRESS(0x210D)  // BG1 Horizontal Scroll (X) / M7HOFS                    1B/W D
#define REG_BG1VOFS      BYTE_FROM_ADDRESS(0x210E)  // BG1 Vertical   Scroll (Y) / M7VOFS                    1B/W D
#define REG_BG2HOFS      BYTE_FROM_ADDRESS(0x210F)  // BG2 Horizontal Scroll (X)                             1B/W D
#define REG_BG2VOFS      BYTE_FROM_ADDRESS(0x2110)  // BG2 Vertical   Scroll (Y)                             1B/W D
#define REG_BG3HOFS      BYTE_FROM_ADDRESS(0x2111)  // BG3 Horizontal Scroll (X)                             1B/W D
#define REG_BG3VOFS      BYTE_FROM_ADDRESS(0x2112)  // BG3 Vertical   Scroll (Y)                             1B/W D
#define REG_BG4HOFS      BYTE_FROM_ADDRESS(0x2113)  // BG4 Horizontal Scroll (X)                             1B/W D
#define REG_BG4VOFS      BYTE_FROM_ADDRESS(0x2114)  // BG4 Vertical   Scroll (Y)                             1B/W D
#define REG_VMAIN        BYTE_FROM_ADDRESS(0x2115)    // VRAM Address Increment Mode                           1B/W
#define REG_VMADDL       BYTE_FROM_ADDRESS(0x2116)   // VRAM Address    (Lower 8-Bit)                         2B/W
#define REG_VMADDH       BYTE_FROM_ADDRESS(0x2117)   // VRAM Address    (Upper 8-Bit)                         1B/W
#define REG_VMDATAL      BYTE_FROM_ADDRESS(0x2118)  // VRAM Data Write (Lower 8-Bit)                         2B/W
#define REG_VMDATAH      BYTE_FROM_ADDRESS(0x2119)  // VRAM Data Write (Upper 8-Bit)                         1B/W
#define REG_M7SEL        BYTE_FROM_ADDRESS(0x211A)    // Mode7 Rot/Scale Mode Settings                         1B/W
#define REG_M7A          BYTE_FROM_ADDRESS(0x211B)      // Mode7 Rot/Scale A (COSINE A) & Maths 16-Bit Operand   1B/W D
#define REG_M7B          BYTE_FROM_ADDRESS(0x211C)      // Mode7 Rot/Scale B (SINE A)   & Maths  8-bit Operand   1B/W D
#define REG_M7C          BYTE_FROM_ADDRESS(0x211D)      // Mode7 Rot/Scale C (SINE B)                            1B/W D
#define REG_M7D          BYTE_FROM_ADDRESS(0x211E)      // Mode7 Rot/Scale D (COSINE B)                          1B/W D
#define REG_M7X          BYTE_FROM_ADDRESS(0x211F)      // Mode7 Rot/Scale Center Coordinate X                   1B/W D
#define REG_M7Y          BYTE_FROM_ADDRESS(0x2120)      // Mode7 Rot/Scale Center Coordinate Y                   1B/W D
#define REG_CGADD        BYTE_FROM_ADDRESS(0x2121)    // Palette CGRAM Address                                 1B/W
#define REG_CGDATA       BYTE_FROM_ADDRESS(0x2122)   // Palette CGRAM Data Write                              1B/W D
#define REG_W12SEL       BYTE_FROM_ADDRESS(0x2123)   // Window BG1/BG2  Mask Settings                         1B/W
#define REG_W34SEL       BYTE_FROM_ADDRESS(0x2124)   // Window BG3/BG4  Mask Settings                         1B/W
#define REG_WOBJSEL      BYTE_FROM_ADDRESS(0x2125)  // Window OBJ/MATH Mask Settings                         1B/W
#define REG_WH0          BYTE_FROM_ADDRESS(0x2126)      // Window 1 Left  Position (X1)                          1B/W
#define REG_WH1          BYTE_FROM_ADDRESS(0x2127)      // Window 1 Right Position (X2)                          1B/W
#define REG_WH2          BYTE_FROM_ADDRESS(0x2128)      // Window 2 Left  Position (X1)                          1B/W
#define REG_WH3          BYTE_FROM_ADDRESS(0x2129)      // Window 2 Right Position (X2)                          1B/W
#define REG_WBGLOG       BYTE_FROM_ADDRESS(0x212A)   // Window 1/2 Mask Logic (BG1..BG4)                      1B/W
#define REG_WOBJLOG      BYTE_FROM_ADDRESS(0x212B)  // Window 1/2 Mask Logic (OBJ/MATH)                      1B/W
#define REG_TM           BYTE_FROM_ADDRESS(0x212C)       // Main Screen Designation                               1B/W
#define REG_TS           BYTE_FROM_ADDRESS(0x212D)       // Sub  Screen Designation                               1B/W
#define REG_TMW          BYTE_FROM_ADDRESS(0x212E)      // Window Area Main Screen Disable                       1B/W
#define REG_TSW          BYTE_FROM_ADDRESS(0x212F)      // Window Area Sub  Screen Disable                       1B/W
#define REG_CGWSEL       BYTE_FROM_ADDRESS(0x2130)   // Color Math Control Register A                         1B/W
#define REG_CGADSUB      BYTE_FROM_ADDRESS(0x2131)  // Color Math Control Register B                         1B/W
#define REG_COLDATA      BYTE_FROM_ADDRESS(0x2132)  // Color Math Sub Screen Backdrop Color                  1B/W
#define REG_SETINI       BYTE_FROM_ADDRESS(0x2133)   // Display Control 2                                     1B/W

// PPU Picture Processing Unit Ports (Read-Only)
#define REG_MPYL         BYTE_FROM_ADDRESS(0x2134)     // PPU1 Signed Multiply Result (Lower  8-Bit)            1B/R
#define REG_MPYM         BYTE_FROM_ADDRESS(0x2135)     // PPU1 Signed Multiply Result (Middle 8-Bit)            1B/R
#define REG_MPYH         BYTE_FROM_ADDRESS(0x2136)     // PPU1 Signed Multiply Result (Upper  8-Bit)            1B/R
#define REG_SLHV         BYTE_FROM_ADDRESS(0x2137)     // PPU1 Latch H/V-Counter By Software (Read=Strobe)      1B/R
#define REG_RDOAM        BYTE_FROM_ADDRESS(0x2138)    // PPU1 OAM  Data Read                                   1B/R D
#define REG_RDVRAML      BYTE_FROM_ADDRESS(0x2139)  // PPU1 VRAM  Data Read (Lower 8-Bit)                    1B/R
#define REG_RDVRAMH      BYTE_FROM_ADDRESS(0x213A)  // PPU1 VRAM  Data Read (Upper 8-Bit)                    1B/R
#define REG_RDCGRAM      BYTE_FROM_ADDRESS(0x213B)  // PPU2 CGRAM Data Read (Palette)                        1B/R D
#define REG_OPHCT        BYTE_FROM_ADDRESS(0x213C)    // PPU2 Horizontal Counter Latch (Scanline X)            1B/R D
#define REG_OPVCT        BYTE_FROM_ADDRESS(0x213D)    // PPU2 Vertical   Counter Latch (Scanline Y)            1B/R D
#define REG_STAT77       BYTE_FROM_ADDRESS(0x213E)   // PPU1 Status & PPU1 Version Number                     1B/R
#define REG_STAT78       BYTE_FROM_ADDRESS(0x213F)   // PPU2 Status & PPU2 Version Number (Bit 7=0)           1B/R

// APU Audio Processing Unit Ports (Read/Write)
#define REG_APUIO0       BYTE_FROM_ADDRESS(0x2140)   // Main CPU To Sound CPU Communication Port 0            1B/RW
#define REG_APUIO1       BYTE_FROM_ADDRESS(0x2141)   // Main CPU To Sound CPU Communication Port 1            1B/RW
#define REG_APUIO2       BYTE_FROM_ADDRESS(0x2142)   // Main CPU To Sound CPU Communication Port 2            1B/RW
#define REG_APUIO3       BYTE_FROM_ADDRESS(0x2143)   // Main CPU To Sound CPU Communication Port 3            1B/RW
// $2140..$2143 - APU Ports Mirrored To $2144..$217F

// WRAM Access Ports
#define REG_WMDATA       BYTE_FROM_ADDRESS(0x2180)   // WRAM Data Read/Write                                  1B/RW
#define REG_WMADDL       BYTE_FROM_ADDRESS(0x2181)   // WRAM Address (Lower  8-Bit)                           1B/W
#define REG_WMADDM       BYTE_FROM_ADDRESS(0x2182)   // WRAM Address (Middle 8-Bit)                           1B/W
#define REG_WMADDH       BYTE_FROM_ADDRESS(0x2183)   // WRAM Address (Upper  1-Bit)                           1B/W
// $2184..$21FF - Unused Region (Open Bus)/Expansion (B-Bus)
// $2200..$3FFF - Unused Region (A-Bus)

// CPU On-Chip I/O Ports (These Have Long Waitstates: 1.78MHz Cycles Instead Of 3.5MHz)
// ($4000..$4015 - Unused Region (Open Bus)
#define REG_JOYWR        BYTE_FROM_ADDRESS(0x4016)    // Joypad Output                                         1B/W
#define REG_JOYA         BYTE_FROM_ADDRESS(0x4016)     // Joypad Input Register A (Joypad Auto Polling)         1B/R
#define REG_JOYB         BYTE_FROM_ADDRESS(0x4017)     // Joypad Input Register B (Joypad Auto Polling)         1B/R
// $4018..$41FF - Unused Region (Open Bus)

// CPU On-Chip I/O Ports (Write-only, Read=Open Bus)
#define REG_NMITIMEN     BYTE_FROM_ADDRESS(0x4200) // Interrupt Enable & Joypad Request                     1B/W
#define REG_WRIO         BYTE_FROM_ADDRESS(0x4201)     // Programmable I/O Port (Open-Collector Output)         1B/W
#define REG_WRMPYA       BYTE_FROM_ADDRESS(0x4202)   // Set Unsigned  8-Bit Multiplicand                      1B/W
#define REG_WRMPYB       BYTE_FROM_ADDRESS(0x4203)   // Set Unsigned  8-Bit Multiplier & Start Multiplication 1B/W
#define REG_WRDIVL       BYTE_FROM_ADDRESS(0x4204)   // Set Unsigned 16-Bit Dividend (Lower 8-Bit)            2B/W
#define REG_WRDIVH       BYTE_FROM_ADDRESS(0x4205)   // Set Unsigned 16-Bit Dividend (Upper 8-Bit)            1B/W
#define REG_WRDIVB       BYTE_FROM_ADDRESS(0x4206)   // Set Unsigned  8-Bit Divisor & Start Division          1B/W
#define REG_HTIMEL       BYTE_FROM_ADDRESS(0x4207)   // H-Count Timer Setting (Lower 8-Bit)                   2B/W
#define REG_HTIMEH       BYTE_FROM_ADDRESS(0x4208)   // H-Count Timer Setting (Upper 1bit)                    1B/W
#define REG_VTIMEL       BYTE_FROM_ADDRESS(0x4209)   // V-Count Timer Setting (Lower 8-Bit)                   2B/W
#define REG_VTIMEH       BYTE_FROM_ADDRESS(0x420A)   // V-Count Timer Setting (Upper 1-Bit)                   1B/W
#define REG_MDMAEN       BYTE_FROM_ADDRESS(0x420B)   // Select General Purpose DMA Channels & Start Transfer  1B/W
#define REG_HDMAEN       BYTE_FROM_ADDRESS(0x420C)   // Select H-Blank DMA (H-DMA) Channels                   1B/W
#define REG_MEMSEL       BYTE_FROM_ADDRESS(0x420D)   // Memory-2 Waitstate Control                            1B/W
// $420E..$420F - Unused Region (Open Bus)

// CPU On-Chip I/O Ports (Read-only)
#define REG_RDNMI        BYTE_FROM_ADDRESS(0x4210)    // V-Blank NMI Flag and CPU Version Number (Read/Ack)    1B/R
#define REG_TIMEUP       BYTE_FROM_ADDRESS(0x4211)   // H/V-Timer IRQ Flag (Read/Ack)                         1B/R
#define REG_HVBJOY       BYTE_FROM_ADDRESS(0x4212)   // H/V-Blank Flag & Joypad Busy Flag                     1B/R
#define REG_RDIO         BYTE_FROM_ADDRESS(0x4213)     // Joypad Programmable I/O Port (Input)                  1B/R
#define REG_RDDIVL       BYTE_FROM_ADDRESS(0x4214)   // Unsigned Div Result (Quotient) (Lower 8-Bit)          2B/R
#define REG_RDDIVH       BYTE_FROM_ADDRESS(0x4215)   // Unsigned Div Result (Quotient) (Upper 8-Bit)          1B/R
#define REG_RDMPYL       BYTE_FROM_ADDRESS(0x4216)   // Unsigned Div Remainder / Mul Product (Lower 8-Bit)    2B/R
#define REG_RDMPYH       BYTE_FROM_ADDRESS(0x4217)   // Unsigned Div Remainder / Mul Product (Upper 8-Bit)    1B/R
#define REG_JOY1L        BYTE_FROM_ADDRESS(0x4218)    // Joypad 1 (Gameport 1, Pin 4) (Lower 8-Bit)            2B/R
#define REG_JOY1H        BYTE_FROM_ADDRESS(0x4219)    // Joypad 1 (Gameport 1, Pin 4) (Upper 8-Bit)            1B/R
#define REG_JOY2L        BYTE_FROM_ADDRESS(0x421A)    // Joypad 2 (Gameport 2, Pin 4) (Lower 8-Bit)            2B/R
#define REG_JOY2H        BYTE_FROM_ADDRESS(0x421B)    // Joypad 2 (Gameport 2, Pin 4) (Upper 8-Bit)            1B/R
#define REG_JOY3L        BYTE_FROM_ADDRESS(0x421C)    // Joypad 3 (Gameport 1, Pin 5) (Lower 8-Bit)            2B/R
#define REG_JOY3H        BYTE_FROM_ADDRESS(0x421D)    // Joypad 3 (Gameport 1, Pin 5) (Upper 8-Bit)            1B/R
#define REG_JOY4L        BYTE_FROM_ADDRESS(0x421E)    // Joypad 4 (Gameport 2, Pin 5) (Lower 8-Bit)            2B/R
#define REG_JOY4H        BYTE_FROM_ADDRESS(0x421F)    // Joypad 4 (Gameport 2, Pin 5) (Upper 8-Bit)            1B/R
// $4220..$42FF - Unused Region (Open Bus)

// CPU DMA Ports (Read/Write) ($43XP X = Channel Number 0..7, P = Port)
#define REG_DMAP0        BYTE_FROM_ADDRESS(0x4300)    // DMA0 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD0        BYTE_FROM_ADDRESS(0x4301)    // DMA0 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T0L        BYTE_FROM_ADDRESS(0x4302)    // DMA0 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T0H        BYTE_FROM_ADDRESS(0x4303)    // DMA0 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B0         BYTE_FROM_ADDRESS(0x4304)     // DMA0 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS0L        BYTE_FROM_ADDRESS(0x4305)    // DMA0 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS0H        BYTE_FROM_ADDRESS(0x4306)    // DMA0 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB0        BYTE_FROM_ADDRESS(0x4307)    // DMA0 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A0L        BYTE_FROM_ADDRESS(0x4308)    // DMA0 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A0H        BYTE_FROM_ADDRESS(0x4309)    // DMA0 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL0        BYTE_FROM_ADDRESS(0x430A)    // DMA0 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED0      BYTE_FROM_ADDRESS(0x430B)  // DMA0 Unused Byte                                      1B/RW
// $430C..$430E - Unused Region (Open Bus)
#define REG_MIRR0        BYTE_FROM_ADDRESS(0x430F)    // DMA0 Mirror Of $430B                                  1B/RW

#define REG_DMAP1        BYTE_FROM_ADDRESS(0x4310)    // DMA1 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD1        BYTE_FROM_ADDRESS(0x4311)    // DMA1 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T1L        BYTE_FROM_ADDRESS(0x4312)    // DMA1 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T1H        BYTE_FROM_ADDRESS(0x4313)    // DMA1 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B1         BYTE_FROM_ADDRESS(0x4314)     // DMA1 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS1L        BYTE_FROM_ADDRESS(0x4315)    // DMA1 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS1H        BYTE_FROM_ADDRESS(0x4316)    // DMA1 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB1        BYTE_FROM_ADDRESS(0x4317)    // DMA1 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A1L        BYTE_FROM_ADDRESS(0x4318)    // DMA1 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A1H        BYTE_FROM_ADDRESS(0x4319)    // DMA1 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL1        BYTE_FROM_ADDRESS(0x431A)    // DMA1 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED1      BYTE_FROM_ADDRESS(0x431B)  // DMA1 Unused Byte                                      1B/RW
// $431C..$431E - Unused Region (Open Bus)
#define REG_MIRR1        BYTE_FROM_ADDRESS(0x431F)    // DMA1 Mirror Of $431B                                  1B/RW

#define REG_DMAP2        BYTE_FROM_ADDRESS(0x4320)    // DMA2 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD2        BYTE_FROM_ADDRESS(0x4321)    // DMA2 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T2L        BYTE_FROM_ADDRESS(0x4322)    // DMA2 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T2H        BYTE_FROM_ADDRESS(0x4323)    // DMA2 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B2         BYTE_FROM_ADDRESS(0x4324)     // DMA2 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS2L        BYTE_FROM_ADDRESS(0x4325)    // DMA2 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS2H        BYTE_FROM_ADDRESS(0x4326)    // DMA2 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB2        BYTE_FROM_ADDRESS(0x4327)    // DMA2 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A2L        BYTE_FROM_ADDRESS(0x4328)    // DMA2 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A2H        BYTE_FROM_ADDRESS(0x4329)    // DMA2 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL2        BYTE_FROM_ADDRESS(0x432A)    // DMA2 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED2      BYTE_FROM_ADDRESS(0x432B)  // DMA2 Unused Byte                                      1B/RW
// $432C..$432E - Unused Region (Open Bus)
#define REG_MIRR2        BYTE_FROM_ADDRESS(0x432F)    // DMA2 Mirror Of $432B                                  1B/RW

#define REG_DMAP3        BYTE_FROM_ADDRESS(0x4330)    // DMA3 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD3        BYTE_FROM_ADDRESS(0x4331)    // DMA3 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T3L        BYTE_FROM_ADDRESS(0x4332)    // DMA3 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T3H        BYTE_FROM_ADDRESS(0x4333)    // DMA3 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B3         BYTE_FROM_ADDRESS(0x4334)     // DMA3 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS3L        BYTE_FROM_ADDRESS(0x4335)    // DMA3 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS3H        BYTE_FROM_ADDRESS(0x4336)    // DMA3 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB3        BYTE_FROM_ADDRESS(0x4337)    // DMA3 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A3L        BYTE_FROM_ADDRESS(0x4338)    // DMA3 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A3H        BYTE_FROM_ADDRESS(0x4339)    // DMA3 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL3        BYTE_FROM_ADDRESS(0x433A)    // DMA3 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED3      BYTE_FROM_ADDRESS(0x433B)  // DMA3 Unused Byte                                      1B/RW
// $433C..$433E - Unused Region (Open Bus)
#define REG_MIRR3        BYTE_FROM_ADDRESS(0x433F)    // DMA3 Mirror Of $433B                                  1B/RW

#define REG_DMAP4        BYTE_FROM_ADDRESS(0x4340)    // DMA4 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD4        BYTE_FROM_ADDRESS(0x4341)    // DMA4 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T4L        BYTE_FROM_ADDRESS(0x4342)    // DMA4 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T4H        BYTE_FROM_ADDRESS(0x4343)    // DMA4 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B4         BYTE_FROM_ADDRESS(0x4344)     // DMA4 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS4L        BYTE_FROM_ADDRESS(0x4345)    // DMA4 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS4H        BYTE_FROM_ADDRESS(0x4346)    // DMA4 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB4        BYTE_FROM_ADDRESS(0x4347)    // DMA4 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A4L        BYTE_FROM_ADDRESS(0x4348)    // DMA4 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A4H        BYTE_FROM_ADDRESS(0x4349)    // DMA4 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL4        BYTE_FROM_ADDRESS(0x434A)    // DMA4 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED4      BYTE_FROM_ADDRESS(0x434B)  // DMA4 Unused Byte                                      1B/RW
// $434C..$434E - Unused Region (Open Bus)
#define REG_MIRR4        BYTE_FROM_ADDRESS(0x434F)    // DMA4 Mirror Of $434B                                  1B/RW

#define REG_DMAP5        BYTE_FROM_ADDRESS(0x4350)    // DMA5 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD5        BYTE_FROM_ADDRESS(0x4351)    // DMA5 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T5L        BYTE_FROM_ADDRESS(0x4352)    // DMA5 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T5H        BYTE_FROM_ADDRESS(0x4353)    // DMA5 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B5         BYTE_FROM_ADDRESS(0x4354)     // DMA5 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS5L        BYTE_FROM_ADDRESS(0x4355)    // DMA5 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS5H        BYTE_FROM_ADDRESS(0x4356)    // DMA5 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB5        BYTE_FROM_ADDRESS(0x4357)    // DMA5 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A5L        BYTE_FROM_ADDRESS(0x4358)    // DMA5 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A5H        BYTE_FROM_ADDRESS(0x4359)    // DMA5 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL5        BYTE_FROM_ADDRESS(0x435A)    // DMA5 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED5      BYTE_FROM_ADDRESS(0x435B)  // DMA5 Unused Byte                                      1B/RW
// $435C..$435E - Unused Region (Open Bus)
#define REG_MIRR5        BYTE_FROM_ADDRESS(0x435F)    // DMA5 Mirror Of $435B                                  1B/RW

#define REG_DMAP6        BYTE_FROM_ADDRESS(0x4360)    // DMA6 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD6        BYTE_FROM_ADDRESS(0x4361)    // DMA6 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T6L        BYTE_FROM_ADDRESS(0x4362)    // DMA6 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T6H        BYTE_FROM_ADDRESS(0x4363)    // DMA6 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B6         BYTE_FROM_ADDRESS(0x4364)     // DMA6 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS6L        BYTE_FROM_ADDRESS(0x4365)    // DMA6 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS6H        BYTE_FROM_ADDRESS(0x4366)    // DMA6 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB6        BYTE_FROM_ADDRESS(0x4367)    // DMA6 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A6L        BYTE_FROM_ADDRESS(0x4368)    // DMA6 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A6H        BYTE_FROM_ADDRESS(0x4369)    // DMA6 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL6        BYTE_FROM_ADDRESS(0x436A)    // DMA6 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED6      BYTE_FROM_ADDRESS(0x436B)  // DMA6 Unused Byte                                      1B/RW
// $436C..$436E - Unused Region (Open Bus)
#define REG_MIRR6        BYTE_FROM_ADDRESS(0x436F)    // DMA6 Mirror Of $436B                                  1B/RW

#define REG_DMAP7        BYTE_FROM_ADDRESS(0x4370)    // DMA7 DMA/HDMA Parameters                              1B/RW
#define REG_BBAD7        BYTE_FROM_ADDRESS(0x4371)    // DMA7 DMA/HDMA I/O-Bus Address (PPU-Bus AKA B-Bus)     1B/RW
#define REG_A1T7L        BYTE_FROM_ADDRESS(0x4372)    // DMA7 DMA/HDMA Table Start Address (Lower 8-Bit)       2B/RW
#define REG_A1T7H        BYTE_FROM_ADDRESS(0x4373)    // DMA7 DMA/HDMA Table Start Address (Upper 8-Bit)       1B/RW
#define REG_A1B7         BYTE_FROM_ADDRESS(0x4374)     // DMA7 DMA/HDMA Table Start Address (Bank)              1B/RW
#define REG_DAS7L        BYTE_FROM_ADDRESS(0x4375)    // DMA7 DMA Count / Indirect HDMA Address (Lower 8-Bit)  2B/RW
#define REG_DAS7H        BYTE_FROM_ADDRESS(0x4376)    // DMA7 DMA Count / Indirect HDMA Address (Upper 8-Bit)  1B/RW
#define REG_DASB7        BYTE_FROM_ADDRESS(0x4377)    // DMA7 Indirect HDMA Address (Bank)                     1B/RW
#define REG_A2A7L        BYTE_FROM_ADDRESS(0x4378)    // DMA7 HDMA Table Current Address (Lower 8-Bit)         2B/RW
#define REG_A2A7H        BYTE_FROM_ADDRESS(0x4379)    // DMA7 HDMA Table Current Address (Upper 8-Bit)         1B/RW
#define REG_NTRL7        BYTE_FROM_ADDRESS(0x437A)    // DMA7 HDMA Line-Counter (From Current Table entry)     1B/RW
#define REG_UNUSED7      BYTE_FROM_ADDRESS(0x437B)  // DMA7 Unused Byte                                      1B/RW
// $437C..$437E - Unused Region (Open Bus)
#define REG_MIRR7        BYTE_FROM_ADDRESS(0x437F)    // DMA7 Mirror Of $437B                                  1B/RW
// $4380..$5FFF - Unused Region (Open Bus)

// Further Memory
// $6000..$7FFF - Expansion (Battery Backed RAM, In HiROM Cartridges)
// $8000..$FFFF - Cartridge ROM
#endif
