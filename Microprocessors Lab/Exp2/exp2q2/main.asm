LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 000h
LJMP start

ORG 200h
start:

	  ACALL delay						;initial delay for lcd power up
	  ACALL delay
	  ACALL lcd_init    				;initialise LCD	
	  ACALL delay
	  ACALL delay
	  ACALL delay
      
	  MOV R0,#010h
	  MOV @R0,#0AEh
	  INC R0
	  MOV @R0,#0F0h
	  INC R0
	  MOV @R0,#03Ch
	  INC R0
	  MOV @R0,#0EFh
	  INC R0
	  MOV @R0,#0A7h
	  INC R0
	  MOV @R0,#0F1h
	  INC R0
	  MOV @R0,#036h
	  INC R0
	  MOV @R0,#001h
	  INC R0
	  
	  MOV P2,#00h
	  MOV P1,#00h
	  
	  MOV SP,#0C0h

	  
	  loop:
		  
		  MOV R5,#050h
		  callDelay1:
			ACALL delay1
			DJNZ R5,callDelay1
		  
		  MOV A,P1
		  
		  MOV R5,#050h
		  callDelay2:
			ACALL delay1
			DJNZ R5,callDelay2
			
		  MOV B,P1
		  
		  SUBB A,B
		  JNZ loop
		  
		  MOV A,#080h
		  ACALL lcd_command
		  ACALL delay
		  
		MOV A,B
		SWAP A
		ANL A,#0F0h
;		LCALL displayChar
		MOV R1,A
		MOV R5,#004h
		showChar1:
			MOV A,@R1
			PUSH 1
			LCALL displayChar
			LCALL space
			POP 1
			INC R1
			DJNZ R5,showChar1
		
		MOV A,#0C0h
		ACALL lcd_command
		ACALL delay
		MOV R5,#004h
		showChar2:
			MOV A,@R1
			PUSH 1
			LCALL displayChar
			LCALL space
			POP 1
			INC R1
			DJNZ R5,showChar2
		
		MOV R5,#050h
		callDelay3:
			ACALL delay1
			DJNZ R5,callDelay3
		
		MOV A,#080h
		ACALL lcd_command
		ACALL delay
		MOV R5,#004h
		showChar3:
			MOV A,@R1
			PUSH 1
			LCALL displayChar
			LCALL space
			POP 1
			INC R1
			DJNZ R5,showChar3
		
		MOV A,#0C0h
		ACALL lcd_command
		ACALL delay
		MOV R5,#004h
		showChar4:
			MOV A,@R1
			PUSH 1
			LCALL displayChar
			LCALL space
			POP 1
			INC R1
			DJNZ R5,showChar4
				

		  JMP loop

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

;-------------------------ConvertAndDisplayChar----------------------------------------------
displayChar:
	  ACALL convertToHex				; Start R4
	  MOV R0,#080h
	  MOV @R0,A
	  INC R0
	  MOV @R0,B							; Get output of convertToHex into 080h and 081h
	  INC R0
	  MOV @R0,#000h
	  DEC R0
	  DEC R0
	  ACALL lcd_sendstring_RAM
	  ACALL delay	  
RET

;--------------------------Space------------------------
space:
	  MOV   DPTR,#space_string			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay
RET

;-----------------------Clear-----------------------------
clear:
	  MOV   LCD_data,#01H  ;Clear LCD
      CLR   LCD_rs         ;Selected command register
      CLR   LCD_rw         ;We are writing in instruction register
      SETB  LCD_en         ;Enable H->L
	  ACALL delay
      CLR   LCD_en

;------------- ROM text strings---------------------------------------------------------------

my_string1:
         DB   "ABPSW = ", 00H
my_string2:
         DB   "R012 = ", 00H
my_string3:
         DB   " R345 = ", 00H
my_string4:
         DB   "R67SP = ", 00H
space_string:
         DB   " ", 00H
END
