/*
 * Minimal MS51_16K register map for SDCC build.
 *
 * This project only needs a subset of MS51FB9AE/MS51XB9AE/MS51XB9BE SFR/SBIT
 * definitions referenced by platform_ms51.c. Keeping this minimal avoids
 * Keil-only BSP dependencies while preserving target-specific register access.
 */

#ifndef MS51_16K_H
#define MS51_16K_H

/* Ports */
__sfr __at(0x80) P0;
__sfr __at(0x90) P1;
__sfr __at(0xB0) P3;

/* Clock divider */
__sfr __at(0x95) CKDIV;

/* Port mode registers */
__sfr __at(0xB1) P0M1;
__sfr __at(0xB2) P0M2;
__sfr __at(0xB3) P1M1;
__sfr __at(0xB4) P1M2;
__sfr __at(0xAC) P3M1;
__sfr __at(0xAD) P3M2;

/* ADC registers */
__sfr __at(0xE1) ADCCON1;
__sfr __at(0xE8) ADCCON0;
__sfr __at(0xC2) ADCRL;
__sfr __at(0xC3) ADCRH;
__sfr __at(0xF6) AINDIDS;

/* Pins used by this project */
__sbit __at(0x80 + 0) P00;
__sbit __at(0x80 + 1) P01;

__sbit __at(0x90 + 0) P10;
__sbit __at(0x90 + 1) P11;
__sbit __at(0x90 + 2) P12;

#endif /* MS51_16K_H */
