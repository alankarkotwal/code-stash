#ifndef UART
#define UART

#include<avr/io.h>

void USART_Init (unsigned int baud)
{
	//Put the upper part of the baud number here (bits 8 to 11)
	UBBRH = (unsigned char) (baud >> 8);

	//Put the remaining part of the baud number here
	UBBRL = (unsigned char) baud;

	//Enable the receiver and transmitter
	UCSRB = (1 << RXEN) | (1 << TXEN);

	//Set 2 stop bits and data bit length is 8-bit
	UCSRC = (1 << URSEL) | (1 << USBS) | (3 << UCSZ0);
}

void USART_Transmit (unsigned int data)
{
	//Wait until the Transmitter is ready
	while (! (UCSRA & (1 << UDRE)) );

	//Make the 9th bit 0 for the moment
	UCSRB &=~(1 << TXB8);

	//If the 9th bit of the data is a 1
	if (data & 0x0100)

	//Set the TXB8 bit to 1
	USCRB |= (1 << TXB8);

	//Get that data outa here!
	UDR = data;
}

unsigned char USART_Receive( void )
{
	while ( !(UCSRA & (1 << RXC)) ); //Wait for the RXC to not have 0
	return UDR; //Get that data outa there and back to the main program!
}

#endif
