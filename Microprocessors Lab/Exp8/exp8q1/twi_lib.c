/*C**************************************************************************
* NAME:         twi_lib.c
*----------------------------------------------------------------------------
* Copyright (c) 2004 Atmel.
*----------------------------------------------------------------------------
* RELEASE:      c51-twi-lib-1_0_2      
* REVISION:     1.21.2.2     
*----------------------------------------------------------------------------
* PURPOSE: 
* This file provides all minimal functionnal access to the TWI interface 
* for T89C51Ix2 products.
*****************************************************************************/


/*_____ I N C L U D E S ____________________________________________________*/
#include "config.h"
#include "twi_lib.h"
#if (!defined IRQ_TWI) && (defined FILE_BOARD_H)
#include FILE_BOARD_H // For SDA/SCL Pin Assignment
#endif

#ifdef IRQ_TWI  // HARDWARE TWI AUTODETECTION !
/****************************************************************************
*****************************************************************************
**********        STUFF WITH ON-CHIP HARDWARE TWI          ******************
*****************************************************************************
*****************************************************************************/
/*_____ G L O B A L    D E F I N I T I O N _________________________________*/
volatile bit                twi_busy;
volatile unsigned char      twi_err;
volatile Length_TWI_frame   twi_nb_transmited;
volatile unsigned char      twi_recptr;
/*V**************************************************************************
* NAME: twi_slave_data[TWI_NB_SLAVE_DATA] 
*----------------------------------------------------------------------------
* PURPOSE: 
* Global public Variable for TWI message in slave mode
*****************************************************************************/
volatile unsigned char xdata twi_slave_data[TWI_NB_SLAVE_DATA];

/*V**************************************************************************
* NAME: twi_message
*----------------------------------------------------------------------------
* PURPOSE: 
* Global public Variable for TWI message in master mode
*****************************************************************************/
volatile TWI_message xdata  twi_message;

/*_____ D E F I N I T I O N ________________________________________________*/
#define TWI_RATIO_256       0x00
#define TWI_RATIO_224       0x01
#define TWI_RATIO_192       0x02
#define TWI_RATIO_160       0x03
#define TWI_RATIO_960       0x80
#define TWI_RATIO_120       0x81
#define TWI_RATIO_60        0x82
#define TWI_RATIO_TIMER1    0x83

#define TWI_CR2             0x80
#define TWI_SSIE            0x40
#define TWI_STA             0x20
#define TWI_STO             0x10
#define TWI_SI              0x08
#define TWI_AA              0x04
#define TWI_CR1             0x02
#define TWI_CR0             0x01

#define TWI_WAIT_EVENT()    while ( !(SSCON & TWI_SI) ) 
#define TWI_WAIT_HW_STOP()  while ( SSCON & TWI_STO )
#define TWI_SET_START()     ( SSCON |= TWI_STA   ) 
#define TWI_CLEAR_START()   ( SSCON &= ~TWI_STA  )
#define TWI_SET_STOP()      ( SSCON |= TWI_STO   )
#define TWI_SET_AA()        ( SSCON |= TWI_AA    ) 
#define TWI_CLEAR_AA()      ( SSCON &= ~TWI_AA   )
#define TWI_CLEAR_SI()      ( SSCON &= ~TWI_SI   )

/*_____ M A C R O S ________________________________________________________*/
#ifndef TWI_SCAL
  #error You must set TWI_SCAL in config.h
#elif TWI_SCAL == 256
  #define TWI_SCAL_VALUE    TWI_RATIO_256
#elif TWI_SCAL == 224
  #define TWI_SCAL_VALUE    TWI_RATIO_224
#elif TWI_SCAL == 192
  #define TWI_SCAL_VALUE    TWI_RATIO_192
#elif TWI_SCAL == 160
  #define TWI_SCAL_VALUE    TWI_RATIO_160
#elif TWI_SCAL == 960
  #define TWI_SCAL_VALUE    TWI_RATIO_960
#elif TWI_SCAL == 120
  #define TWI_SCAL_VALUE    TWI_RATIO_120
#elif TWI_SCAL == 60
  #define TWI_SCAL_VALUE    TWI_RATIO_60
#else 
  #error Incorrect TWI_SCAL value, should be: 256 224 192 160 960 120 60
  #define TWI_SCAL_VALUE
#endif


void twi_lib_init(void)
{
SSCON|=TWI_SSIE|TWI_SCAL_VALUE;
}


/*F**************************************************************************
* NAME: twi_decode_status 
*----------------------------------------------------------------------------
* PARAMS:
* return:  none
*----------------------------------------------------------------------------
* PURPOSE: 
* main processing state machine for TWI message reception transmission
* in slave or master mode.
* This function is called when an event occured on the TWI interface.
* Can be used both in polling or interrupt mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
void twi_decode_status()
{
switch ( SSSTA )
    {
    //  STATE 00h: Bus Error has occurred 
    //  ACTION:    Enter not addressed SLV mode and release bus
    case  0x00 :
    twi_busy = FALSE;
    twi_err  = TWI_BUS_ERROR;
    break;

#ifdef TWI_MASTER
    //STATE 08h: A start condition has been sent
    //ACTION:    SLR+R/W are transmitted, ACK bit received
    case 0x08 :
    TWI_CLEAR_START();
    SSDAT = twi_message.address<<1;
    if ( twi_message.rw == TWI_READ ) SSDAT++; // Add 1 for Read bit in AdrWord
    TWI_SET_AA(); //from here to 0x18 transmit or 0x40 receive                 
    break;

    //STATE 10h: A repeated start condition has been sent
    //ACTION:    SLR+R/W are transmitted, ACK bit received
    case 0x10 :
    TWI_CLEAR_START();          // Reset STA bit in SSCON
    SSDAT = twi_message.address<<1;
    if ( twi_message.rw == TWI_READ ) SSDAT++; // Add 1 for Read bit in AdrWord
    TWI_SET_AA();               // wait on ACK bit
    break;

    //STATE 18h:   SLR+W was transmitted, ACK bit received 
    //ACTION:      Transmit data byte, ACK bit received
    //PREVIOUS STATE: 0x08 or 0x10                     
    case 0x18 :                 // master transmit, after sending
    twi_nb_transmited=0;        // slave address, now load data
    SSDAT = *(twi_message.buf); // byte and send it              
    TWI_SET_AA();               // wait on ACK bit
    if (twi_message.nbbytes==0) // no datas to transmit
        {                    
        TWI_SET_STOP();
        twi_err  = TWI_OK;
        twi_busy = FALSE;       // transfer complete, clear twi_busy
        }
    break;

    //STATE 20h:   SLR+W was transmitted, NOT ACK bit received
    //ACTION:      Transmit STOP
    case 0x20 :
    TWI_SET_STOP();
    twi_busy = FALSE;
    twi_err  = TWI_HOST_ADR_NACK;
    break;

    //STATE 28h:   DATA was transmitted, ACK bit received 
    //ACTION:      If last byte, send STOP, else send more data bytes 
    case 0x28:                  // master transmit, after sending ; data byte, ACK received
    twi_nb_transmited++;        // inc nb data transmit on message 
    twi_message.buf++;          // inc pointer ti data to be transmited
    if ( twi_nb_transmited < twi_message.nbbytes  ) // if there are still bytes to send
        {
        SSDAT = *(twi_message.buf);
        TWI_SET_AA();           // wait on ACK bit
        }
    else 
        {                    //run out of data, send stop,
        TWI_SET_STOP();
        twi_err  = TWI_OK;
        twi_busy = FALSE;         //transfer complete, clear twi_busy
        }
    break;

    //STATE 30h:   DATA was transmitted, NOT ACK bit received 
    //ACTION:      Transmit STOP     
    case 0x30 :
    TWI_SET_STOP();
    twi_busy = FALSE;
    twi_err  = TWI_HOST_ADR_NACK;
    break;

    //STATE 38h:   Arbitration lost in SLA+W or DATA.  
    //ACTION:      Release bus, enter not addressed SLV mode
    //             Wait for bus lines to be free 
    case 0x38 :
    twi_busy = FALSE;
    twi_err  = TWI_ARBITRATION_LOST;
    // #ifdef USER_TWI_FCT_ARBITRATION_LOST_IN_SLA+W_OR_DATA
    // TWI_fct_arb_lostinSLAorDATA();
    // #endif
    break;

   //MASTER RECEIVER MODE FOLLOWS 
   //STATE 40h:   SLA+R transmitted, ACK received 
   //ACTION:      Receive DATA, ACK to be returned 
   //PREVIOS STATE: 0x08 or 0x10
    case 0x40 :               //master receive, after sending
         if ( twi_message.nbbytes == 1 ) TWI_CLEAR_AA(); // only one data to receive, noACK to be send after the fisrt incoming data
    else if (!twi_message.nbbytes      ) TWI_SET_STOP(); // special case: no data to read !
    else
        {
        TWI_SET_AA();      //wait on ACK bit 
        twi_nb_transmited=0;      //data byte to be received, NOT ACK bit to follow  --> 0x58    
        }
    break;

    //STATE 48h:   SLA+R transmitted, NOT ACK received 
    //ACTION:      Transmit STOP 
    case 0x48 :
    TWI_SET_STOP();
    twi_busy = FALSE;
    twi_err  = TWI_HOST_ADR_NACK;
    break;

    //STATE 50h:   Data has been received, ACK returned 
    //ACTION:      Read DATA. If expecting more continue else STOP 
    case 0x50 : //master receive, received data 
                //byte and ACK, copy it into
    *(twi_message.buf+twi_nb_transmited) = SSDAT;      //buffer 
    twi_nb_transmited++;
    if ( twi_nb_transmited < (twi_message.nbbytes-1) ) TWI_SET_AA(); // get more bytes 
    else TWI_CLEAR_AA();           //only one more byte to come 
    break;

    //STATE 58h:   Data has been received, NOT ACK returned 
    //ACTION:      Read DATA. Generate STOP     
    case 0x58 :
    *(twi_message.buf+twi_nb_transmited) = SSDAT;
    TWI_SET_STOP();
    twi_busy = FALSE;
    twi_err  = TWI_OK;
    break;
#endif


#ifdef TWI_SLAVE
    //STATE 60h:   Own SLA+W has been received,ACK returned 
    //ACTION:      Read DATA. return ACK    
    case 0x60 :
    TWI_SET_AA();
    twi_busy = TRUE;
    twi_recptr=0;
    break;

    //STATE 68h:   Arbitration lost in SLA and R/W as MASTER. Own SLA + W has been received. ACK returned   
    //ACTION:      Read DATA. return ACK ;re-start MASTER,
    case 0x68 :
    TWI_SET_START();
    break;

    //STATE 70h:   General call received, ACK returned
    //ACTION:      Receive DATA. return ACK
    case 0x70 :
    TWI_SET_AA();
    twi_busy = TRUE;
    break;

    //STATE 78h:   Arbitration lost in SLA+R/W as MASTER. General call has arrived ack returned
    //ACTION:      Receive DATA. return ACK. Restart master
    case 0x78 :
    TWI_SET_START();
    twi_busy = TRUE;
    break;

    //STATE 80h:   Previously addressed with own SLA. Data received and ACK returned 
    //ACTION:      Read DATA. 
    case 0x80 :
    twi_slave_data[twi_recptr] = SSDAT;
    twi_recptr ++;
    if ( twi_recptr < TWI_NB_SLAVE_DATA ) TWI_SET_AA();  // ACK will be returned
    else TWI_CLEAR_AA(); // it was last data not ACK will be returned ( buffer full )
    break;

    //STATE 88h:   Previously addressed with own SLA. Data received and NOT ACK returned                                 
    //ACTION:      Dont' Read DATA. Enter NOT addressed SLV mode        
    case 0x88 :
    //STATE 98h:   Previously addressed with general call. Data arrved and NOT ACK returned 
    //ACTION:      Dont Read DATA. Enter NOT addressed SLV mode
    case 0x98 :
    TWI_SET_AA();  // ready to send another ACK if addresed as slave
    break;
    
    //STATE 90h:   Previously addressed with general call. Data received and ACK returned                                     
    //ACTION:      Read DATA.                                           
    case 0x90 :
    twi_slave_data[twi_recptr] = SSDAT;
    twi_recptr = twi_recptr + 1;
    break;

    //STATE A0h:   A stop or repeated start has arrived, whilst still addressed as SLV/REC or SLV/TRX
    //ACTION:      Dont Read DATA. Enter NOT addressed SLV mode
    case 0xA0 :
    TWI_SET_AA();
    twi_busy = FALSE;
    twi_err = TWI_OK;
    break;

    //STATE A8h:   addressed with own SLA+R
    //ACTION:      Prepare first data to be transmited
    case 0xA8 :
    TWI_SET_AA();
    twi_busy = TRUE;
    twi_recptr=0;
    SSDAT = twi_slave_data[0]; // Prepare next data
    break;


    //STATE B8h:   Previously addressed with own SLA. Data sent 
    //             and ACK returned 
    //ACTION:      Write DATA. 
    case 0xB8 :
    twi_recptr++;
    if ( twi_recptr < TWI_NB_SLAVE_DATA ) SSDAT = twi_slave_data[twi_recptr];
    else ///////// FIX ME : addressed with as slave + R : but not enought data"
         TWI_CLEAR_AA(); // it was last data not ACK will be returned ( buffer full )
    break;


    //STATE C0h:   Previously addressed with own SLA. Data sent and NACK returned 
    //ACTION:      It was last data to be sent 
    case 0xC0 :
    twi_busy=FALSE;
    twi_err  = TWI_OK;
    break;
#endif

    //if we arrived here, unknown state has occurred..... 
    default :
    TWI_SET_STOP();
    twi_busy = FALSE;
    twi_err  = TWI_UNKNOWN;
    break;
    }
}


#ifdef TWI_MASTER
unsigned char twi_send_message_polling( unsigned char slave_addr,bit rw, Length_TWI_frame nbbytes, unsigned char *info )
{
twi_message.address = slave_addr;
twi_message.rw = rw;
twi_message.nbbytes = nbbytes;
twi_message.buf = info;
TWI_WAIT_HW_STOP();
Disable_twi_interrupt(); //FIXME
twi_nb_transmited=0;
if (!twi_busy)
    {
    twi_busy =1;
    twi_err = TWI_OK;
    TWI_SET_START();
    while (twi_busy)
        {
        TWI_WAIT_EVENT();
        twi_decode_status();
        TWI_CLEAR_SI();
        }
    TWI_SET_STOP();
    return twi_err;
    }
TWI_SET_STOP();
return TWI_NOT_FREE;
}
#endif



#ifdef TWI_MASTER
#ifndef DO_NOT_USE_TWI_INTERRUPT
/*F**************************************************************************
* NAME: twi_send_message_interrupt 
*----------------------------------------------------------------------------
* PARAMS:
* *slave_addr:  The slave component address
* rw: Read or write operation flag ( read = 1 )
* nbbytes: number of bytes to be read or write 
* *info: pointer to the data to be processed
* return:  TWI error code state
*----------------------------------------------------------------------------
* PURPOSE: 
* This function can be used to send an TWI message to a slave 
* in interrupt mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
unsigned char twi_send_message_interrupt( unsigned char slave_addr,bit rw, Length_TWI_frame nbytes, unsigned char *info)
{
twi_message.address = slave_addr;
twi_message.rw = rw;
twi_message.nbbytes = nbytes;
twi_message.buf = info;
TWI_WAIT_HW_STOP();
twi_nb_transmited=0;
if (!twi_busy)
    {
    twi_err = TWI_OK;
    twi_busy =1;
    Enable_twi_interrupt();
    TWI_SET_START(); 
    return twi_err;
    }
TWI_SET_STOP();
return TWI_NOT_FREE;
}
#endif
#endif


#ifdef TWI_SLAVE
/*F**************************************************************************
* NAME: twi_slave_polling 
*----------------------------------------------------------------------------
* PARAMS:
* return:  TWI error code state
*----------------------------------------------------------------------------
* PURPOSE: 
* This function can be called to be able to answer another master request
* in polling mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
unsigned char twi_slave_polling(void)
{
TWI_WAIT_EVENT();
twi_decode_status();
TWI_CLEAR_SI();
while (twi_busy)
  {
  TWI_WAIT_EVENT();
  twi_decode_status();
  TWI_CLEAR_SI();
  }
return twi_err;
}

/*F**************************************************************************
* NAME: twi_slave_interrupt 
*----------------------------------------------------------------------------
* PARAMS:
* return:  none
*----------------------------------------------------------------------------
* PURPOSE: 
* This function can be called to be able to answer another master request
* in interrupt mode (stand alone mode).
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
void twi_slave_interrupt(void)
{
Enable_interrupt();
Enable_twi_interrupt();
}
#endif

Byte  twi_putchar(Byte addr, Byte b)
{
TWI_WAIT_HW_STOP();
TWI_SET_START();
TWI_WAIT_EVENT();
if (SSSTA == 0x08)     //start sent
  {

  TWI_CLEAR_START();
  SSDAT=addr<<1;
  TWI_SET_AA();
  TWI_CLEAR_SI();
  TWI_WAIT_EVENT();
  if (SSSTA == 0x18)   //ADR+W sent
    {
    SSDAT=b; 
    TWI_CLEAR_SI();
    TWI_WAIT_EVENT();
    if (SSSTA == 0x28) //data sent
      {
      TWI_SET_STOP();
      TWI_CLEAR_SI();
      return TWI_OK;
      } 
    }
//   else  {TWI_CLEAR_START(); TWI_SET_STOP();}
  }
TWI_CLEAR_START();
TWI_CLEAR_SI();
return TWI_UNKNOWN;
}


Uint16  twi_getchar(Byte addr)
{
Union16 data ret;

ret.b[0] = TWI_UNKNOWN;
ret.b[1] = 0;
TWI_WAIT_HW_STOP();
TWI_SET_START();
TWI_WAIT_EVENT();
if (SSSTA == 0x08)     //start sent
  {
  TWI_CLEAR_START();
  SSDAT=(addr<<1)+1;   //ADR+R
  TWI_SET_AA();
  TWI_CLEAR_SI();
  TWI_WAIT_EVENT();
  if (SSSTA == 0x40)   //ADR+R sent
    {
    TWI_CLEAR_AA();    //only one byte t receive: NACK after
    TWI_CLEAR_SI();
    TWI_WAIT_EVENT();
    if (SSSTA == 0x58) //data received
      {
      ret.b[1] = SSDAT;
      TWI_SET_STOP();
      TWI_CLEAR_SI();
      ret.b[0] = TWI_OK;
      } 
    }
//   else  {TWI_CLEAR_START(); TWI_SET_STOP();}
  }
return ret.w;
}



/*F**************************************************************************
* NAME: twi_interrupt 
*----------------------------------------------------------------------------
* PARAMS:
* return:  none
*----------------------------------------------------------------------------
* PURPOSE: 
* TWI interrupt routine service
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
#ifdef IRQ_TWI
void twi_interrupt(void) interrupt 8 using 1
{
	twi_decode_status();
	TWI_CLEAR_SI();
}
#endif

#else
/****************************************************************************
*****************************************************************************
**********            STUFF WITH SOFTWARE TWI              ******************
*****************************************************************************
*****************************************************************************/

/*_____ D E F I N I T I O N ________________________________________________*/
#ifndef SDA_SOFT
#error Define SDA_SOFT (SDA soft I/O pin) in config.h
#define SDA_SOFT    P1_0 // to reduce number of errors
#endif
#ifndef SCL_SOFT
#error Define SCL_SOFT (SCL soft I/O pin) in config.h
#define SCL_SOFT    P1_0 // to reduce number of errors
#endif

/*M**************************************************************************
* NAME: twi_start
*----------------------------------------------------------------------------
* PARAMS:
* none
*----------------------------------------------------------------------------
* PURPOSE: 
* Generate a start condition
*****************************************************************************/
#ifndef Twi_level_delay
#define twi_start()     (SDA_SOFT=0,SCL_SOFT=0)
#else
#define twi_start()     (SDA_SOFT=0,Twi_level_delay(),SCL_SOFT=0)
#endif



/*M**************************************************************************
* NAME: Twi_level_delay
*----------------------------------------------------------------------------
* PARAMS:
* none
*----------------------------------------------------------------------------
* PURPOSE: 
* Define this macro to increase bit time (or decrease bitrate) on software TWI
*****************************************************************************/
#ifndef Twi_level_delay
#define Twi_level_delay()
#endif


/*_____ G L O B A L    D E F I N I T I O N _________________________________*/
/*F**************************************************************************
* NAME: twi_lib_init
*----------------------------------------------------------------------------
* PARAMS:
* 
*----------------------------------------------------------------------------
* PURPOSE: 
* This routine performs a TWI software reset of a TWI slave device in order to 
* re-initialize the device's state machine before each data transfer. This 
* routine is very usefull to recover devices for which the TWI protocol was not
* completed properly due to a special event like an asynchronous reset of the
* TWI master.
*----------------------------------------------------------------------------
* NOTE: 
* Refer to ANALOG DEVICE's application note AN-686 and Memory reset paragraph
* in Atmel's E2P datasheets
*****************************************************************************/
void twi_lib_init(void)
{
  SDA_SOFT=1;                           //Reset TWI ports
  SCL_SOFT=1;  
  while(!SDA_SOFT)                      //A low condition on SDA line means
  {                                     //that device state machine is not reset
    SCL_SOFT=0;                         //generate clock pulses
    _nop_();_nop_();_nop_();_nop_();_nop_();  
    SCL_SOFT=1;                         //until device releases the SDA line
    while (!SCL_SOFT);
  };
  twi_start();                          //Perform a start and stop operation
  twi_stop();                           //to garantee that the device's state
}                                       //machine is properly reset.

#ifdef TWI_CUSTOM_SHORT_TEMPO
/*F**************************************************************************
* NAME: twi_short_tempo
*----------------------------------------------------------------------------
* PARAMS:
* n: number of wait state
*----------------------------------------------------------------------------
* PURPOSE: 
* Short tempo <=> (n-2)/2 * _nop_()
*----------------------------------------------------------------------------
* NOTE: 
* ASM source:
* DJNZ R7,$
* RET
*****************************************************************************/
void twi_short_tempo (Byte n)
{
for (;--n;);
}
#endif

/*F**************************************************************************
* NAME: twi_put 
*----------------------------------------------------------------------------
* PARAMS:
* b: byte to send
* return: bool for ACK receive
*----------------------------------------------------------------------------
* PURPOSE: 
* Send a byte through software TWI
* The routine returns 1 when ACK received and 0 when no ACK received
*----------------------------------------------------------------------------
* NOTE: ASM expected source code like
* twi_put:
*   MOV     R2,#8       ;Send 8 bits
* putc1:
*   RLC     A           ;Move next bit into carry
*   CLR     SCL
*   MOV     SDA,C       ;Write next bit
*   SETB    SCL
*   DJNZ    R2,putc1    ;write 8 bits
*   CLR     SCL
*   SETB    SDA         ;SDA entry mode
*   SETB    SCL
*   JNB     SDA, ack_received   ;test for ACK
*   MOV     A, #0FFh
* ack_received:
*   CLR     SCL
*   RET
*****************************************************************************/
bit twi_put (Byte b)
{
register Byte   c;
ACC=b;
SCL_SOFT=0;
#ifdef ENABLE_TWI_SOFT_PULL_UP
SDA_SOFT=0; // Rising Edge on bi-dir port => // Force Strong & week pull-up
#endif
for (c=8;c;c--)
  {
  ACC<<=1;
  SDA_SOFT=CY;
  Twi_level_delay();
  SCL_SOFT=1;
  Twi_level_delay();
  while (!SCL_SOFT); // basic TWI handshake / flow-control
  SCL_SOFT=0;
  }
#ifdef ENABLE_TWI_SOFT_PULL_UP
SDA_SOFT=0; // Rising Edge on bi-dir port => // Force Strong & week pull-up
#endif
SDA_SOFT=1;
Twi_level_delay();
SCL_SOFT=1;
Twi_level_delay();
CY=SDA_SOFT;
SCL_SOFT=0;
return !CY;
}


/*F**************************************************************************
* NAME: twi_get 
*----------------------------------------------------------------------------
* PARAMS:
* return: byte receive
*----------------------------------------------------------------------------
* PURPOSE: 
* Receive a byte and generate ACK through software TWI
* The received byte is put into ACC
*----------------------------------------------------------------------------
* NOTE: ASM expected source code like
* get_twi:
*   MOV     R2,#8       ;Receive 8 bits
*   CLR     A
*   SETB    SDA         ;SDA port entry mode
* getc1:
*   SETB    SCL
*   JNB     SCL, $
*   MOV     C,SDA       ;get next bit
*   RLC     A           ;Move next bit into carry
*   CLR     SCL
*   DJNZ    R2,getc1    ;write 8 bits
*   CLR     SDA         ;generate ACK
*   SETB    SCL
*   NOP
*   NOP
*   NOP
*   CLR     SCL
*   SETB    SDA
*   RET
*****************************************************************************/
Byte twi_get (void)
{
register Byte   c;
ACC=0;
SDA_SOFT=1;
for (c=8;c;c--)
  {
  ACC<<=1;
  #ifdef ENABLE_TWI_SOFT_PULL_UP
  SDA_SOFT=0; // Rising Edge on bi-dir port =>
  SDA_SOFT=1; // Force Strong & week pull-up
  #endif
  Twi_level_delay();
  SCL_SOFT=1;
  Twi_level_delay();
  while (!SCL_SOFT); // basic TWI handshake / flow-control
  if (SDA_SOFT) ACC++;
  SCL_SOFT=0;
  }
c=ACC;
SDA_SOFT=0;
Twi_level_delay();
SCL_SOFT=1;
_nop_();
_nop_();
_nop_();
Twi_level_delay();
SCL_SOFT=0;
SDA_SOFT=1;
return c;
}



/*F**************************************************************************
* NAME: twi_get_nack
*----------------------------------------------------------------------------
* PARAMS:
* return: byte receive
*----------------------------------------------------------------------------
* PURPOSE: 
* Receive a byte and generate NACK through software TWI
* The received byte is put into ACC
*****************************************************************************/
Byte twi_get_nack (void)
{
register Byte   c;

ACC=0;
SDA_SOFT=1;
for (c=8;c;c--)
  {
  ACC<<=1;
  #ifdef ENABLE_TWI_SOFT_PULL_UP
  SDA_SOFT=0; // Rising Edge on bi-dir port =>
  SDA_SOFT=1; // Force Strong & week pull-up
  #endif
  Twi_level_delay();
  SCL_SOFT=1;
  Twi_level_delay();
  while (!SCL_SOFT); // basic TWI handshake / flow-control
  if (SDA_SOFT) ACC++;
  SCL_SOFT=0;
  }
c=ACC;
#ifdef ENABLE_TWI_SOFT_PULL_UP
SDA_SOFT=0; // Rising Edge on bi-dir port => // Force Strong & week pull-up
#endif
SDA_SOFT=1;
Twi_level_delay();
SCL_SOFT=1;
_nop_();
_nop_();
_nop_();
Twi_level_delay();
SCL_SOFT=0;
return c;
}

bit twi_open (unsigned char slave_addr, bit rw)
{
twi_start();
slave_addr<<=1;
if (rw==TWI_READ) slave_addr++;
return twi_put (slave_addr);
}

unsigned char twi_send_message_polling ( unsigned char slave_addr,bit rw, Length_TWI_frame nbbytes, unsigned char *info )
{
if (!twi_open(slave_addr,rw))
  {
  twi_stop();
  return TWI_HOST_ADR_NACK;
  }
if (rw==TWI_WRITE) for (;nbbytes--;) twi_put(*info++);
else if (nbbytes)
  { // nbbytes must be > 0 !!
  for (;--nbbytes;info++) *info=twi_get();
  *info=twi_get_nack();
  }
twi_stop();
return TWI_OK;
}




Byte twi_putchar(Byte addr, Byte b)
{
register Byte status=TWI_HOST_ADR_NACK;

twi_start();
if (twi_put(addr<<1)) //ok ACK receive
  {
  twi_put(b);
  status=TWI_OK;
  }
twi_stop();
return status;
}


Uint16 twi_getchar(Byte addr)
{
register Union16 ret; // b[0]=status b[1]=data

twi_start();
if (twi_put(1+(addr<<1))) //ok ACK receive
  {
  ret.b[0]=TWI_OK;
  ret.b[1]=twi_get_nack();
  }
else ret.b[0]=TWI_HOST_ADR_NACK;
twi_stop();
return ret.w;
}
#endif

