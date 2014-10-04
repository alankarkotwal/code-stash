/*H**************************************************************************
* NAME:         twi_lib.h         
*----------------------------------------------------------------------------
* Copyright (c) 2004 Atmel.
*----------------------------------------------------------------------------
* RELEASE:      c51-twi-lib-1_0_2      
* REVISION:     1.15     
*----------------------------------------------------------------------------
* PURPOSE: 
* TWI lib header file                                       
*****************************************************************************/

#ifndef _TWI_LIB_H_
#define _TWI_LIB_H_

/*_____ C O N F I G U R A T I O N _________________________________________*/
#define TWI_NB_SLAVE_DATA   1
#define TWI_MASTER
//#define TWI_SLAVE

typedef unsigned char Byte;
typedef unsigned int Uint16;

#define FALSE 0
#define TRUE 1
#define Disable_twi_interrupt() IEN1&=~(0x02) 
#define Enable_twi_interrupt() IEN1&=~(0x02) 

sfr SSCON=0x93;
sfr IEN1=0xB1;
sfr SSSTA=0x94;
sfr SSDAT=0x95;

#ifdef TWI_BIG_FRAME
typedef unsigned int    Length_TWI_frame;
#else
typedef unsigned char   Length_TWI_frame;
#endif

#ifdef IRQ_TWI  // HARDWARE TWI AUTODETECTION !
#ifdef TWI_MASTER
/*_____ D E F I N I T I O N S ______________________________________________*/
typedef struct{ unsigned char       address;
                unsigned char       rw;
                Length_TWI_frame    nbbytes;
                unsigned char*      buf;
              } TWI_message;

typedef struct{ unsigned int b[2];
								unsigned int w;
              } Union16;


/*_____ D E C L A R A T I O N ______________________________________________*/
extern volatile TWI_message xdata   twi_message;        // The TWI message to be sent in Master Mode
#endif
extern bit                          twi_busy;
extern unsigned char                twi_err;
extern volatile unsigned char xdata twi_slave_data[TWI_NB_SLAVE_DATA];  //The slave data buffer when TWI ask in slave
#endif

/*_____ M A C R O S ________________________________________________________*/
#define TWI_OK                  0
#define TWI_BUS_ERROR           1
#define TWI_HOST_ADR_NACK       2
#define TWI_HOST_DATA_NACK      3
#define TWI_ARBITRATION_LOST    4
#define TWI_UNKNOWN             5
#define TWI_NOT_FREE            6


#define TWI_READ  1
#define TWI_WRITE 0

/*_____ P R O T O T Y P E S ____________________________________________________________*/

#ifdef TWI_MASTER
/*F**************************************************************************
* NAME: twi_send_message_polling 
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
* in polling mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
unsigned char twi_send_message_polling  ( unsigned char slave_addr,bit rw, Length_TWI_frame nbytes, unsigned char *info );
#ifdef IRQ_TWI  // HARDWARE TWI AUTODETECTION !
unsigned char twi_send_message_interrupt( unsigned char slave_addr,bit rw, Length_TWI_frame nbytes, unsigned char *info);
#endif
#endif

#ifdef TWI_SLAVE
#ifdef IRQ_TWI  // HARDWARE TWI AUTODETECTION !
unsigned char twi_slave_polling         (void);
void          twi_slave_interrupt       (void);
#endif
#endif

/*F**************************************************************************
* NAME: twi_lib_init
*----------------------------------------------------------------------------
* PARAMS:
* return:  
*----------------------------------------------------------------------------
* PURPOSE: 
* init TWI macro
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
void    twi_lib_init                    (void);
/*F**************************************************************************
* NAME: twi_putchar 
*----------------------------------------------------------------------------
* PARAMS:
* addr:  The slave component address
* b: data to send
* return:  TWI error code state
*----------------------------------------------------------------------------
* PURPOSE: 
* This function can be used to send an byte to a slave 
* in polling mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
Byte    twi_putchar(Byte addr,Byte b);
/*F**************************************************************************
* NAME: twi_getchar 
*----------------------------------------------------------------------------
* PARAMS:
* addr:  The slave component address
* b:     data received 
* return:  TWI error code state
*----------------------------------------------------------------------------
* PURPOSE: 
* This function can be used to receive an byte from a slave 
* in polling mode.
*----------------------------------------------------------------------------
* EXAMPLE:
*----------------------------------------------------------------------------
* NOTE: 
*----------------------------------------------------------------------------
* REQUIREMENTS: 
*****************************************************************************/
Uint16  twi_getchar (Byte addr);

#ifndef IRQ_TWI
#include <intrins.h>

// Low level:
bit     twi_open    (unsigned char slave_addr, bit rw);
bit     twi_put     (Byte b);
Byte    twi_get     (void);
Byte    twi_get_nack(void);


/*_____ C O N F I G U R A T I O N _________________________________________*/
#ifndef Twi_level_delay
#ifdef TWI_BAUDRATE_MAX
  #define TWI_FACTOR            58 // CPU 48MHz x1 => 460kbit/s on TWI bus => 115/12 == 29/3 = 58/6
  #ifdef X2_MODE
    #define FOSC_TWI            FOSC * 2
  #else
    #define FOSC_TWI            FOSC
  #endif

  #if TWI_BAUDRATE_MAX < ( FOSC_TWI * TWI_FACTOR / 6 )
    #define TWI_N_WAIT          ( ( TWI_FACTOR * FOSC_TWI - 6 * TWI_BAUDRATE_MAX ) / 24 / TWI_FACTOR / ( TWI_BAUDRATE_MAX / 1000 ) )
      #if TWI_N_WAIT < 2
      #define Twi_level_delay() (_nop_())
    #elif TWI_N_WAIT < 3
      #define Twi_level_delay() (_nop_(),_nop_())
    #elif TWI_N_WAIT < 4
      #define Twi_level_delay() (_nop_(),_nop_(),_nop_())
    #elif TWI_N_WAIT < 5
      #define Twi_level_delay() (_nop_(),_nop_(),_nop_(),_nop_())
    #elif TWI_N_WAIT < 6
      #define Twi_level_delay() (_nop_(),_nop_(),_nop_(),_nop_(),_nop_())
//    #elif TWI_N_WAIT < 7
    #elif TWI_N_WAIT < 516
      #define TWI_CUSTOM_SHORT_TEMPO
      void    twi_short_tempo   (Byte);
      #define Twi_level_delay() (twi_short_tempo(TWI_N_WAIT/2-2)) // lcall + ret => 2*2M, djnz => n*2M
    #else
      #error TWI_N_WAIT number too high
    #endif
  #endif
#endif
#endif  

/*M**************************************************************************
* NAME: twi_stop
*----------------------------------------------------------------------------
* PARAMS:
*----------------------------------------------------------------------------
* PURPOSE: 
* Generate a stop condition
*****************************************************************************/
#ifndef Twi_level_delay
#define twi_stop()      (SCL_SOFT=0,SDA_SOFT=0,_nop_(),_nop_(),_nop_(),SCL_SOFT=1,SDA_SOFT=1)
#else
#define twi_stop()      (SCL_SOFT=0,Twi_level_delay(),SDA_SOFT=0,_nop_(),_nop_(),_nop_(),Twi_level_delay(),SCL_SOFT=1,SDA_SOFT=1,Twi_level_delay())
#endif

#endif

#endif /* _TWI_H_ */

