/*
Library for running the ADC on an ATmega32
Author: Alankar Kotwal
Date: 11/07/2013
Electronics Club, IIT Bombay
*/


#ifndef AnalogLib
#define AnalogLib

void ADCInit(void);
int ADCRead(void); // Only for PINA0

void ADCInit()
{
	ADCSRA |= (1<<ADEN);
	ADMUX |= (1<<ADLAR|1<<REFS0);
	ADCSRA |= (1<<ADPS2);
	ADCSRA |= (1<<ADSC);
}

int ADCRead()
{
	ADCSRA |= (1<<ADSC);
	while(!(ADCSRA & (1<<ADSC)));
	return ADCH;
}

#endif
