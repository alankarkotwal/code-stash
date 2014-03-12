/***************************************************
*  Library for running the UART on Optimus, ATmega32u4 platform *
*  Author: Alankar Kotwal					     *
*  Date: 13/07/2013					     *
*  Electronics Club, IIT Bombay				     *
*****************************************************/

#include <avr/io.h>
#include <inttypes.h>

class UART
{
	public:
		uint8_t errorByte = 0b00000000; // Choose ErrorByte
		double fosc = 16000000;
		double baudrate = 19200;
		unsigned int  ubrrValue;
		void begin();
		void end();
		bool available();
		uint8_t readByte();
		void sendByte(uint8_t writeByte);
};

uint8_t UART::readUCSRC()
{
	uint8_t ucsrc;
	ucsrc = UBRRH;
	ucsrc = UCSRC;
	return ucsrc;
}

void UART::begin()
{
	while ((UCSRA>>RXC) & 1);
	while ((UCSRA>>TXC) & 1);
	ubrrValue = fosc/(16*baudrate)-1;
	UBRRL = ubrrValue;
	UBRRH = (ubrrValue>>8);
	UCSRC = (readUCSRC()|((1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0)));
	UCSRB &= (~(1<<UCSZ2));
	UCSRC = readUCSRC()&((1<<URSEL)|(~((1<<UPM1)|(1<<UPM0))));
	UCSRC = readUCSRC()&((1<<URSEL)|(~(1<<USBS)));
	UCSRA &= (~(1<<U2X));
	UCSRA &= 0b111000011;
	UCSRB |= (1<<RXEN)|(1<<TXEN);	
}

void UART::end()
{
	while(!((UCSRA>>UDRE) & 1));
	UCSRB &= (~((1<<RXEN)|(1<<TXEN)));
}

bool UART::available()
{
	if(((UCSRA>>RXC) & 1) == 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

uint8_t UART::readByte()
{
	while(!((UCSRA>>RXC) & 1));
	if( UCSRA & ((1<<FE)|(1<<DOR)|(1<<PE)) )
	{
		uint8_t dummybyte;
		dummybyte = UDR;
		return errorByte;
	}
	else
	{
		return UDR;
	}
}

void UART::sendByte(uint8_t writeByte)
{
	while(!((UCSRA>>UDRE) & 1));
	UDR = writeByte;
}

UART Serial;
