#include"MrLCD.h"

int main()
{
	InitializeMrLCD();

	GotoMrLCDsLocation(1,1);

	Send_A_String("Revati is an idiot");

	while(1);
}
