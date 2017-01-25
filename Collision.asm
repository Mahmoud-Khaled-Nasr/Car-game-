;MAHMOUD KHALED NASR
;21/12/2016
;DETECT COLISION ,CALCULATE SCORE, DETECT LOSING
;=======================================================

INCLUDE Util.asm
EXTRN SCORE1:BYTE
EXTRN SCORE2:BYTE
EXTRN PLAYER1CENTER:WORD
EXTRN PLAYER2CENTER:WORD
EXTRN PLAYER1OBJECTS:WORD
EXTRN PLAYER2OBJECTS:WORD
EXTRN GAME_STATUS:BYTE
EXTRN P1OFFSET:BYTE
EXTRN P2OFFSET:BYTE
PUBLIC COLLISION

COLLIDER MACRO SCORE,CENTER,ARRAY,OFFSET,FLAG
	LOCAL START,INCREMENT,EXIT,LOSE
	MOV SI,0
	MOV CX,CENTER
START:
	;CHECK THE VALIDATION OF THE OBJECT
	MOV AX,ARRAY[SI]
	CMP AX,0
	JE EXIT
	CMP AX,0FFFFH
	JE EXIT
	MOV DX,1
	AND DX,AX
	JZ INCREMENT
	;COMPARE COL POSITION
	CMP CL,AH
	JNE INCREMENT
	;COMPARE ROW
	AND AL,11100000B
	SHR AL,1
	SHR AL,1
	SHR AL,1
	SHR AL,1
	SHR AL,1
	ADD AL,OFFSET
	CMP AL,CH
	JNE INCREMENT
	;LOSING ACTION OR WINING OR TIE OR WHATEVER FOR NOW LETS TERMINATE
	MOV AX,ARRAY[SI]
	MOV DL,00000010B
	AND DL,AL
	JNZ LOSE
	INC SCORE
	MOV AX,0
	MOV ARRAY[SI],AX
	JMP INCREMENT
LOSE:
	MOV AL,1
	MOV FLAG,AL
	JMP EXIT
INCREMENT:
	INC SI
	INC SI
	JMP START
EXIT:
ENDM

.MODEL SMALL
.STACK 64
.DATA 
	;STRING DB 'COLLIDE$'
	P1LOSE_FLAG DB 0
	P2LOSE_FLAG DB 0
.CODE
COLLISION PROC FAR
	MOV AX,@DATA
	MOV DS,AX

	COLLIDER SCORE1,PLAYER1CENTER,PLAYER1OBJECTS,P1OFFSET,P1LOSE_FLAG 
	COLLIDER SCORE2,PLAYER2CENTER,PLAYER2OBJECTS,P2OFFSET,P2LOSE_FLAG
	;CHECK FOR WINNING OR LOSING CONDITIONS
	CALL SET_GAME_STATUS
	;WRITE THE NEW SCORES
	CALL WRITE_THE_NEW_SCORES
	
	RET
COLLISION ENDP

SET_GAME_STATUS PROC NEAR
	MOV AL,P1LOSE_FLAG
	MOV AH,P2LOSE_FLAG
	ADD AL,AH
	CMP AL,2
	JNE P1LOSE
	;TIE
	MOV BL,3
	MOV GAME_STATUS,BL
	JMP EXIT
P1LOSE:
	;PLAYER 1 LOSE
	MOV AL,P1LOSE_FLAG
	CMP AL,1
	JNE P2LOSE
	MOV BL,2
	MOV GAME_STATUS,BL
	JMP EXIT
P2LOSE:	
	;PLAYER 2 LOSE
	MOV AL,P2LOSE_FLAG
	CMP AL,1
	JNE EXIT
	MOV BL,1
	MOV GAME_STATUS,BL
EXIT:	
	RET
SET_GAME_STATUS ENDP

WRITE_THE_NEW_SCORES PROC NEAR
	MOV AL,P1OFFSET
	DEC AL
	SET_CURSOR AL,1
	printByteUnsignedInteger SCORE1
		
	MOV AL,P2OFFSET
	DEC AL
	SET_CURSOR AL,1
	printByteUnsignedInteger SCORE2
	RET
WRITE_THE_NEW_SCORES ENDP
END