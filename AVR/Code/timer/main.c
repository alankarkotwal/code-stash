#include<avr/io.h>
#include<avr/interrupt.h>

int main()
{
	sei();
	TIMSK |= (1<<OCIE1A);

	DDRD = (1<<PIND5);

	TCCR1A |= (1<<COM1A0);
	OCR1A = 15625;

	TCCR1B |= (1<<CS11 | 1<<CS10);

	while(1)
	{
		// Do nothing
	}
}

ISR(TIMER1_COMPA_vect)
{
	TCNT1 = 0;
}
