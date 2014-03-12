/********************************************************************
*  Program to make an LCD on an AVR function like an Oscilloscope!  *
*  			Alankar Kotwal				    *
* 		     Electronics Club, IITB		       	    *
********************************************************************/

#include<avr/io.h>
#include<util/delay.h>
#include"MrLCD.h"
#include"AnalogLib.h"
#include<cstdio>

int main()
{
	InitializeMrLCD();
	ADCInit();

	while(1)
	{
		GotoMrLCDsPosition(1,1);
		Send_A_String(itoa(ADCRead(0)));
	}
}
