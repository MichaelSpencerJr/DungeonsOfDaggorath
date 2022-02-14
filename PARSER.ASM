;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  P A R S I N G   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Parse a word from the command line and place it in TOKEN. Set Z if no word.
GETTOK	pshs a,x,u			; save registers
		ldu LINPTR			; get input line location
		ldx #TOKEN			; point to word buffer
GTOK10	lda ,u+				; get input character
		cmpa #32			; is it space?
		beq GTOK10		; brif so
		bra GTOK22		; go strip word off line
GTOK20	lda ,u+				; fetch input character
GTOK22	beq GTOK30		; brif end of buffer
		cmpa #32			; is it space?
		beq GTOK30		; brif so
		sta ,x+				; save characte rin word buffer
		cmpx #TOKEND-1			; end of buffer?
		blo GTOK20		; brif not - fetch another character
GTOK30	clr ,x				; flag end of word
		stu LINPTR			; save new location in input buffer
		tst TOKEN			; set Z if no word
        PULS    A,X,U,PC        ;restore regs/go home



;
;  PAROBJ: Parse an object from the line buffer
;
;  Inputs:
;       LINBUF - line buffer
;       LINPTR - line buffer pointer
;  Returns:
;       A - object class
;       B - object type
;       OBJCLS - object class
;       OBJTYP - object type
;       LINPTR - updated past object tokens
;  Format:
;       1) <generic>
;       2) <adjective> <generic>
;  Examples:
;       1) "SCROLL"
;       2) "GUIDANCE SCROLL"
;
PAROBJ  CLR     SPEFLG          ;assume generic form
        LDX     #GENTAB         ;generic token search
        bsr PARSER			; look up word in object type list
        BMI     POBJ10          ;   search failure
        BEQ     PARERR          ;   null tokens are illegal
        STD     OBJTYP          ;store parms
        RTS                     ;go home
;
;  Check for an adjective
;
POBJ10  DEC     SPEFLG          ;must be specific form
        LDX     #ADJTAB         ;search for an adjective
        bsr PARSE0		; look up word in object type list
        BLE     PARERR          ;   null/illegal tokens not allowed
        STD     OBJTYP          ;save adjective parms
;
        LDX     #GENTAB         ;search for generic tokens
        bsr PARSER			; look up keyword
        BLE     PARERR          ;   null/illegal tokens
        CMPB    OBJCLS          ;matching class?
        BNE     PARERR          ;   nope - loser
POBJ99  RTS                     ;return as a winner!



;
;  PARERR: Tell user the bad news
;
PARERR  LEAS    2,S             ;remove return addr
CMDERR  jsr putstrimm			; display "???" for unknown command
		fcn '???'
;
        RTS



; Look up word at wordbuff in keyword list.
PARSE0	pshs a,b,x,y,u			; save registers
		clra				; initialize keyword entry
		bra PARS02		; go look up keyword
; Look up the word at the start of the line  against the keyword list in X. Each keyword list has a prefix byte containing
; additional flags, etc.
UCASE   cmpb    #'a'                    ; is it below lowercase A?
        blo     UCAS00                  ; brif so - no change
        cmpb    #'z'                    ; is it above lowercase Z?
        bhi     UCAS00                  ; brif so
        subb    #C.SP                   ; make it uppercase
UCAS00  rts
PARSER	pshs a,b,x,y,u			; save registers
		clra				; initialize keyword number
		clrb				; flag for no match
		bsr GETTOK			; fetch a word from input
		beq PARS70		; brif no word - return Z set
PARS02	clr PARFLG			; flag no match found
		clr FULFLG			; flag if match is exact
		ldb ,x+				; get number of keywords in list
		stb PARCNT			; save interation count
PARS10	leay 1,x			; point to start of this keyword
		ldu #TOKEN			; point to start of parsed word
PARS20	ldb ,u+				; fetch input character
		beq PARS40		; brif end of input
                bsr UCASE               ; make it upper case
		cmpb ,y+			; does it match?	
		bne PARS50		; brif it doesn't match
		tst ,y				; end of keyword?
		bne PARS20		; brif not
		tst ,u				; end of word?
		bne PARS50		; brif not - no match, keep looking
PARS30	dec FULFLG			; we had an exact match
PARS40	tst PARFLG			; do we already have a match?
		bne PARS60		; brif so - return no match
		inc PARFLG			; flag match found
		ldb ,x				; fetch type code
		std ,s				; save code type and return value
PARS50	inca				; bump keyword number
		dec PARCNT			; are we done iterating?
		bne PARS90		; brif not
		tst PARFLG			; do we have a match?
		bne PARS80		; brif so
PARS60	ldd NEGONE			; load error flag
PARS70	std ,s				; save return value
PARS80	puls a,b,x,y,u,pc		; return results
PARS90	leax 1,x			; move past flag byte
PARS95	ldb ,x+				; fetch character in keyword
		bne PARS95		; brif not end of keyword
		bra PARS10		; go check next word

PARHND		ldx #DIRTAB			; point to direction keywords
		bsr PARSER			; evaluate the specified keyword
        BLE     PARERR          ;   null/illegal token
        LDU     #PRHAND         ;right hand
        CMPA    #T.RT           ;   .
        BEQ     PHND90          ;   .
        LDU     #PLHAND         ;left hand
        CMPA    #T.LT           ;   .
        BNE     PARERR          ;   .
PHND90  LDX     ,U              ;load OCB ptr
        RTS                     ;exit
;
;;;;;        END
