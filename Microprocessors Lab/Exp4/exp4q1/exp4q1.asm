; Experiment 4 Labwork Problem 1
; We define 8 speeds for the stepper motor. Speed 0 means 0 speed (static). Speed 7 is
; the highest speed, which should be approximately 100 RPM. Other speed levels should
; be proportionately spaced.
; Define one of the switches on the uC board as the ‘up’ button and another as the ‘down’
; button.
; You can think of speeds as ranging between +7 and -7 with the sign representing the
; direction of rotation. The ‘up’ switch should act as increment and ‘down’ switch should
; act as decrement.
; Each change of the state (‘on’ to ‘off’ or ‘off’ to ‘on’) on the ‘up’ button should increase
; the speed in the clockwise direction and decrease the speed if currently rotating in coun-
; terclockwise direction. Similarly a change of state on the ‘down’ button should decrease
; the speed in the clockwise direction and increase the speed if the motor is currently ro-
; tating counterclockwise. A toggle on the ‘up’ button should be ignored if one is already
; on maximum speed in the clockwise direction.
; Similarly, a toggle on the ‘down’ button while at speed 0 should take the motor to counter
; clockwise rotation with speed 1. Toggles on the ‘down’ button should be ignored if the
; speed is maximum in the counter clockwise direction.

port EQU 090h
up EQU P1.3
down EQU P1.0
upOld EQU 023h.7
downOld EQU 023h.0
c1t1 EQU P0.3
c1t2 EQU P0.2
c2t1 EQU P0.0
c2t2 EQU P0.1
c1t1t EQU 022h.3
c1t2t EQU 022h.2
c2t1t EQU 022h.0
c2t2t EQU 022h.1


ORG 000h
LJMP start
ORG 00Bh
LCALL timer0_isr
RETI
ORG 100h
start:

MOV SP,#0C0h

MOV port,#0FFh								; Set switches as inputs.

SETB EA										; Enable interrupts.
SETB ET0
MOV TMOD,#001h								; Timer0 as timer in mode 1.
MOV TH0,#0F8h								; Set for a 1ms-delay.
MOV TL0,#02Fh
SETB TR0									; Start timer for first run.

MOV C,down									; We will use 023h.7 and 023h.0 to keep initial values of the up and down switches to
MOV downOld,C								; detect toggles.
MOV C,up
MOV upOld,C

MOV R5,#001h								; Use this for counting number of ms to run the timer

MOV R0,#007h								; Denotes the speed level. 7 is zero on this shifted scale.
											; 14 is maximum forward, 0 is maximum backward.

MOV P0,#000h								; Set as output port

MOV 021h,#000h
MOV 022h,#000h

SETB c1t1
CLR c1t2
CLR c2t1
CLR c2t2
SETB c1t1t
CLR c1t2t
CLR c2t1t
CLR c2t2t

loop:
	SJMP loop

timer0_isr:
	DJNZ R5,skip
	SJMP change
	skip:
		MOV TH0,#0F8h
		MOV TL0,#02Fh
		SETB TR0
	LJMP return
	change:
		MOV C,up
		MOV 021h.7,C
		MOV C,down
		MOV 021h.0,C
		MOV A,021h
		XRL A,023h
		MOV 021h,A
		MOV C,up
		MOV upOld,C
		MOV C,down
		MOV downOld,C
		downCheck:
			JNB 021h.0,upCheck
			DEC R0
			CJNE R0,#0FFh,upCheck
			MOV R0,#000h
		upCheck:
			JNB 021h.7,next
			INC R0
			CJNE R0,#00Fh,next
			MOV R0,#00Eh
		next:
			CLR C
			MOV A,R0
			MOV B,#007h
			SUBB A,B
			JNZ notZero
			SETB c1t1
			CLR c1t2
			CLR c2t1
			CLR c2t2
			SETB c1t1t
			CLR c1t2t
			CLR c2t1t
			CLR c2t2t
			MOV R5,#001h
			LJMP skip
			notZero:
			JC lessThanSeven
			greaterThanSeven:
				JNB c1t1t,next11
				SETB c2t1
				SETB c2t1t
				CLR c1t1
				CLR c1t1t
				SJMP next14
				next11:
				JNB c1t2t,next12
				SETB c2t2
				SETB c2t2t
				CLR c1t2
				CLR c1t2t
				SJMP next14
				next12:
				JNB c2t1t,next13
				SETB c1t2
				SETB c1t2t
				CLR c2t1
				CLR c2t1t
				SJMP next14
				next13:
				JNB c2t2t,next14
				SETB c1t1
				SETB c1t1t
				CLR c2t2
				CLR c2t2t
				next14:
				MOV A,#00Fh
				MOV B,R0
				SUBB A,B
				MOV R5,A
				LJMP skip
			lessThanSeven:
				JNB c1t1t,next21
				SETB c2t2
				SETB c2t2t
				CLR c1t1
				CLR c1t1t
				SJMP next24
				next21:
				JNB c1t2t,next22
				SETB c2t1
				SETB c2t1t
				CLR c1t2
				CLR c1t2t
				SJMP next24
				next22:
				JNB c2t1t,next23
				SETB c1t1
				SETB c1t1t
				CLR c2t1
				CLR c2t1t
				SJMP next24
				next23:
				JNB c2t2t,next24
				SETB c1t2
				SETB c1t2t
				CLR c2t2
				CLR c2t2t
				next24:
				MOV 005h,000h
				INC R5
				LJMP skip
return:
RET

END