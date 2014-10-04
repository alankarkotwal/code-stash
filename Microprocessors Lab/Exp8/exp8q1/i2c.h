#ifndef _I2C_H
#define _I2C_H

sfr SSCON=0x93;
sfr IEN1=0xB1;
sfr SSCS=0x94;
sfr SSDAT=0x95;

typedef unsigned char uchar;

void i2c_init();
void i2c_send();
void i2c_recieve();

#endif