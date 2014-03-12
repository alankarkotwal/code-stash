#include<avr/io.h>
#include<util/delay.h>
#include"MrLCD.h"

int main()
{
	InitializeMrLCD();

	int i=1;

	while(1)
	{
		GotoMrLCDsLocation(i-1,3);
		Send_A_String(" ");
		GotoMrLCDsLocation(i,3);
		Send_A_String("x");
		i++;
		_delay_ms(1000);
	}
}
