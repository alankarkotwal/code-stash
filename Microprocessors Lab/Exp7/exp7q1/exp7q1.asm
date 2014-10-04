; Experiment 7 Labwork Question 1
; Connect just the DAC chip to Pt51 using the SPI interface. Write a program which
; will generate a stair-step approximation to a triangular wave of 1 KHz. Your program
; should use at least 8 steps on the rising as well as on the falling ramp of the triangular
; wave.

SPCON  EQU 0C3h
SPSTA  EQU 0C4h
SPDAT  EQU 0C5h
SS_ADC EQU P2.0
SS_DAC EQU P2.2
SCK EQU P1.6

ORG 000h
LJMP start
ORG 00Bh
CLR SS_DAC
MOV DPTR,#waveform
MOV A,R0
MOVC A,@A+DPTR
MOV SPDAT,A
stop4:
	MOV R1,SPSTA
	ANL 001h,#080h
	CJNE R1,#080h,stop4
INC R0
MOV A,R0
MOVC A,@A+DPTR
MOV SPDAT,A
stop5:
	MOV R1,SPSTA
	ANL 001h,#080h
	CJNE R1,#080h,stop5
SETB SS_DAC
MOV TH0,  #0FFh
MOV TL0,  #083h
INC R0
CJNE R0,#30,return
MOV R0,#000h
return:
RETI

start:

MOV SPCON,#00111111b
ORL SPCON,#01000000b
MOV TMOD, #00000001b
MOV TH0,  #0FFh
MOV TL0,  #083h

MOV P2,#000h
MOV P2,#0FFh

SETB EA
SETB ET0
SETB TR0

MOV DPTR,#waveform
MOV R0,#000h

loop:
	SJMP loop

waveform:
DB 01110000b, 00000000b
DB 01110001b, 11111111b
DB 01110011b, 11111110b
DB 01110100b, 11111101b
DB 01110101b, 11111100b
DB 01110110b, 11111011b
DB 01110111b, 11111010b
DB 01111111b, 11111111b
DB 01110111b, 11111010b
DB 01110110b, 11111011b
DB 01110101b, 11111100b
DB 01110100b, 11111101b
DB 01110011b, 11111110b
DB 01110001b, 11111111b
DB 01110000b, 00000000b

END