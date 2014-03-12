#include<avr/io.h>
#include<avr/interrupt.h>
#include"MrLCD.h"

int main()
{
	DDRD = 0b10000000;
	PORTD &= !(1<<PIND7);
	
	sei();
	
	adcInit();
	InitializeMrLCD();
		
	while(1)
	{

	}
}

ISR(ADC_vect)
{
	Send_A_Command(1);
	Send_A_String("Done!");
	_delay_ms(1000);
	Send_A_Command(1);
}

void adcInit()
{
	ADCSRA |= 1<<ADPS2;
	ADMUX |= 1<<ADLAR;
	ADMUX |= 1<<REFS0;
	ADCSRA |= 1<<ADIE;
	ADCSRA |= 1<<ADEN;
	
	ADCSRA |= 1<<ADSC;
}

int adcRead()
{
	return ADCH;
}
