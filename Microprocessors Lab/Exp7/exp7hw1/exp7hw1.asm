; Experiment 7 Homework Question 1
; Write the code for configuring the peripheral clock and the SPI interface of Pt51 as the
; master device.

SPCON EQU 0C3H
SPSTA EQU 0C4H

ORG 000h
LJMP start
ORG 100h
start:

ORL SPCON,#05Dh

endLoop:
	SJMP endLoop			; Stay here

END