#include <regx51.h>
#include "i2c.h"

bit b_TWI_busy=0;
uchar TWI_data;
uchar rw=0;																			// 0 for write, 1 for read
uchar slave_adr;

void i2c_init() {
	SSCON|=0x40;																// Enable TWI
	EA=1;                           							// interrupt enable
	IEN1|=0x02;                    							// enable TWI interrupt
}

void i2c_send(uchar dat, uchar address) {
	if(!b_TWI_busy && ((SSCON&0x10)!=0x10)) {			// if the TWI is free
		b_TWI_busy=1;                  						  // flag busy =1
		TWI_data=dat;              							    // data example to send
		slave_adr=address;                 					// slave adresse example
		rw=0;                           						// 0=write
		SSDAT=0x00;                   						// clear buffer before sending data
		SSCON|=0x20;                   						// TWI start sending
	}
}

uchar i2c_recieve(uchar address) {
	if(!b_TWI_busy && ((SSCON&0x10)!=0x10)) {			// if the TWI is free
		b_TWI_busy=1;                  						  // flag busy =1
		TWI_data=dat;              							    // data example to send
		slave_adr=address;                 					// slave adresse example
		rw=1;                           						// 0=write
		SSDAT=0x00;                   						// clear buffer before sending data
		SSCON|=0x20;                   						// TWI start sending
	}
}

void it_TWI(void) interrupt 8 using 1 {
	switch(SSCS) {                    /* TWI status tasking */
		case(0x00):                /* A start condition has been sent */
		{                          /* SLR+R/W are transmitted, ACK bit received */
			b_TWI_busy=0;             /* TWI is free */
			break;
		}

		case(0x08):                /* A start condition has been sent */
		{                          /* SLR+R/W are transmitted, ACK bit received */
			SSCON &= ~0x20;            /* clear start condition */
			SSDAT = (slave_adr<<1)|rw; /* send slave adress and read/write bit */
			SSCON |= 0x04;             /* set AA */
			break;
		}

		case(0x10):                /* A repeated start condition has been sent */
		{                          /* SLR+R/W are transmitted, ACK bit received */
			SSCON &= ~0x20;            /* clear start condition */
			SSDAT = (slave_adr<<1)|rw; /* send slave adress and read/write bit */
			SSCON |= 0x04;             /* set AA */
			break;
		}

		case(0x18):                /* SLR+W was transmitted, ACK bit received */
		{
			SSDAT = TWI_data;          /* Transmit data byte, ACK bit received */
			SSCON |= 0x04;             /* set AA */
			break;
		}

		case(0x20):                /* SLR+W was transmitted, NOT ACK bit received */
		{
			SSCON |= 0x10;             /* Transmit STOP */
			b_TWI_busy=0;              /* TWI is free */
			break;
		}

		case(0x28):                /* DATA was transmitted, ACK bit received */
		{
			SSCON |= 0x10;             /* send STOP */
			b_TWI_busy=0;              /* TWI is free */
			break;
		}

		case(0x30):                /* DATA was transmitted, NOT ACK bit received */
		{
			SSCON |= 0x10;             /* Transmit STOP */
			b_TWI_busy=0;              /* TWI is free */
			break;
		}

		case(0x38):                /* Arbitration lost in SLA+W or DATA.  */
		{
			SSCON |= 0x10;             /* Transmit STOP */
			b_TWI_busy=0;              /* TWI is free */
			break;
		}
		
		case(0x40):                /* Arbitration lost in SLA+W or DATA.  */
		{
			SSCON |= 0x10;             /* Transmit STOP */
			b_TWI_busy=0;              /* TWI is free */
			break;
		}
	}
	SSCON &= ~0x08;                  /* clear flag */
}