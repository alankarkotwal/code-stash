CLR P1.4
CLR P1.5
CLR P1.6
CLR P1.7
MOV R0,#0081H
MOV R1,#0082H
MOV @R0,#00FFh
MOV @R1,#00FFh


loop:
	SETB P1.4
	SETB P1.5
	SETB P1.6
	SETB P1.7
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P1.7
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
	LCALL delay1
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
		MOV R2,#00FFh
		loop12:
			DJNZ R2,loop12
			DJNZ R3,loop11
	RET


delay2:
	MOV R3,#0H
	MOV A,@R0
	MOV R4,A
	MOV A,@R1
	MOV R5,A
	loop21:
		MOV R2,#0H
		loop22:
			MOV A,R3
			CJNE A,81H,higherBitNotReached ;Iff higher bit is not equal to 81H
			CJNE A,82H,loop22 ;CJNE A,R5,loop22 wasn't allowed
	back:	INC R3
			MOV A,R3
			CJNE A,81H,loop21 ;CJNE A,R4,loop22 wasn't allowed
			JMP return
	higherBitNotReached:
		INC R2
		MOV A,R2
		CJNE A,#00FFh,loop21 ;CJNE A,R5,loop22 wasn't allowed
		JMP back
	return: RET


endLoop:
	JMP endLoop


END
