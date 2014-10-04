; Experiment 4 Homework Problem 2
; Write a program which will control the duty cycle of ON and OFF time of any of the
; LEDs on the board. The ON time should be the 4 bit number read from slide switches
; in milliseconds. The sum of ON and OFF times should always be 20 milliseconds.

port EQU 090h

ORG 000h
LJMP start
ORG 00Bh
LCALL timer0_isr
RETI
ORG 100h
start:

MOV SP,#0C0h

MOV	port,#00Fh				; Set switches as inputs, LEDs as outputs.

SETB EA						; Interrupt and timer settings.
SETB ET0
MOV TMOD,#001h
MOV TH0,#0F8h
MOV TL0,#02Fh
SETB TR0					; Start timer for first run.

CLR C						; We'll use carry for indicating whether the program is in the
							; 'off' state or 'on' state of the duty cycle.

loop:
	SJMP loop

timer0_isr:
	DJNZ R5,skip			; Check if time is up.
	change:
		MOV A,port			; Read switches.
		ANL A,#00Fh
		JZ zero
		XRL port,#0F0h		; Toggle LEDs.
		CPL C				; Complement state.
		JNC off
		on:
			MOV R5,A		; If on, set the value read as the delay.
		SJMP skip
		off:
			MOV B,A
			MOV A,#014h
			SUBB A,B
			MOV R5,A		; If off, set 20-value read as delay.
		SJMP skip
	zero:
		CLR C
		ANL port,#00Fh
		MOV R5,#014h
	skip:
		MOV TH0,#0F8h
		MOV TL0,#02Fh
		SETB TR0
RET

END