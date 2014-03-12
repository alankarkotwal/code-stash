#include<avr/io.h>

void UARTInit(unsigned int);
unsigned char UARTReceive(void);

int main()
{
	DDRB = (1<<PINB0);
	PORTB |= (1<<PINB0);

	UARTInit(6);

	while(1)
	{
		if(UARTReceive() == 0x61)
		{
			PORTB ^= (1<<PINB0);
		}
		else
		{
		}
	}
}

void UARTInit(unsigned int rate)
{
	UBRRH = (unsigned char)(rate>>8);
	UBRRL = (unsigned char)rate;
	UCSRB = (1<<RXEN)|(1<<TXEN);
	UCSRC = (1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1);
}

unsigned char UARTReceive(void)
{
	while(!(UCSRA & (1<<RXC)))
	{
	}
	return UDR;
}
