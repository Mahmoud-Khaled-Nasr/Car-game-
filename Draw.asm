;MAHMOUD KHALED
;5/12/2016
;GAME DRAWING FUNCTIONS
;=======================================  
INCLUDE Util.asm
EXTRN PLAYER1CENTER:WORD
EXTRN PLAYER2CENTER:WORD
EXTRN PLAYER1OBJECTS:WORD
EXTRN PLAYER2OBJECTS:WORD
EXTRN P1OFFSET:BYTE
EXTRN P2OFFSET:BYTE
PUBLIC DRAW

DRAW_CRAFT MACRO POSITION
    MOV DX,POSITION
    SET_CURSOR DH,DL
    MOV AH,09
    MOV BH,0
    MOV CX,1
    MOV AL,'X'
    MOV BL,01100001B
    INT 10H     
ENDM    

;YSHIFT FOR THE PLAYER2 TO BE DRAWN IN THE WRIGHT POSITION
DRAW_OBJECTS MACRO ARRAY,YSHIFT 
    LOCAL DRAW_LOOP,ENDLOOP,NEXT,COIN 
    MOV SI,0 
DRAW_LOOP:        
    MOV DX,ARRAY[SI]
    ;COMPARE ELEMENT WITH 0
    CMP DX,0
    JE ENDLOOP
    ;COMPARE ELEMENT WITH THE TERMINATEING ELEMENT
    CMP DX,0FFFFH
    JE ENDLOOP 
    MOV AX,1H
    AND AX,DX
    JZ NEXT
	MOV AX,ARRAY[SI] 
    ;GET THE LOCATION OF THE OBJECT
    MOV DL,AH 
    MOV DH,0E0H
    AND DH,AL 
    SHR DH,1
	SHR DH,1
	SHR DH,1
	SHR DH,1
	SHR DH,1
    ADD DH,YSHIFT
    SET_CURSOR DH,DL
    ;DRAW THE OBJECT
    MOV AH,09H
    MOV AL,' '
    MOV BH,0
    MOV CX,1H
    PUSH AX
	MOV AX,0002H
	MOV DX,ARRAY[SI]
    AND AX,DX
    JZ COIN 
	POP AX
    MOV BL,0FFH
    JMP NEXT
COIN:
	POP AX 
    MOV BL,0EEH 
NEXT:
    INT 10H   
    INC SI 
    INC SI
    JMP DRAW_LOOP    
ENDLOOP:     
ENDM 


.MODEL SMALL
.STACK 64
.DATA 
; PLAYER1CENTER DW 0400H 
; PLAYER2CENTER DW 0D00H
; PLAYER1OBJECTS DW 3F27H,30 DUP(0H),0FFFFH
; PLAYER2OBJECTS DW 3F65H,30 DUP(0H),0FFFFH
.CODE
DRAW PROC FAR
	; MOV AX,@DATA
	; MOV DS,AX

	DRAW_CRAFT PLAYER1CENTER
    DRAW_CRAFT PLAYER2CENTER
    DRAW_OBJECTS PLAYER1OBJECTS,P1OFFSET
    DRAW_OBJECTS PLAYER2OBJECTS,P2OFFSET
	RET
DRAW ENDP
END
