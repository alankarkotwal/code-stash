#include<avr/io.h>
#include<util/delay.h>

int main()
{
	DDRC |= (1<<PINC0|1<<PINC1);
	PORTC &= ~(1<<PINC0);
	PORTC |= (1<<PINC0|1<<PINC1);

	_delay_ms(2000);

	while(1)
	{
		if(bit_is_clear(PINC,0))
		{
			PORTC &= ~(1<<PINC1);
			break;
		}
	}

	while(1);
}
