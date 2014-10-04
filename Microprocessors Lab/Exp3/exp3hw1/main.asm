; Experiment 3 Labwork Problem 1
; We want to make a programmable note generator. For this, we shall generate square
; waves whose frequencies are selected from a table. 32 bytes are stored in the program
; memory using the DB directive. These represent 16 values, each being 2 bytes wide.
; (The entries represent candidate values for the half period of a square wave to be gen-
; erated). We shall program a timer for a duration proportional to this 16 bit value and
; toggle a port pin at every timeout. Since two toggles will complete 1 cycle of the square
; wave, the stored value is the half period of the resulting square wave.


ORG 000h 										; Jump to start at 000h
LJMP start
ORG 00Bh
LCALL timer0_isr
RETI
ORG 01Bh
LCALL timer1_isr
RETI
ORG 200h 										; Start writing at 200h
start:

MOV SP,#0C0h

MOV P1,#00Fh									; Higher four bytes outputs, lower four bytes inputs

MOV A,P1										; Clear higher four bits, LEDs
ANL A,#00Fh
MOV P1,A

SETB P1.6

MOV R1,#000h

MOV TMOD,#011h
SETB EA
SETB ET0
SETB ET1

MOV R5,#001h

MOV A,P1
XRL A,#0F0h
MOV P1,A
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
MOV TH1,#0FFh
MOV TL1,#0FFh
LCALL timer1_isr

loop:
	SJMP loop

timer0_isr:										; Toggle in the interrupt first
	MOV A,P1
	XRL A,#0F0h
	MOV P1,A
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

timer1_isr:
	DJNZ R5,skip
	change:
	
		MOV DPTR,#sequence							; Get the value from the sequence
		MOV A,R1
		INC R1
		CJNE R1,#019h,next
		MOV R1,#000h
		next: MOVC A,@A+DPTR
		MOV R2,A
		ANL A,#00Fh
		
		MOV DPTR,#periods							; Access the appropriate half-period value as #periods+2*(slide-switch value)
		MOV B,#002h
		MUL AB
		PUSH 0E0h
		MOV R0,#081h								; Move the half-period from ROM to indirectly addressable 081h and 082h
		MOVC A,@A+DPTR
		MOV @R0,A
		POP 0E0h
		INC A
		INC R0
		MOVC A,@A+DPTR
		MOV @R0,A
		
		MOV A,R2
		ANL A,#0F0h
		SWAP A
		MOV B,#003h
		MUL AB
		MOV R5,A
		
	skip:
		MOV TH1,#000h
		MOV TL1,#000h
		SETB TR1
		SETB TR0
RET

ORG 500h
periods:
DB  	01Ah, 011h, 024h, 010h, 03Ch, 00Fh, 061h, 00Eh, 093h, 00Dh, 00CFh, 00Ch, 017h, 00Ch, 06Ah, 00Bh, 0C6h, 00Ah, 02Bh, 00Ah, 099h, 009h, 00Fh, 009h, 08Dh, 008h, 012h, 008h, 09Eh, 007h, 031h, 007h

ORG 550h
sequence:
DB 		0F2H, 0F4H, 0F6H, 0F7H, 0F9H, 0FBH, 0FDH, 0FEH, 0FEH, 0FEH, 0FDH, 0FBH, 0F9H, 0F7H, 0F6H, 0F4H, 0F2H, 0F2H, 02H

END