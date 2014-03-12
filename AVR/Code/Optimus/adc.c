#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdlib.h>
#include <util/delay.h>

volatile float sl=0;

void adc_init(void){
	ADCSRA |=((_BV(ADPS2))|_BV((ADPS1))|_BV((ADPS0)));		//125khz
	ADMUX |= _BV(REFS0);
	ADCSRA|=_BV(ADIE);
	ADCSRA |= _BV(ADEN);		//*
}

void port_init(void)
{
   DDRF=0x00;
   PORTF=0x00;
   DDRC = 0xff;
   PORTC = 0x00;
}

int main()
{
	port_init();
	adc_init();
	sei();			//*
	ADCSRA |= _BV(ADSC);			//*

	while (1)
	{
	}
}

ISR(ADC_vect)
{
	sl = ADCL + ADCH*256;

	if(sl>512){ PORTC=0xff;}
	else{PORTC = 0x00;}
	
	ADCSRA |=_BV(ADSC);
}
