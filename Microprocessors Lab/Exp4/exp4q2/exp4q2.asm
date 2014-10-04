; Experiment 4 Labwork Problem 2
; The DC motor drives a slotted wheel, which interrupts an infra red light beam from an
; LED to a photo detector. The circuit for this has been given in a document uploaded
; to moodle. By counting the number of light interruptions per second, the speed of the
; DC motor can be estimated. Configure T0 as a counter to count the number of pulses
; produced by the toothed wheel on the DC motor. Use T1 to count these pulses for
; exactly 1 second. Drive the DC motor using an H bridge with duty cycle controlled as
; in the home work problem-2. Display the 4 most significant digits of this count on the
; LEDs on the board.

port EQU 090h
pin EQU P0.0

ORG 000h
LJMP start
ORG 01Bh
LCALL timer1_isr
RETI
ORG 100h
start:

MOV SP,#0C0h

MOV	port,#00Fh					; Set switches as inputs, LEDs as outputs.
CLR pin							; Output pin set as output.

SETB EA							; Interrupt and timer settings.
SETB ET1
MOV TMOD,#014h					; Timer 0 as counter, timer 1 as timer in mode 1.
MOV TH1,#0F8h
MOV TL1,#02Fh
SETB TR0						; Start the counter.
SETB TR1						; Start timer for first run.

CLR C							; We'll use carry for indicating whether the program is in the
								; 'off' state or 'on' state of the duty cycle.

MOV R0,#065h					; We'll use this to time 1s. Since each cycle is 20ms, we need
								; to run 50 times, reading from the switches 100 times. 101 = 65h.

MOV R5,#001h
								

loop:
	JNB EA,display
	SJMP loop

display:
	MOV A,TL0
	SWAP A
	MOV port,A

endLoop:
	SJMP endLoop

timer1_isr:
	DJNZ R5,skip				; Check if time is up.
	change:
		DJNZ R0,continue
		SJMP terminate
		continue:
			MOV A,port			; Read switches.
			ANL A,#00Fh
			JZ zero
			CPL pin				; Toggle LEDs.
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
				MOV TH1,#0F8h
				MOV TL1,#02Fh
				SETB TR1
			SJMP return
		terminate:
			CLR EA
			CLR TR0
			SETB pin
return:
RET

END