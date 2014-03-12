#include<avr/io.h>
#include<util/delay.h>
#include"MrLCD.h"
#include<stdio.h>

#define size 20
#define res 5

char out[4];

int main()
{
	InitializeMrLCD();
	ADCInit();
	
	while(1)
	{
		itoa(ADCRead(0),out);
		Send_A_String(out);
	}
}
