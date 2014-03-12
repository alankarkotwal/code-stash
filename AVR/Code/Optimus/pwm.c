#include<avr/io.h>
#include <avr/interrupt.h>

volatile float sl=0;


void adc_init(void){
	ADCSRA |= _BV(ADPS0)|_BV(ADPS1)|_BV(ADPS2);
	ADMUX |= _BV(REFS0);
	
	ADCSRA |= _BV(ADEN);
}

void port_init(void)
{
   DDRF=0x00;
   PORTF=0x00;
   DDRB=0xff;
   PORTB = 0x00;

}

//ISR(TIMER_OVF_vect){

//}

int main(void)
{
	port_init();
	
	TCCR0A |= _BV(WGM00) | _BV(WGM01) | _BV(COM0A1);
	
	TIMSK1 |= _BV(TOIE0);
	adc_init();
	sei();
	TCCR0B |= _BV(CS01) | _BV(CS00) ;
	ADCSRA |= _BV(ADSC);
	while(1){
		ADCSRA |=_BV(ADSC);
		sl = ADCL+ADCH*256;
		OCR0A = (sl/1023)*256;
		sl=0;
	}
}
