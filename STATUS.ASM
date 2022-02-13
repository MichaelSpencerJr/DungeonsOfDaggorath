;
;  STATUX: Status line Update Routine
;
STATUX  LDU     #TXTSTS         ;i/o to status line
        DEC     TXBFLG          ;   .
;
        LDA     VDGINV          ;set status line inverse byte
        COMA                    ;   .
        STA     P.TXINV,U       ;   .
;
;  Left hand
;
        CLRA                    ;clear left hand text area
        CLRB                    ;   .
        BSR     SPACES          ;   .
;
        STD     P.TXCUR,U       ;home the cursor
        LDX     PLHAND          ;display what left hand is holding
        BSR     OBJNAM          ;   .
        jsr     putstr          ;print the string
;
;  Right hand
;
        LDD     #17             ;clear right hand text area
        BSR     SPACES          ;   .
;
        LDX     PRHAND          ;determine right hand object
        BSR     OBJNAM          ;   .
        TFR     X,Y             ;make copy of string ptr
;
;  Right justify
;
        LDD     #33             ;count backwards
STAT10  DECB                    ;decrement
        TST     ,Y+             ;look for end of string
        bne     STAT10          ;not found
;
        STD     P.TXCUR,U       ;position cursor
        jsr     putstr          ;print the string
;
        CLR     TXBFLG          ;resume standard i/o
        RTS                     ;done



;
;  SPACES: Print 15 spaces
;
;  Inputs:
;       D - cursor position
;       U - TXB pointer
SPACES  PSHS    A,B             ;save regs
        STD     P.TXCUR,U       ;position cursor
        LDD     #C.SP*256+15    ;space,,15
SPACE1  jsr     putchr          ;output the char
        DECB
        BNE     SPACE1          ;LOOP
        PULS    A,B,PC          ;restore regs



;
;   OBJNAM: Return string pointer for given object
;
;   Inputs:
;          X - OCB pointer
;
;   Returns:
;         X - object name string pointer
;
OBJNAM  PSHS    A,B,Y,U
        LEAY    ,X              ;copy OCB ptr (setting CC) (2022 n.b. original was 0,X)
        BNE     ONAM10          ;valid pointer
;
        LDX     #M$EMPT         ;empty string
        BRA     ONAM99          ;   .
;
;  Decide what form to use
;
ONAM10  LDU     #TOKEN          ;buffer addr
        TST     P.OCREV,Y       ;has the object been revealed?
        BNE     ONAM20          ;   nope - use generic only
;
;  Copy  <adjective> to buffer
;
        LDA     P.OCTYP,Y       ;load type
        LDX     #ADJTAB+1       ;packed strings
        BSR     COPY$           ;copy to buffer
;
		lda #C.SP			; code for space
		sta -1,u			; make a space after adjective
;
;  Copy  <generic>  to buffer
;
ONAM20  LDA     P.OCCLS,Y       ;class determines generic name
        LDX     #GENTAB+1       ;packed strings
        BSR     COPY$           ;copy to buffer
;
        LDX     #TOKEN          ;return buffer addr
ONAM99  PULS    A,B,Y,U,PC      ;EXIT
;



;
;  COPY$: Copy String from Packed Array to Buffer
;
COPY$   PSHS    A,X             ;save regs
COPY10  DECA                    ;is this the string we want?
        bmi     COPY18          ; brif so
        leax 1,x			; move past object code
COPY15  	ldb ,x+				; are we at the end of the string?        
		bne COPY15			; brif not
		bra COPY10			; go see if we're there yet
COPY18		leax 1,x			; move past object code

;
;  Copy string to buffer
;
COPY20  LDA     ,X+             ;load next char
        STA     ,U+             ;copy to destination
        BNE     COPY20          ;loop
;
        PULS    A,X,PC          ;exit
;
M$EMPT  fcn 'EMPTY'
;
;;;;;        END
