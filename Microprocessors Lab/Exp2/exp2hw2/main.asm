LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
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
	  
	  MOV R0,#80h						; Move my name into the upper ram as a 16-bit array
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#'A'
	  INC R0
	  MOV @R0,#'L'
	  INC R0
	  MOV @R0,#'A'
	  INC R0
	  MOV @R0,#'N'
	  INC R0
	  MOV @R0,#'K'
	  INC R0
	  MOV @R0,#'A'
	  INC R0
	  MOV @R0,#'R'
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  INC R0
	  MOV @R0,#' '
	  
	  MOV A,#81h						;Put cursor on first row,5 column
	  ACALL lcd_command					;send command to LCD
	  ACALL delay
	  MOV   DPTR,#my_string1			;Load DPTR with sring1 Addr
	  ACALL lcd_sendstring_ROM			;call text strings sending routine
	  ACALL delay

	  MOV A,#0C0h						;Put cursor on second row,3 column
	  ACALL lcd_command
	  ACALL delay
	  MOV   R0,#080h
	  ACALL lcd_sendstring_RAM

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
         MOV   A,@R0	         	;load the first character in accumulator
         JZ    exit2              	;go to exit if zero
         ACALL lcd_senddata      	;send first char
         INC   R0	             	;INCrement data pointer
         SJMP  LCD_sendstring_RAM   ;jump back to send the next character
exit2:
		 RET                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 
         MOV R2,#1
loop2:	 MOV R1,#255
loop1:	 DJNZ R1, loop1
		 DJNZ R2,loop2
		 RET

;------------- ROM text strings---------------------------------------------------------------
ORG 300h
my_string1:
         DB   "EE 337 - Lab 2", 00H
END
