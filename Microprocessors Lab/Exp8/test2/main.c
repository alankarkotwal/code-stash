#include <stdio.h>
#include "lcd.h"

typedef unsigned char uchar;

sfr SSCON = 0x93;
sfr SSCS  = 0x94;
sfr SSDAT = 0x95;
sfr IEN=0xB1;

code uchar* days[]={"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};
code uchar* months[]={"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};

#define CR2  7
#define SSIE 6
#define STA  5
#define STO  4
#define SI   3
#define AA   2
#define CR1  1
#define CR0  0

char twi_address=0x68;													// Variable for TWI address

void twi_init();
void twi_write(char*, int);
void twi_read(char*, int);
void twi_close();
void ds1307_write(char*);
void ds1307_read(int*);

int array[8];
char str[8];
char write[]={0x00, 0x32, 0x16, 0x01, 0x29, 0x09, 0x14, 0x00};
int ind;

int main() {
	init_lcd();
	twi_init();
	ds1307_write(write);
	while(1) {
		ds1307_read(array);
		lcd_command(LCD_first);
		/*for(ind=0;ind<8;ind++) {
			sprintf(str, "%2x", array[ind]);
			lcd_string(str);
		}*/
		lcd_string(days[array[03]-1]);
		lcd_string(", ");
		sprintf(str, "%2x", array[04]);
		lcd_string(str);
		lcd_string(" ");
		lcd_string(months[array[05]-1]);
		lcd_string(" 20");
		sprintf(str, "%2x", array[06]);
		lcd_string(str);
		lcd_command(LCD_last);
		lcd_string("    ");
		sprintf(str, "%2x", array[02]&~(1<<6));
		if(array[02]&~(1<<6)<0x10) lcd_string("0");
		lcd_string(str);
		lcd_string(":");
		sprintf(str, "%2x", array[01]);
		if(array[01]<0x10) lcd_string("0");
		lcd_string(str);
		lcd_string(":");
		sprintf(str, "%x", array[00]);
		if(array[00]<0x10) lcd_string("0");
		lcd_string(str);
	}
}

void ds1307_write(char* arr) {
	int i;																				// Index for reading array
	SSCON &= ~(1<<STO);														// Clear impending STOP	
	SSCON |= (1<<STA);														// Send a START
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<STA);														// Clear START condition
	SSDAT = (twi_address<<1) | 0;									// Load address and write direction bit	
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSDAT = 0x00;																	// Send DS1307 read location
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	for(i=0;i<8;i++) {
		SSDAT = arr[i];															// Send setting byte
		SSCON &= ~(1<<SI);													// Clear SI
		while(!(SSCON&(1<<SI)));										// Wait for SI to be set
	}
	SSCON |= 1<<STO;															// Finally send a STOP
	SSCON &= ~(1<<SI);														// Clear SI
}

void ds1307_read(int* arr) {										// Make sure you allocate enough memory for arr
	int i;																				// Index for reading array
	SSCON &= ~(1<<STO);														// Clear impending STOP
	SSCON |= (1<<STA);														// Send a START
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<STA);														// Clear START condition
	SSDAT = (twi_address<<1) | 0;									// Load address and write direction bit	
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSDAT = 0x00;																	// Send DS1307 read location
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON |= (1<<STA);														// Send repeated START
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<STA);														// Clear START condition
	SSDAT = (twi_address<<1) | 1;									// Load address and read direction bit
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON |= (1<<AA);															// Assert acknowledgement
	SSCON &= ~(1<<SI);														// Clear SI
	for(i=0;i<7;i++) {
		while(!(SSCON&(1<<SI)));										// Wait for SI to be set
		arr[i] = SSDAT;															// Read recieved
		if(i==6) SSCON &= ~(1<<AA);									// Return NOT ACK for last data byte
		SSCON &= ~(1<<SI);													// Clear SI
	}
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	arr[7] = SSDAT;																// Read in last byte ...
	SSCON |= (1<<STO);														// ... and send a STOP
	SSCON &= ~(1<<SI);														// Clear SI
}

// General TWI routines. Use for debugging.

void twi_init() {
	//EA=1;																				// Enable global interrupts
	//IEN |= 0x02;																// Enable serial interrupts

	SSCON |= (1<<CR2);														// Set bit frequency to 25 kHz
	SSCON &= ~(1<<STA | 1<<STO | 1<<SI | 1<<AA);	// Clearing STA, STO, SI, disable slave mode AA
	SSCON |= (1<<SSIE);														// Enable TWI
}

/*void twi_write(char* arr, int len) {					// Read array arr of length len from the TWI bus
	int i;																				// Index for sending array
	SSCON |= (1<<STA);														// Send a START
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<SI);														// Clear SI
	SSCON &= ~(1<<STA);														// Clear START condition
	SSDAT = (twi_address<<1) | 0;									// Load address and write direction bit	
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<SI);														// Clear SI
	for(i=0;i<len;i++) {
		SSDAT=arr[i];																// Send array element
		while(!(SSCON&(1<<SI)));										// Wait for SI to be set
		SSCON &= ~(1<<SI);													// Clear SI
	}
	SSCON |= (1<<STO);														// Send a STOP to stop TWI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	while(SSCON&(~(1<<STO)));											// Wait for STO to be cleared
	SSCON &= ~(1<<SI);														// Clear SI
}

void twi_read(char* arr, int len) {  						// Write array arr of length len on the TWI bus
	int i;																				// Index for sending array
	SSCON |= (1<<STA);														// Send a START
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<SI);														// Clear SI
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set, no SSDAT action means repeated START is transmitted
	SSCON &= ~(1<<SI);														// Clear SI
	SSCON &= ~(1<<STA);														// Clear START condition
	SSDAT = (twi_address<<1) | 1;									// Load address and read direction bit	
	while(!(SSCON&(1<<SI)));											// Wait for SI to be set
	SSCON &= ~(1<<SI);														// Clear SI
	SSCON |= (1<<AA);															// Assert acknowledgement get first byte and return ACK
	for(i=0;i<len-1;i++) {
		arr[i]=SSDAT;
	}
	SSCON &= ~(1<<AA);														// Clear acknowledgement to get last byte and return NOT ACK
	SSCON &= ~(1<<STO);														// Send a STOP to stop TWI
}

void twi_close() {
	SSCON &= 0x00;
} */

// In case you want to use interrupts:
/*void twi_interrupt() interrupt 8 using 1 {			// Interrupt vectored by SSCON::SI
	switch(SSCS) {
		case 0x08: {																// START condition transmitted
			SSCON &= ~(1<<STA);												// Clear START
			SSDAT = (twi_address<<1) | twi_rw;				// Load SSDAT with address and direction
			SSCON |= (1<<AA);													// Force Acknowledge
			twi_start=1;															// I transmitted a START
			break;
		}
		case 0x10: {																// Repeated START condition transmitted
			SSDAT = (twi_address<<1) | twi_rw;				// Load SSDAT with address and direction
			break;
		}
		case 0x18: {																// Repeated START condition transmitted
			SSDAT = (twi_address<<1) | twi_rw;				// Load SSDAT with address and direction
			break;
		}
		case 0x20: {																// Repeated START condition transmitted
			SSDAT = (twi_address<<1) | twi_rw;				// Load SSDAT with address and direction
			break;
		}
		case 0x38: {																// Repeated START condition transmitted
			SSDAT = (twi_address<<1) | twi_rw;				// Load SSDAT with address and direction
			break;
		}
	}
}

void twi_write(char* arr, int len) {
	int index;
	twi_rw=0;																			// We're writing
	for(index=0;index<len;index++) {
		SSCON |= (1<<STA);													// Send a START
		twi_busy=1;																	// TWI is busy
		twi_data=arr[index];												// Set byte to send
		while(twi_busy);														// Wait till sent
	}
}

void twi_read(char* arr, int len) {  						// @TODO
	int index;
	twi_rw=1;
	for(index=0;index<len;index++) {
		SSCON |= (1<<STA);
		twi_busy=1;
		twi_data=arr[index];
		while(twi_busy);
	}
}*/