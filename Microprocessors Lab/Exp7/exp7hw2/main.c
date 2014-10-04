#include<regx51.h>

sfr SPCON=0xC3;
sfr SPSTA=0xC4;
sfr SPDAT=0xC5;
sbit SS_ADC=P2^0;
sbit SS_DAC=P2^2;

unsigned int high_byte;
unsigned int low_byte;
unsigned int temp;

int main() {
	SPCON=0x3F;
	SPCON|=0x40;
	
	P2=0x00;
	P2=0xFF;
	
	while(1) {
		SS_ADC=0;
		SPDAT=0x01;
		while(SPSTA!=0x80);
		SPDAT=0x80;
		while(SPSTA!=0x80);
		high_byte=SPDAT;
		while(SPSTA!=0x80);
		low_byte=SPDAT;
		SS_ADC=1;
		
		high_byte &= 0x03;
		high_byte *= 4;
		high_byte += 0x70;
		temp = low_byte/64;
		high_byte += temp;
		low_byte *= 4;
			
		SS_DAC=0;
		SPDAT=high_byte;
		while(SPSTA!=0x80);
		SPDAT=low_byte;
		while(SPSTA!=0x80);
		SS_DAC=1;
	}
}