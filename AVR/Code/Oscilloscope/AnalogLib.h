/***************************************************
*  Library for running the ADC on Optimus, ATmega32u4 platform  *
*  Author: Alankar Kotwal					     *
*  Date: 11/07/2013					     *
*  Electronics Club, IIT Bombay				     *
*****************************************************/


#ifndef AnalogLib
#define AnalogLib


void ADCInit();		// Modify for 10-bit resolution.
int ADCRead(int);	// Returns the value of the ADC Reading. Returns -1 if the pin number or the  aren't valid.
int AnalogWrite8(int,int); 	// Returns the status of the setting, returns -1 if the pin isnt a proper PWM pin, or doesnt exist, 
			// or if the value entered is invalid. 8-bit resolution.
int AnalogWrite16(int,int); // Returns the status of the setting, returns -1 if the pin isnt a proper PWM pin, or doesnt exist, 
			// or if the value entered is invalid. 16-bit resolution.


void ADCInit()
{
	// Properties: Left adjusted ADC registers, 8-bit resolution, reference voltage from AVCC, prescaler of 16, no interrupts.
	// Modify here to include resolution stuff or change references. Do NOT change prescalers, it's fast enough.
	ADCSRA |= (1<<ADEN);
	ADMUX |= (1<<ADLAR | 1<<REFS0);
	ADCSRA |= (1<<ADPS2);
	ADCSRA |= (1<<ADSC);
}

int ADCRead(int pin)
{
	switch(pin)
	{
		case 5:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			break;
		}
		case 4:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			ADMUX |= (1<<MUX0);
			break;
		}
		case 3:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			ADMUX |= (1<<MUX2);
			break;
		}
		case 2:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			ADMUX |= (1<<MUX0 | 1<<MUX2);
			break;
		}
		case 1:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			ADMUX |= (1<<MUX1 | 1<<MUX2);
			break;
		}
		case 0:
		{
			ADMUX &= ~(1<<MUX5 | 1<<MUX4 | 1<<MUX3 | 1<<MUX2 | 1<<MUX1 | 1<<MUX0);
			ADMUX |= (1<<MUX0 | 1<<MUX1 | 1<<MUX2);
			break;
		}
		default:
		{
			return -1;
		}
	}
	ADCSRA |= (1<<ADSC);
	while(!(ADCSRA & (1<<ADSC)));
	return ADCH;
}

int AnalogWrite8(int pin, int val) 	// PWM Code, 8-bit Fast PWM Mode on 10-bit TCNT4.
{
	if(val >= 0 && val < 256)
	{
		switch(pin)
		{
			case 3: // OC4D TCNT4, 10-bit
			{
				TCCR4C |= (1<<COM4D1 | 1<<PWM4D);
				TCCR4B |= (1<<CS43 | 1<<CS42);
				
				OCR4D = 4 * val;
			
				break;
			}
			case 8: // OC4A TCNT4
			{
				TCCR4A |= (1<<COM4A1 | 1<<PWM4A);
				TCCR4B |= (1<<CS43 | 1<<CS42);
				
				OCR4A = 4 * val;
			
				break;
			}
			default:
			{
				return -1;
			}
		}
	}
	else
	{
		return -1;
	}
	return 0;
}

int AnalogWrite16(int pin, int val) 	// PWM Code, 16-bit Fast PWM Mode on 16-bit TCNTs 1 and 3.
{
	if(val >= 0 && val < 65536)
	{
		switch(pin)
		{
			case 5: // OC1A TCNT1, 16-bit.
			{
				TCCR1A |= (1<<COM1A1 | 1<<WGM11);
				TCCR1B |= (1<<WGM12 | 1<<WGM13 | 1<<CS10);
				ICR1 = 19999;
			
				OCR1A = val;
			
				break;
			}	
			case 6: // OC1B TCNT1, 16-bit.
			{
				TCCR1A |= (1<<COM1B1 | 1<<WGM11);
				TCCR1B |= (1<<WGM12 | 1<<WGM13 | 1<<CS10);
				ICR1 = 19999;
			
				OCR1B = val;
				
				break;
			}
			case 7: //OC3A TCNT3, 16-bit.
			{
				TCCR3A |= (1<<COM3A1 | 1<<WGM31);
				TCCR3B |= (1<<WGM32 | 1<<WGM33 | 1<<CS30);
				ICR3 = 19999;
			
				OCR3A = val;
				
				break;
			}
			case 9: // OC1C TCNT1, 16-bit.
			{
				TCCR1A |= (1<<COM1C1 | 1<<WGM11);
				TCCR1B |= (1<<WGM12 | 1<<WGM13 | 1<<CS10);
				ICR1 = 19999;
			
				OCR1C = val;
				
				break;
			}
			default:
			{
				return -1;
			}
		}
	}
	else
	{
		return -1;
	}
	return 0;
}


#endif
