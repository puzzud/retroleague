//
// Apple II generic definitions.
//

#ifndef APPLE2_H
#define APPLE2_H

#define HI_RES_PAGE_SIZE        8192
#define HI_RES_PAGE_1           BYTE_FROM_ADDRESS(0x2000)
#define HI_RES_PAGE_2           BYTE_FROM_ADDRESS(0x4000)

#define KEYBOARD                BYTE_FROM_ADDRESS(0xc000)

#define CLR80STORE              BYTE_FROM_ADDRESS(0xc000)
#define SET80STORE              BYTE_FROM_ADDRESS(0xc001)

#define CLRAUXRD                BYTE_FROM_ADDRESS(0xc002)
#define SETAUXRD                BYTE_FROM_ADDRESS(0xc003)

#define CLRAUXWR                BYTE_FROM_ADDRESS(0xc004)
#define SETAUXWR                BYTE_FROM_ADDRESS(0xc005)

#define CLRCXROM                BYTE_FROM_ADDRESS(0xc006)
#define SETCXROM                BYTE_FROM_ADDRESS(0xc007)

#define CLRAUXZP                BYTE_FROM_ADDRESS(0xc008)
#define SETAUXZP                BYTE_FROM_ADDRESS(0xc009)

#define CLRC3ROM                BYTE_FROM_ADDRESS(0xc00a)
#define SETC3ROM                BYTE_FROM_ADDRESS(0xc00b)

#define CLR80VID                BYTE_FROM_ADDRESS(0xc00c)
#define SET80VID                BYTE_FROM_ADDRESS(0xc00d)

#define CLRALTCH                BYTE_FROM_ADDRESS(0xc00e)
#define SETALTCH                BYTE_FROM_ADDRESS(0xc00f)

#define STROBE                  BYTE_FROM_ADDRESS(0xc010)

#define RDLCBNK2                BYTE_FROM_ADDRESS(0xc011)
#define RDLCRAM                 BYTE_FROM_ADDRESS(0xc012)
#define RDRAMRD                 BYTE_FROM_ADDRESS(0xc013)
#define RDRAMWR                 BYTE_FROM_ADDRESS(0xc014)
#define RDCXROM                 BYTE_FROM_ADDRESS(0xc015)
#define RDAUXZP                 BYTE_FROM_ADDRESS(0xc016)
#define RDC3ROM                 BYTE_FROM_ADDRESS(0xc017)
#define RD80COL                 BYTE_FROM_ADDRESS(0xc018)
#define RDVBLBAR                BYTE_FROM_ADDRESS(0xc019)
#define RDTEXT                  BYTE_FROM_ADDRESS(0xc01a)
#define RDMIXED                 BYTE_FROM_ADDRESS(0xc01b)
#define RDPAGE2                 BYTE_FROM_ADDRESS(0xc01c)
#define RDHIRES                 BYTE_FROM_ADDRESS(0xc01d)
#define RDALTCH                 BYTE_FROM_ADDRESS(0xc01e)
#define RD80VID                 BYTE_FROM_ADDRESS(0xc01f)

#define TAPEOUT                 BYTE_FROM_ADDRESS(0xc020)

#define SPEAKER                 BYTE_FROM_ADDRESS(0xc030)

//#define STROBE                  BYTE_FROM_ADDRESS(0xc040)

#define CLRTEXT                 BYTE_FROM_ADDRESS(0xc050)
#define SETTEXT                 BYTE_FROM_ADDRESS(0xc051)

#define CLRMIXED                BYTE_FROM_ADDRESS(0xc052)
#define SETMIXED                BYTE_FROM_ADDRESS(0xc053)

#define PAGE1                   BYTE_FROM_ADDRESS(0xc054)
#define PAGE2                   BYTE_FROM_ADDRESS(0xc055)

#define CLRHIRES                BYTE_FROM_ADDRESS(0xc056)
#define SETHIRES                BYTE_FROM_ADDRESS(0xc057)

#define SETAN0                  BYTE_FROM_ADDRESS(0xc058)
#define CLRAN0                  BYTE_FROM_ADDRESS(0xc059)
#define SETAN1                  BYTE_FROM_ADDRESS(0xc05a)
#define CLRAN1                  BYTE_FROM_ADDRESS(0xc05b)
#define SETAN2                  BYTE_FROM_ADDRESS(0xc05c)
#define CLRAN2                  BYTE_FROM_ADDRESS(0xc05d)
#define SETAN3                  BYTE_FROM_ADDRESS(0xc05e)
#define SETDHIRES               BYTE_FROM_ADDRESS(0xc05e)
#define CLRAN3                  BYTE_FROM_ADDRESS(0xc05f)
#define CLRDHIRES               BYTE_FROM_ADDRESS(0xc05f)

#define TAPEIN                  BYTE_FROM_ADDRESS(0xc060)

#define PB3                     BYTE_FROM_ADDRESS(0xc060)

#define OPNAPPLE                BYTE_FROM_ADDRESS(0xc061)

#define PB0                     BYTE_FROM_ADDRESS(0xc061)

#define CLSAPPLE                BYTE_FROM_ADDRESS(0xc062)

#define PB1                     BYTE_FROM_ADDRESS(0xc062)
#define PB2                     BYTE_FROM_ADDRESS(0xc063)

#define PADDLE0                 BYTE_FROM_ADDRESS(0xc064)
#define PADDLE1                 BYTE_FROM_ADDRESS(0xc065)
#define PADDLE2                 BYTE_FROM_ADDRESS(0xc066)
#define PADDLE3                 BYTE_FROM_ADDRESS(0xc067)
#define PDLTRIG                 BYTE_FROM_ADDRESS(0xc070)

#define SETIOUDIS               BYTE_FROM_ADDRESS(0xc07e)
#define CLRIOUDIS               BYTE_FROM_ADDRESS(0xc07e)

#define ROMIN                   BYTE_FROM_ADDRESS(0xc081)
#define LCBANK2                 BYTE_FROM_ADDRESS(0xc083)
#define LCBANK1                 BYTE_FROM_ADDRESS(0xc08b)

#define SCREEN_LINE_WIDTH       40
#define SCREEN_LINE_HEIGHT      192

#define SCREEN_CHAR_WIDTH       35
#define SCREEN_CHAR_HEIGHT      24

#define START_OF_RAM            BYTE_FROM_ADDRESS(0x0c00)

#define JOYSTICK_UP             0x01
#define JOYSTICK_DOWN           0x02
#define JOYSTICK_LEFT           0x04
#define JOYSTICK_RIGHT          0x08
#define JOYSTICK_BUTTON0        0x10
#define JOYSTICK_BUTTON1        0x20
#define JOYSTICK_BUTTON2        0x40
#define JOYSTICK_BUTTON3        0x80

#define CONTROLLER_LEFT         JOYSTICK_LEFT
#define CONTROLLER_RIGHT        JOYSTICK_RIGHT
#define CONTROLLER_UP           JOYSTICK_UP
#define CONTROLLER_DOWN         JOYSTICK_DOWN
#define CONTROLLER_BUTTON0      JOYSTICK_BUTTON0
#define CONTROLLER_BUTTON1      JOYSTICK_BUTTON1
#define CONTROLLER_BUTTON2      JOYSTICK_BUTTON2
#define CONTROLLER_BUTTON3      JOYSTICK_BUTTON3

#endif
