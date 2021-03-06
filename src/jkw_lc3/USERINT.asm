	.ORIG x3000
	LEA R0,INTPROG
	STI R0,KBINTPOS
	LD R0,SETINT
	STI R0,KBSR
	AND R1,R1,#0
	ADD R1,R1,#1

LOOP
	LD R0,TESTBIT
	ADD R0,R0,#0
	BRnp OVERPROG
	ADD R1,R1,#1
	BRnp LOOP
	;NOW R1 IS 0
	LD R0,OUTA
	TRAP x21
	BRnzp LOOP

OVERPROG
	AND R0,R0,#0
	STI R0,KBSR
	LEA R0,EXITSTR
	TRAP x22
	HALT
	
SETINT	.FILL x4000
OUTA	.FILL #97
EXITSTR	.STRINGZ "EXIT PROGINT\n"
KBINTPOS .FILL x0180

INTPROG	ST R0,INTSAVER0
	ST R1,INTSAVER1
	ST R2,INTSAVER2
	ST R7,INTSAVER7
SAVELOOP
	LDI R1, KBSR
	ADD R1,R1,#0
	BRzp SAVELOOP
	LDI R0, KBDR
	LD R2,MASK
	AND R1,R1,R2
	STI R1,KBSR
	; R0 CHAR
	LD R1,charA
	NOT R1,R1
	ADD R1,R1,#1
	ADD R1,R0,R1
	BRz PRESSA
	ADD R1,R1,#-1
	BRz PRESSB
	LEA R0,INTSTR3
	TRAP x22
	BRnzp LEAVE
	
PRESSA	LEA R0,INTSTR1
	TRAP x22
	BRnzp LEAVE

PRESSB	LEA R0,INTSTR2
	TRAP x22
	AND R0,R0,#0
	ADD R0,R0,#1
	ST R0,TESTBIT

LEAVE	LD R0,INTSAVER0
	LD R1,INTSAVER1
	LD R2,INTSAVER2
	LD R7,INTSAVER7
	RTI	

INTSAVER0 .BLKW 1	
INTSAVER1 .BLKW 1
INTSAVER2 .BLKW 1
INTSAVER7 .BLKW 1
INTSTR1	.STRINGZ "\nYou press a\n"
INTSTR2	.STRINGZ "\nYou press b, then halt\n"
INTSTR3 .STRINGZ "\nPress other key\n"

charA	.FILL #97

KBSR	.FILL xFE00
KBDR	.FILL xFE02
MASK	.FILL x7FFF

TESTBIT	.FILL x0

	.END