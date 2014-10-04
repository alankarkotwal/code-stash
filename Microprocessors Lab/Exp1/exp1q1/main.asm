CLR P1.4
CLR P1.5
CLR P1.6
CLR P1.7

MOV SP,#0C0H

MOV R0,#0081H
MOV R1,#0082H
MOV @R0,#00FFh
MOV @R1,#00FFh


loop:
	SETB P1.4
	SETB P1.5
	SETB P1.6
	SETB P1.7
	MOV R6,#45H
	callDelay1:
		LCALL delay1
		DJNZ R6,callDelay1
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P1.7
	MOV R6,#45H
	callDelay2:
		LCALL delay1
		DJNZ R6,callDelay2
	JMP loop


delay1:
	MOV A,@R0
	MOV R3,A
	MOV A,@R1
	MOV R2,A
	MOV A,R3
	loop11:
		CJNE A,002H,loadFF
		loop12:
			DJNZ R2,loop12
			DJNZ R3,loop11
	JMP return
	loadFF:
		MOV R2,#00FFH
		JMP loop12
		
	return: RET


END
