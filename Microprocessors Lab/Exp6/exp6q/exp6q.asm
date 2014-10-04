; Experiment 6 Labwork Problem
; Write a program so that two kits can be connected to each other using serial communica-
; tion. Transmit data line of one should be connected to receive data line of the other and vice
; versa. Each kit should send a 16 character string to the other. Each kit should display the
; string it received from the other on the first line of its LCD display and the string it sent on
; the second line.
; How will you ensure that the other kit is listening when the first kit starts transmitting?
; When the program on either kit starts, it should configure the serial port, enable interrupts
; and read the slide switches. It should then enter a loop which reads the slide switches and
; compares the recently read value with the previous one. It should quit the loop only when
; the value changes. Only when it quits the loop, it should transmit its 16 bit data character by
; character. Reception is in interrupt mode and is enabled before entering the wait loop. Thus
; both kits are ready to receive from the beginning but transmit only when permitted to do so
; by changing slide switches.

LCD_data equ P2							; LCD Data port
LCD_rs   equ P0.0						; LCD Register Select
LCD_rw   equ P0.1						; LCD Read/Write
LCD_en   equ P0.2						; LCD Enable

ORG 000h
LJMP start
ORG 023h
JB RI,recieve
transmit:
	CLR C
	MOV A,R0
	MOV B,#010h
	SUBB A,B
	JNC returnFromInterrupt
	MOV A,R0
	MOV DPTR,#serial_string
	INC R0
	MOVC A,@A+DPTR						; Put transmitted character into A for parity
	MOV C,PSW.0
	MOV TB8,C							; Move parity bit to TB8
	MOV SBUF,A							; Send character by putting it in SBUF
	SJMP returnFromInterrupt
recieve:
	MOV A,SBUF							; Get data in A
	LCALL lcd_senddata					; Send character to LCD
returnFromInterrupt:
	CLR TI								; Clear the transmit flag
	CLR RI								; Clear the recieve flag
RETI
ORG 500h
start:

MOV R0,#000h							; Counter for characters in transmit string

ACALL delay_lcd							; Initial delay for lcd power up
ACALL delay_lcd
ACALL lcd_init							; Initialise LCD	
ACALL delay_lcd
ACALL delay_lcd
ACALL delay_lcd

MOV TH1,#204							; Setup timer in auto-reload
MOV TMOD,#020h

SETB EA									; Enable interrupts
SETB ES

MOV SCON,#0C0h							; Serial in mode 
SETB REN

SETB TR1								; Run timer

MOV P1,#0FFh							; Configure as input port

MOV A,P1								; Get P0
ANL A,#00Fh								; Get only switch values
MOV B,A

loop:
	MOV A,P1							; Get P0
	ANL A,#00Fh							; Get only switch values
	XRL B,A
	MOV R7,B
	CJNE R7,#000h,start_tx
	MOV B,A
	SJMP loop
	
	
start_tx:
	SETB TI

endLoop:
	SJMP endLoop						; Stay here


;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         MOV   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en
	     ACALL delay_lcd

         MOV   LCD_data,#0CH  ;Display on, Curson off
         CLR   LCD_rs         ;Selected instruction register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en
         
		 ACALL delay_lcd
         MOV   LCD_data,#01H  ;Clear LCD
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en
         
		 ACALL delay_lcd

         MOV   LCD_data,#06H  ;Entry mode, auto INCrement with no shift
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en

		 ACALL delay_lcd
         
         RET                  ;RETurn from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en
		 ACALL delay_lcd
    
         RET  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         SETB  LCD_rs         ;Selected data register
         CLR   LCD_rw         ;We are writing
         SETB  LCD_en         ;Enable H->L
		 ACALL delay_lcd
         CLR   LCD_en
         ACALL delay_lcd
		 ACALL delay_lcd
         RET                  ;RETurn from busy routine

;----------------------delay routine-----------------------------------------------------
delay_lcd:	 
         MOV R2,#1
loop2:	 MOV R1,#255
loop1:	 DJNZ R1, loop1
		 DJNZ R2,loop2
		 RET
		 
;------------- ROM text strings---------------------------------------------------------------
serial_string:
         DB   "Alankar S Kotwal", 00H

END
