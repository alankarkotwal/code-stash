CLR P1.4
CLR P1.5
CLR P1.6
CLR P1.7
MOV 81H,#00FEh
MOV 82H,#0000h
MOV R0,#0081H
MOV R1,#0082H


loop:
	SETB P1.7
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	CLR P1.7
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	JMP loop


delay1:
	MOV A,@R0
	MOV R3,A
	MOV A,@R1
	MOV R2,A
	loop11:
		loop12:
			DJNZ R2,loop12
			DJNZ R3,loop11
	RET


delay2:
	MOV R2,#0H
	MOV R3,#0H
	MOV A,@R0
	MOV R4,A
	MOV A,@R1
	MOV R5,A
	loop21:
		loop22:
			INC R2
			MOV A,R2
			CJNE A,82H,loop22
			INC R3
			MOV A,R3
			CJNE A,81H,loop21
	RET


endLoop:
	JMP endLoop


END
