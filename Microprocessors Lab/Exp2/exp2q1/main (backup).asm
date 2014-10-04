LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 000h
LJMP start

ORG 200h
start:
      MOV P2,#00h
	  MOV P1,#00h

      ACALL delay						;initial delay for lcd power up
	  ACALL delay
	  ACALL lcd_init    				;initialise LCD	
	  ACALL delay
	  ACALL delay
	  ACALL delay
	  
	  MOV A,#080h						;Put cursor on first row,0 column
	  ACALL lcd_command					;send command to LCD
	  ACALL delay
	  MOV   DPTR,#my_string1			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  ACALL convertToHex				; Start A
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay						; End A
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,B							; Start B
	  ACALL convertToHex
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,PSW							; Start PSW
	  ACALL convertToHex
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay

	  MOV A,#0C0h						;Put cursor on second row,0 column
	  ACALL lcd_command
	  ACALL delay
	  MOV   DPTR,#my_string2			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay

	  MOV A,R0							; Start R0
	  ACALL convertToHex
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R1							; Start R1
	  ACALL convertToHex
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R2							; Start R2
	  ACALL convertToHex
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV R5,#050h
	  callDelay1:
		ACALL delay1
		DJNZ R5,callDelay1
	  
	  MOV A,#080h						;Put cursor on first row,5 column
	  ACALL lcd_command					;send command to LCD
	  ACALL delay
	  MOV   DPTR,#my_string3			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R3
	  ACALL convertToHex				; Start R3
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R4
	  ACALL convertToHex				; Start R4
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R4
	  ACALL convertToHex				; Start R4
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay
	  
	  MOV   DPTR,#space			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
	  
	  MOV A,R5
	  ACALL convertToHex				; Start R4
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay

	  MOV A,#0C0h						;Put cursor on second row,3 column
	  ACALL lcd_command
	  ACALL delay
	  MOV   DPTR,#my_string4			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay

here: SJMP here				//stay here 

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         MOV   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en
	     ACALL delay

         MOV   LCD_data,#0CH  ;Display on, Curson off
         CLR   LCD_rs         ;Selected instruction register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en
         
		 ACALL delay
         MOV   LCD_data,#01H  ;Clear LCD
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en
         
		 ACALL delay

         MOV   LCD_data,#06H  ;Entry mode, auto INCrement with no shift
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en

		 ACALL delay
         
         RET                  ;RETurn from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en
		 ACALL delay
    
         RET  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         SETB  LCD_rs         ;Selected data register
         CLR   LCD_rw         ;We are writing
         SETB  LCD_en         ;Enable H->L
		 ACALL delay
         CLR   LCD_en
         ACALL delay
		 ACALL delay
         RET                  ;RETurn from busy routine

;--------------text strings sending routine, data in ROM----------------------------
lcd_sendstring_ROM:
         CLR   A                 	;clear Accumulator for any previous data
         MOVC  A,@A+DPTR         	;load the first character in accumulator
         JZ    exit1              	;go to exit if zero
         ACALL lcd_senddata      	;send first char
         INC   DPTR              	;INCrement data pointer
         SJMP  LCD_sendstring_ROM   ;jump back to send the next character
exit1:
         RET                     ;End of routine
		
;--------------text strings sending routine, data in RAM----------------------------
lcd_sendstring_RAM:
         CLR   A
		 MOV   A,@R0	         	;load the first character in accumulator
         JZ    exit2              	;go to exit if zero
		 SETB P1.5
         ACALL lcd_senddata      	;send first char
         INC   R0	             	;INCrement data pointer
         SJMP  LCD_sendstring_RAM   ;jump back to send the next character
exit2:
		 RET                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 
         MOV R6,#1
loop2:	 MOV R7,#255
loop1:	 DJNZ R7, loop1
		 DJNZ R6,loop2
		 RET
		 
; -----------------------------------Long delay routine---------------------------------------
delay1:
	MOV R6,#0FFh
	MOV R7,#0FFh
	loop11:
		MOV R7,#0FFh
		loop12:
			DJNZ R7,loop12
			DJNZ R6,loop11
	RET

;----------------------------------Decoding routine---------------------------------------

convertToHex:						; Start subroutine definition
	MOV R1,A
	ANL 001h,#00Fh					; Get lower nibble in R1
	ANL A,#0F0h
	SWAP A							; Get higher nibble in A, swap and move to R2
	MOV R2,A
	MOV R0,#002h
	convertNibble:
		MOV A,#009h
		CLR C
		SUBB A,@R0					; Check if the hex representation is a 'number' or a 'letter'
		MOV A,@R0
		JC inLetters
		inNumbers:
			ADD A,#030h				; For 'numbers'
			JMP back
		inLetters:
			ADD A,#037h				; Add 'letters'
		back:
			MOV @R0,A
			DJNZ R0,convertNibble	; Do this for both nibbles
	MOV A,R2
	MOV B,R1
RET


;------------- ROM text strings---------------------------------------------------------------

my_string1:
         DB   "ABPSW = ", 00H
my_string2:
         DB   "R012 = ", 00H
my_string3:
         DB   "R345 = ", 00H
my_string4:
         DB   "R67SP = ", 00H
space:
         DB   " ", 00H
END
