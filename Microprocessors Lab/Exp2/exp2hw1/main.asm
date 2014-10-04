ORG 000h
LJMP start
ORG 100h

start:
	MOV SP,#0C0h						; Allocate stack memory
	MOV A,#09Eh							; Move the byte to be converted to Accumulator
	LCALL convertToHex					; Call subroutine
	
	endLoop:							; Infinite loop to end the program
		JMP endLoop

	convertToHex:						; Start subroutine definition
		MOV R1,A
		ANL 001h,#00Fh					; Get lower nibble in R1
		ANL A,#0F0h
		SWAP A							; Get higher nibble in A, swap and move to R2
		MOV R2,A
		MOV R0,#002h
		convertNibble:
			MOV A,#009h
			CLR C
			SUBB A,@R0					; Check if the hex representation is a 'number' or a 'letter'
			MOV A,@R0
			JC inLetters
			inNumbers:
				ADD A,#030h				; For 'numbers'
				JMP back
			inLetters:
				ADD A,#037h				; Add 'letters'
			back:
				MOV @R0,A
				DJNZ R0,convertNibble	; Do this for both nibbles
		MOV A,R2
		MOV B,R1
	RET
END
