//
// C64 generic definitions. Stolen from Elite128
//
#ifndef C64_H
#define C64_H

#include "system.h"

// ---------------------------------------------------------------------------
// Screen size

#define XSIZE             40
#define YSIZE             25

// ---------------------------------------------------------------------------
// I/O: VIC

#define VIC              BYTE_FROM_ADDRESS(0xD000)
#define VIC_SPR0_X       BYTE_FROM_ADDRESS(0xD000)
#define VIC_SPR0_Y       BYTE_FROM_ADDRESS(0xD001)
#define VIC_SPR1_X       BYTE_FROM_ADDRESS(0xD002)
#define VIC_SPR1_Y       BYTE_FROM_ADDRESS(0xD003)
#define VIC_SPR2_X       BYTE_FROM_ADDRESS(0xD004)
#define VIC_SPR2_Y       BYTE_FROM_ADDRESS(0xD005)
#define VIC_SPR3_X       BYTE_FROM_ADDRESS(0xD006)
#define VIC_SPR3_Y       BYTE_FROM_ADDRESS(0xD007)
#define VIC_SPR4_X       BYTE_FROM_ADDRESS(0xD008)
#define VIC_SPR4_Y       BYTE_FROM_ADDRESS(0xD009)
#define VIC_SPR5_X       BYTE_FROM_ADDRESS(0xD00A)
#define VIC_SPR5_Y       BYTE_FROM_ADDRESS(0xD00B)
#define VIC_SPR6_X       BYTE_FROM_ADDRESS(0xD00C)
#define VIC_SPR6_Y       BYTE_FROM_ADDRESS(0xD00D)
#define VIC_SPR7_X       BYTE_FROM_ADDRESS(0xD00E)
#define VIC_SPR7_Y       BYTE_FROM_ADDRESS(0xD00F)
#define VIC_SPR_HI_X     BYTE_FROM_ADDRESS(0xD010)
#define VIC_SPR_ENA      BYTE_FROM_ADDRESS(0xD015)
#define VIC_SPR_EXP_Y    BYTE_FROM_ADDRESS(0xD017)
#define VIC_SPR_EXP_X    BYTE_FROM_ADDRESS(0xD01D)
#define VIC_SPR_MCOLOR   BYTE_FROM_ADDRESS(0xD01C)
#define VIC_SPR_BG_PRIO  BYTE_FROM_ADDRESS(0xD01B)

#define VIC_SPR_SP_COL   BYTE_FROM_ADDRESS(0xD01E)
#define VIC_SPR_BG_COL   BYTE_FROM_ADDRESS(0xD01F)

#define VIC_SPR_MCOLOR0  BYTE_FROM_ADDRESS(0xD025)
#define VIC_SPR_MCOLOR1  BYTE_FROM_ADDRESS(0xD026)

#define VIC_SPR0_COLOR   BYTE_FROM_ADDRESS(0xD027)
#define VIC_SPR1_COLOR   BYTE_FROM_ADDRESS(0xD028)
#define VIC_SPR2_COLOR   BYTE_FROM_ADDRESS(0xD029)
#define VIC_SPR3_COLOR   BYTE_FROM_ADDRESS(0xD02A)
#define VIC_SPR4_COLOR   BYTE_FROM_ADDRESS(0xD02B)
#define VIC_SPR5_COLOR   BYTE_FROM_ADDRESS(0xD02C)
#define VIC_SPR6_COLOR   BYTE_FROM_ADDRESS(0xD02D)
#define VIC_SPR7_COLOR   BYTE_FROM_ADDRESS(0xD02E)

#define SPR_X_SCREEN_LEFT   24
#define SPR_Y_SCREEN_TOP    50

#define VIC_CTRL1        BYTE_FROM_ADDRESS(0xD011)
#define VIC_CTRL2        BYTE_FROM_ADDRESS(0xD016)

#define VIC_HLINE        BYTE_FROM_ADDRESS(0xD012)

#define VIC_VIDEO_ADR    BYTE_FROM_ADDRESS(0xD018)

#define VIC_IRR          BYTE_FROM_ADDRESS(0xD019)        // Interrupt request register
#define VIC_IMR          BYTE_FROM_ADDRESS(0xD01A) // Interrupt mask register

#define VIC_BORDERCOLOR  BYTE_FROM_ADDRESS(0xD020)
#define VIC_BG_COLOR0    BYTE_FROM_ADDRESS(0xD021)
#define VIC_BG_COLOR1    BYTE_FROM_ADDRESS(0xD022)
#define VIC_BG_COLOR2    BYTE_FROM_ADDRESS(0xD023)
#define VIC_BG_COLOR3    BYTE_FROM_ADDRESS(0xD024)


// ---------------------------------------------------------------------------
// I/O: SID

#define SID              BYTE_FROM_ADDRESS(0xD400)
#define SID_S1Lo         BYTE_FROM_ADDRESS(0xD400)
#define SID_S1Hi         BYTE_FROM_ADDRESS(0xD401)
#define SID_PB1Lo        BYTE_FROM_ADDRESS(0xD402)
#define SID_PB1Hi        BYTE_FROM_ADDRESS(0xD403)
#define SID_Ctl1         BYTE_FROM_ADDRESS(0xD404)
#define SID_AD1          BYTE_FROM_ADDRESS(0xD405)
#define SID_SUR1         BYTE_FROM_ADDRESS(0xD406)

#define SID_S2Lo         BYTE_FROM_ADDRESS(0xD407)
#define SID_S2Hi         BYTE_FROM_ADDRESS(0xD408)
#define SID_PB2Lo        BYTE_FROM_ADDRESS(0xD409)
#define SID_PB2Hi        BYTE_FROM_ADDRESS(0xD40A)
#define SID_Ctl2         BYTE_FROM_ADDRESS(0xD40B)
#define SID_AD2          BYTE_FROM_ADDRESS(0xD40C)
#define SID_SUR2         BYTE_FROM_ADDRESS(0xD40D)

#define SID_S3Lo         BYTE_FROM_ADDRESS(0xD40E)
#define SID_S3Hi         BYTE_FROM_ADDRESS(0xD40F)
#define SID_PB3Lo        BYTE_FROM_ADDRESS(0xD410)
#define SID_PB3Hi        BYTE_FROM_ADDRESS(0xD411)
#define SID_Ctl3         BYTE_FROM_ADDRESS(0xD412)
#define SID_AD3          BYTE_FROM_ADDRESS(0xD413)
#define SID_SUR3         BYTE_FROM_ADDRESS(0xD414)

#define SID_FltLo        BYTE_FROM_ADDRESS(0xD415)
#define SID_FltHi        BYTE_FROM_ADDRESS(0xD416)
#define SID_FltCtl       BYTE_FROM_ADDRESS(0xD417)
#define SID_Amp          BYTE_FROM_ADDRESS(0xD418)
#define SID_ADConv1      BYTE_FROM_ADDRESS(0xD419)
#define SID_ADConv2      BYTE_FROM_ADDRESS(0xD41A)
#define SID_Noise        BYTE_FROM_ADDRESS(0xD41B)
#define SID_Read3        BYTE_FROM_ADDRESS(0xD41C)

// ---------------------------------------------------------------------------
// I/O: CIAs

#define CIA1             BYTE_FROM_ADDRESS(0xDC00)
#define CIA1_PRA         BYTE_FROM_ADDRESS(0xDC00)
#define CIA1_PRB         BYTE_FROM_ADDRESS(0xDC01)
#define CIA1_DDRA        BYTE_FROM_ADDRESS(0xDC02)
#define CIA1_DDRB        BYTE_FROM_ADDRESS(0xDC03)
#define CIA1_TOD10       BYTE_FROM_ADDRESS(0xDC08)
#define CIA1_TODSEC      BYTE_FROM_ADDRESS(0xDC09)
#define CIA1_TODMIN      BYTE_FROM_ADDRESS(0xDC0A)
#define CIA1_TODHR       BYTE_FROM_ADDRESS(0xDC0B)
#define CIA1_ICR         BYTE_FROM_ADDRESS(0xDC0D)
#define CIA1_CRA         BYTE_FROM_ADDRESS(0xDC0E)
#define CIA1_CRB         BYTE_FROM_ADDRESS(0xDC0F)

#define CIA2             BYTE_FROM_ADDRESS(0xDD00)
#define CIA2_PRA         BYTE_FROM_ADDRESS(0xDD00)
#define CIA2_PRB         BYTE_FROM_ADDRESS(0xDD01)
#define CIA2_DDRA        BYTE_FROM_ADDRESS(0xDD02)
#define CIA2_DDRB        BYTE_FROM_ADDRESS(0xDD03)
#define CIA2_TOD10       BYTE_FROM_ADDRESS(0xDD08)
#define CIA2_TODSEC      BYTE_FROM_ADDRESS(0xDD09)
#define CIA2_TODMIN      BYTE_FROM_ADDRESS(0xDD0A)
#define CIA2_TODHR       BYTE_FROM_ADDRESS(0xDD0B)
#define CIA2_ICR         BYTE_FROM_ADDRESS(0xDD0D)
#define CIA2_CRA         BYTE_FROM_ADDRESS(0xDD0E)
#define CIA2_CRB         BYTE_FROM_ADDRESS(0xDD0F)

// ---------------------------------------------------------------------------
// Processor Port at $01

#define LORAM    0x01     // Enable the basic rom
#define HIRAM    0x02     // Enable the kernal rom
#define IOEN     0x04     // Enable I/O
#define CASSDATA   0x08     // Cassette data
#define CASSPLAY   0x10     // Cassette: Play
#define CASSMOT    0x20     // Cassette motor on
#define TP_FAST    0x80     // Switch Rossmoeller TurboProcess to fast mode

#define RAMONLY    0xF8     // (~(LORAM | HIRAM | IOEN)) & $FF


// -----------
// Color codes

#define COLOR_BLACK                    0
#define COLOR_WHITE                    1
#define COLOR_RED                      2
#define COLOR_CYAN                     3
#define COLOR_PURPLE                   4
#define COLOR_GREEN                    5
#define COLOR_BLUE                     6
#define COLOR_YELLOW                   7
#define COLOR_ORANGE                   8
#define COLOR_BROWN                    9
#define COLOR_PINK                     10
#define COLOR_DARK_GREY                11
#define COLOR_GREY                     12
#define COLOR_LIGHT_GREEN              13
#define COLOR_LIGHT_BLUE               14
#define COLOR_LIGHT_GREY               15

// ---------------------------------------------------------------------------
// Additional defines (not stolen from Elite128).

//address of the screen buffer
#define SCREEN_CHAR                   BYTE_FROM_ADDRESS(0xcc00)
#define SCREEN_CHAR_SIZE              BYTE_FROM_ADDRESS(0x400)

//address of color ram
#define SCREEN_COLOR                  BYTE_FROM_ADDRESS(0xd800)

#define SPRITE_GRAPHICS_TARGET        BYTE_FROM_ADDRESS(0xd000)
#define CHARACTER_GRAPHICS_TARGET     BYTE_FROM_ADDRESS(0xf000)
  
#define NUMBER_OF_HARDWARE_SPRITES     8

//address of sprite pointers
#define SPRITE_POINTER_BASE            SCREEN_CHAR + SCREEN_CHAR_SIZE - NUMBER_OF_HARDWARE_SPRITES

#define SCREEN_CHAR_WIDTH              40
#define SCREEN_CHAR_HEIGHT             25

#define SCREEN_BORDER_THICKNESS_X      24
#define SCREEN_BORDER_THICKNESS_Y      50

//sprite number constants
#define SPRITE_BASE                    64
#endif
