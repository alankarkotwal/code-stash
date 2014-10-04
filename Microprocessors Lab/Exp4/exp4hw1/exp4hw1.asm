; Experiment 4 Homework Problem 1
; Write a program which will light the 4 LEDs on the board in the sequence suggested
; for driving the stepper motor. The time between each successive output should be a
; multiple of 100 ms, as read from the slide switches. Use timer 0 for controlling this time.
; If the slide switches are set to 0000, the program should terminate.

c1t1 EQU P1.4				; Set macros to the pins used for the motor.
c1t2 EQU P1.5				; In the form c<coil_number>t<terminal_number>.
c2t1 EQU P1.6
c2t2 EQU P1.7
port EQU 090h				; Set the direct address of the used port for ANL or ORL.

ORG 000h
LJMP start
ORG 00Bh
LCALL timer0_isr
RETI
ORG 100h
start:

MOV SP,#0C0h

MOV	port,#00Fh				; Set switches as inputs, LEDs as outputs.
ORL port,#010h				; Change this while changing pins

SETB EA						; Enable global interrupts.
SETB ET0					; Enable timer0 interrupt.

MOV TMOD,#001h				; Timer in mode 1

MOV A,P1					; Set timer for first run
ANL A,#00Fh
JZ terminate
MOV B,#003h
MUL AB
MOV R5,A
ACALL timer0_isr

loop:
	SJMP loop

terminate:
	CLR EA
	CLR ET0
	CLR TR0
	ANL port,#00Fh			; Change this while changing pins
	endLoop:
		SJMP endLoop

timer0_isr:
	DJNZ R5,skip			; Check if required time is done
	change:
		MOV A,P1			; Reload counter
		ANL A,#00Fh
		JZ terminate
		MOV B,#003h
		MUL AB
		MOV R5,A
		
		MOV A,port			; Calculate value to be sent to port
		ANL A,#0F0h
		SWAP A
		MOV B,#002h
		MUL AB
		ANL port,#00Fh
		CJNE A,#010h,next
		ORL port,A
		SJMP skip
		next:
		SWAP A
		ORL port,A
		
	skip:
		MOV TH0,#000h		; Restart timer
		MOV TL0,#000h
		SETB TR0

RET

END