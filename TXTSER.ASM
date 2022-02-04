;        TTL TXTSER - Text Service Routines
;
;  TXTSTI: Compressed String Output Immediate
;          Called via COMSWI.
;  Inputs:
;       PC - points to compressed
;  Returns:
;       PC <-- PC + (length of string)
;
TXTSTI  LDX     12,S            ;load string addr
        SWI                     ;expand the string
        FCB     EXPAND          ;   .
        STX     12,S            ;update the return addr
        LDX     #STRING+1       ;expanded string addr
        FCB     SKIP2           ;drop into TXTSTR
;
;  TXTSTR: Output a character string to the display
;          Called via COMSWI.
;  Input:
;       X - pointer to string
;
TSTR10  SWI                     ;print the char
        FCB     OUTCHR          ;   .
TXTSTR  LDA     ,X+             ;get next char
        BPL     TSTR10          ;   loop until terminator ($FF)
        RTS                     ;exit
; Display an ASCIIZ string at X
putstr		pshs a,x			; save registers
		fcb SKIP2				; move over next instruction
putstr000	bsr putchr			; display character
		lda ,x+				; fetch character
		bne putstr000			; brif not end of string - display it
		puls a,x,pc			; restore registers and return
; Display an ASCIIZ string at (S)
putstrimm	pshs a,x			; save registers
		ldx 3,s				; get string pointer
		fcb SKIP2				; move over next instruction
putstrimm000	bsr putchr			; output character
		lda ,x+				; fetch character from string
		bne putstrimm000		; brif not end of string
		stx 3,s				; save new return address
		puls a,x,pc			; restore registers and return
;
;  TXTCHR: Output a character to the screen
;          Called via COMSWI.
;
;  Input:
;       A - Char to write
;
TXTCHR  TST     TXBFLG          ;do standard i/o?
        BNE     TCHR10          ;   nope
        LDU     #TXTPRI         ;i/o to primary text area
;
TCHR10  LDX     P.TXCUR,U       ;load cursor position
        JSR     TXTXXX          ;dispatch to routine
        CMPX    P.TXCNT,U       ;need to scroll?
        BLO     TCHR99          ;   nope
        JSR     TXTSCR          ;scroll one line
TCHR99  STX     P.TXCUR,U       ;update cursor position
        RTS                     ;go home
;
; This routine displays the character in A, which is encoded as ASCII. All registers preserved.
putchr		pshs a,b,x,y,u			; save registers
		tst TXBFLG			; are we looking for standard text mode?
		bne putchr000			; brif not
		ldu #TXTPRI		; point to params for regular text area
putchr000	ldx 4,u				; fetch current location
		jsr rendercharascii		; go render the character
		cmpx 2,u			; are we at the end of the text area?
		blo putchr001			; brif not
		jsr TXTSCR			; go scroll the text area
putchr001	stx 4,u				; save new screen location
		puls a,b,x,y,u,pc		; restore registers and return

