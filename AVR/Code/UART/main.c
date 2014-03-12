#include<avr/io.h>
#include<string.h>

void UART_init(int);
void UART_Transmit(char);
char UART_Receive();

int main()
{
	UART_init(9600);

	UART_Transmit('z');

	while(1)
	{
	}
}

void UART_init(int baud)
{
	UBRRH=(baud>>8);
	UBRRL=baud;
	UCSRB=(1<<RXEN)|(1<<TXEN);
	UCSRC=(1<<URSEL)|(3<<UCSZ0);
}

void UART_Transmit(char data)
{
	while ( !(UCSRA & (1<<UDRE)) );
	UDR=data;
}


char UART_Receive()
{
	while ( !(UCSRA & (1<<RXC)) );
	return UDR;
}
