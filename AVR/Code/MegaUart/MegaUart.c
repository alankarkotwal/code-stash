#define FOSC 14745600// Clock Speed
#define BAUD 9600
#define (MYUBRR FOSC/16/BAUD-1)

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define RS 0
#define RW 1
#define EN 2
#define lcd_port PORTC

#define sbit(reg,bit)	reg |= (1<<bit)			// Macro defined for Setting a bit of any register.
#define cbit(reg,bit)	reg &= ~(1<<bit)		// Macro defined for Clearing a bit of any register.

void USART_Init(unsigned int ubrr)
{
	UBRR2H = (unsigned char)(ubrr>>8);
	UBRR2L = (unsigned char)ubrr;
	UCSR2B = (1<<RXEN)|(1<<TXEN);
	UCSR2C = (1<<UCSZ21)|(1<<UCSZ20);
}

unsigned char USART_Receive()
{
	while(!(UCSR2A&(1<<RXC2)));
	return UDR2;
}

void lcd_port_config (void)
{
  DDRC = DDRC | 0xF7; //all the LCD pin's direction set as output
  PORTC = PORTC & 0x80; // all the LCD pins are set to logic 0 except PORTC 7
}

//Function to Initialize PORTS
void port_init()
{
  lcd_port_config();
}

//Function to Reset LCD
void lcd_set_4bit()
{
  _delay_ms(1);

  cbit(lcd_port,RS);				//RS=0 --- Command Input
  cbit(lcd_port,RW);				//RW=0 --- Writing to LCD
  lcd_port = 0x30;				//Sending 3
  sbit(lcd_port,EN);				//Set Enable Pin
  _delay_ms(5);					//Delay
  cbit(lcd_port,EN);				//Clear Enable Pin

  _delay_ms(1);

  cbit(lcd_port,RS);				//RS=0 --- Command Input
  cbit(lcd_port,RW);				//RW=0 --- Writing to LCD
  lcd_port = 0x30;				//Sending 3
  sbit(lcd_port,EN);				//Set Enable Pin
  _delay_ms(5);					//Delay
  cbit(lcd_port,EN);				//Clear Enable Pin

  _delay_ms(1);

  cbit(lcd_port,RS);				//RS=0 --- Command Input
  cbit(lcd_port,RW);				//RW=0 --- Writing to LCD
  lcd_port = 0x30;				//Sending 3
  sbit(lcd_port,EN);				//Set Enable Pin
  _delay_ms(5);					//Delay
  cbit(lcd_port,EN);				//Clear Enable Pin

  _delay_ms(1);

  cbit(lcd_port,RS);				//RS=0 --- Command Input
  cbit(lcd_port,RW);				//RW=0 --- Writing to LCD
  lcd_port = 0x20;				//Sending 2 to initialise LCD 4-bit mode
  sbit(lcd_port,EN);				//Set Enable Pin
  _delay_ms(1);					//Delay
  cbit(lcd_port,EN);				//Clear Enable Pin


}

//Function to Initialize LCD
void lcd_init()
{
  _delay_ms(1);

  lcd_wr_command(0x28);			//LCD 4-bit mode and 2 lines.
  lcd_wr_command(0x01);
  lcd_wr_command(0x06);
  lcd_wr_command(0x0E);
  lcd_wr_command(0x80);

}


//Function to Write Command on LCD
void lcd_wr_command(unsigned char cmd)
{
  unsigned char temp;
  temp = cmd;
  temp = temp & 0xF0;
  lcd_port &= 0x0F;
  lcd_port |= temp;
  cbit(lcd_port,RS);
  cbit(lcd_port,RW);
  sbit(lcd_port,EN);
  _delay_ms(5);
  cbit(lcd_port,EN);

  cmd = cmd & 0x0F;
  cmd = cmd<<4;
  lcd_port &= 0x0F;
  lcd_port |= cmd;
  cbit(lcd_port,RS);
  cbit(lcd_port,RW);
  sbit(lcd_port,EN);
  _delay_ms(5);
  cbit(lcd_port,EN);
}

//Function to Write Data on LCD
void lcd_wr_char(char letter)
{
  char temp;
  temp = letter;
  temp = (temp & 0xF0);
  lcd_port &= 0x0F;
  lcd_port |= temp;
  sbit(lcd_port,RS);
  cbit(lcd_port,RW);
  sbit(lcd_port,EN);
  _delay_ms(5);
  cbit(lcd_port,EN);

  letter = letter & 0x0F;
  letter = letter<<4;
  lcd_port &= 0x0F;
  lcd_port |= letter;
  sbit(lcd_port,RS);
  cbit(lcd_port,RW);
  sbit(lcd_port,EN);
  _delay_ms(5);
  cbit(lcd_port,EN);
}


//Function to bring cursor at home position
void lcd_home()
{
  lcd_wr_command(0x80);
}


//Function to Print String on LCD
void lcd_string(char *str)
{
  while(*str != '\0')
  {
    lcd_wr_char(*str);
    str++;
  }
}

//Position the LCD cursor at "row", "column".

void lcd_cursor (char row, char column)
{
  switch (row) {
  case 1: 
    lcd_wr_command (0x80 + column - 1); 
    break;
  case 2: 
    lcd_wr_command (0xc0 + column - 1); 
    break;
  case 3: 
    lcd_wr_command (0x94 + column - 1); 
    break;
  case 4: 
    lcd_wr_command (0xd4 + column - 1); 
    break;
  default: 
    break;
  }
}

//Function To Print Any input value upto the desired digit on LCD
void lcd_print (char row, char coloumn, unsigned int value, int digits)
{
  unsigned char flag=0;
  if(row==0||coloumn==0)
  {
    lcd_home();
  }
  else
  {
    lcd_cursor(row,coloumn);
  }
  if(digits==5 || flag==1)
  {
    million=value/10000+48;
    lcd_wr_char(million);
    flag=1;
  }
  if(digits==4 || flag==1)
  {
    temp = value/1000;
    thousand = temp%10 + 48;
    lcd_wr_char(thousand);
    flag=1;
  }
  if(digits==3 || flag==1)
  {
    temp = value/100;
    hundred = temp%10 + 48;
    lcd_wr_char(hundred);
    flag=1;
  }
  if(digits==2 || flag==1)
  {
    temp = value/10;
    tens = temp%10 + 48;
    lcd_wr_char(tens);
    flag=1;
  }
  if(digits==1 || flag==1)
  {
    unit = value%10 + 48;
    lcd_wr_char(unit);
  }
  if(digits>5)
  {
    lcd_wr_char('E');
  }

}

void init_devices (void)
{
  cli(); //Clears the global interrupts
  port_init();
  sei();   //Enables the global interrupts
}		


//Main Function
int main(void)
{
  init_devices();
  lcd_set_4bit();
  lcd_init();
  USART_Init(MYUBRR);
  
  char c;
  
  while(1)
  {
  	c=USART_Receive();
    lcd_cursor(1,1);
		lcd_string((char*)c);
  }
}
