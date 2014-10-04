; Experiment 7 Homework Question 2
; Write the code for repeatedly reading a 10 bit word from the ADC, formatting it ac-
; cording to the requirements of the 12 bit DAC and writing it to the DAC through the
; SPI interface.

SPCON  EQU 0C3h
SPSTA  EQU 0C4h
SPDAT  EQU 0C5h
SS_ADC EQU P2.0
SS_DAC EQU P2.2

ORG 000h
LJMP start
ORG 100h
start:

MOV SPCON,#00111111b
ORL SPCON,#01000000b

MOV P2,#000h
MOV P2,#0FFh

loop:
	CLR SS_ADC
	MOV SPDAT,#01h
	stop1:
		MOV R0,SPSTA
		ANL 000h,#080h
		CJNE R0,#080h,stop1
	MOV SPDAT,#080h
	stop2:
		MOV R0,SPSTA
		ANL 000h,#080h
		CJNE R0,#080h,stop2
	MOV A,SPDAT
	ANL A,#003h
	RL A
	RL A
	ORL A,#070h
	MOV B,A
	MOV SPDAT,#000h
	stop3:
		MOV R0,SPSTA
		ANL 000h,#080h
		CJNE R0,#080h,stop3
	MOV A,SPDAT
	MOV R1,A
	ANL A,#0C0h
	RL A
	RL A
	ORL B,A
	MOV A,R1
	ANL A,#03Fh
	RL A
	RL A
	
	SETB SS_ADC
	
	CLR SS_DAC
	MOV SPDAT,B
	stop4:
		MOV R0,SPSTA
		ANL 000h,#080h
		CJNE R0,#080h,stop4
	MOV SPDAT,A
	stop5:
		MOV R0,SPSTA
		ANL 000h,#080h
		CJNE R0,#080h,stop5
	SETB SS_DAC

	SJMP loop

endLoop:
	SJMP endLoop			; Stay here

END
