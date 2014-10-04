; Experiment 3 Homework Problem 1, with interrupts
; Write a subroutine which will use a 16 bit value stored at 81H/82H in the indirectly
; addressable memory to program the timer T0 in order to generate a delay proportional
; to this count.
; Write a program which will use the above subroutine to blink LEDs (as in Lab-1) such
; that these are ON for one second and OFF for one second endlessly. Adjust the timer
; count and the number of times the delay subroutine is called to make the ON and OFF
; period as close to 1 second as possible. (Measure the time over a large number of cycles
; to make this adjustment).

ORG 000h 										; Jump to start at 000h
LJMP start
ORG 00Bh
LCALL timer0_isr
RETI
ORG 200h 										; Start writing at 200h
start:

MOV P1,#00Fh									; Higher four bits outputs, lower four bits inputs

MOV A,P1										; Clear higher four bits, LEDs
ANL A,#00Fh
MOV P1,A
MOV R0,#081h									; Move delay value into indirect 081h and 082h
MOV @R0,#0FFh									; Higher byte in 082h, lower byte in 081h
INC R0
MOV @R0,#0FFh

MOV TMOD,#001h
SETB EA
SETB ET0

MOV R5,#004h

LCALL delay_timer

loop:
	SJMP loop

delay_timer:
	CLR TF0
	MOV R0,#081h
	MOV A,@R0
	CPL A
	MOV TL0,A
	INC R0
	MOV A,@R0
	CPL A	
	MOV TH0,A
	SETB TR0
RET

timer0_isr:
	DJNZ R5,skip
	toggle:
		MOV A,P1
		XRL A,#0F0h
		MOV P1,A
		MOV R5,#004h
	skip:
		ACALL delay_timer
RET

END