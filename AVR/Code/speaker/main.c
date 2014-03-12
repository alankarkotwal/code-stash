#include<avr/io.h>
#include<util/delay.h>

void delay_us(int);
void play(int);

int i = 0;	// General counter variable, use to count, initialize to zero
int delay = 0;  // General delay variable, use for delays, set always

int main()
{
	DDRD = 0b10000000;
	PORTD = 0b00000000;

	while(1)
	{
		play(20000);
	}
}

void delay_us(int delay)
{
	for(i=0;i<delay/2;i++)
	{
		_delay_us(1);
	}
}

void play(int freq)
{
	PORTD ^= 0b10000000;
	delay = 1000000/freq;
	delay_us(delay-3);
}
