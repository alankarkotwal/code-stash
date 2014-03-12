#include<avr/io.h>
#include<avr/interrupt.h>
#include<stdint.h>
#include<util/delay.h>
#define sbi(x,y) x |= y 

#define USART_BAUDRATE 9600 
#define BAUD_PRESCALE (((F_CPU / (USART_BAUDRATE * 16UL))) - 1) 

void USART_Init( void );
void USART_Transmit( unsigned char data );
unsigned char USART_Receive( void );

void USART_Init( void )
{
	//sbi(UCSR1A,_BV(U2X1));	/* Set baud rate */
	//UBRR1H = 0 ;
	//UBRR1L = 12;

	UCSR1A = 0;
	UCSR1B = (1<<RXEN1) | (1<<TXEN1);
	UCSR1C = (1<<UCSZ10) | (1<<UCSZ11);
	
	UBRR1L = BAUD_PRESCALE; // Load lower 8-bits of the baud rate value into the low byte of the UBRR register 
    UBRR1H = (BAUD_PRESCALE >> 8); // Load upper 8-bits of the baud rate value into the high byte of the UBRR register 

	/* Enable receiver and transmitter */
	UCSR1A &= ~(1 << U2X1);	
	
}


void USART_Transmit( unsigned char data )
{
	/* Wait for empty transmit buffer */
	while ( !( UCSR1A & (1<<UDRE1)) );
	
	/* Put data into buffer, sends the data */
	UDR1 = data;
	
}

unsigned char USART_Receive( void )
{
	/* Wait for data to be received */
	while ( !(UCSR1A & (1<<RXC1)) );
	
	/* Get and return received data from buffer */
	return UDR1;
}


int main( void )
{		
	USART_Init();
	DDRB = 0xFF;
	PORTB = 0xFF;

	while(1)
	{
		//unsigned char receivedData = USART_Receive();
		USART_Transmit('b');	
		//PORTB = ~PORTB;
		_delay_ms(100);
		//if (receivedData == 'a')PORTB = ~PORTB;

	}
	
	return 0;	
}

//c= USART_Receive();
//if (USART_Receive() == '5')
//{
//	PORTB = 0xFF;
//}

//	_delay_ms(1000);
//else	PORTB = 0x00;
//USART_Transmit(USART_Receive());	