; Experiment 6 Homework Problem
; We want to use T1 in auto-reload 8 bit mode (mode 2). This mode puts no software load
; on the processor. All actions such as re-loading the timer etc. are done automatically in
; hardware. Therefore once the timer is configured, it goes merrily along, providing its output
; to the serial communications block.
; Write a program which does the following:
; • Configure the serial port for 8 bit data + Even Parity (11 bit frame) with baud rate
; adjusted to 1200 using T1. Serial port interrupts are to be enabled.
; • Write an interrupt service routine for serial communication, which clears TF and trans-
; mits the character ‘A’ whenever the serial port interrupt occurs and TF is found set.
; Parity bit should not be hard coded for ‘A’. It should be evaluated by adding 0 to the
; character being sent and checking the parity flag. (Then you will be able to use this
; routine for any character, not just ‘A’). After writing the character, the ISR should in-
; crement a global counter (initialized by the main program) and create a software delay
; of about 10 ms. (This will be useful for triggering the oscilloscope properly when you
; observe the output during the lab).
; The main program initializes the global counter to 0. After that it goes in an endless
; loop, checking the counter. Every time it finds that the counter has reached 50 (decimal),
; it should reset the counter to 0 and toggle an on-board LED.
; Assemble the program, download it to your kit and run it. Find the rate at which the LED is
; blinking by timing it for 10 cycles.

ORG 000h
LJMP start
ORG 023h
CLR TI									; Clear the transmit flag
INC R0									; Increment counter
MOV A,#'A'								; Put transmitted character into A for parity
JNB PSW.0,clear							; Set TB8 iff parity bit is set
SETB TB8
SJMP send
clear:
CLR TB8
send:
MOV SBUF,A								; Send character by putting it in SBUF
MOV R6,#39								; 10ms delay
delayLoop1:
	MOV R5,#0FFh
	delayLoop2:
		DJNZ R5,delayLoop2
		DJNZ R6,delayLoop1
RETI
ORG 100h
start:

MOV TH1,#204							; Setup timer in auto-reload
MOV TMOD,#020h

SETB EA									; Enable interrupts
SETB ES

MOV SCON,#0C0h
SETB REN

MOV R0,#000h

MOV P1,#00Fh							; Set output port

SETB TR1								; Run timer

MOV SBUF,#'A'

loop:
	CJNE R0,#050h,loop					; Toggle iff R0 reaches 50
	MOV R0,#000h
	XRL 090h,#0F0h
	SJMP loop

END