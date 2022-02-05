;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  I N C A N T   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PINCAN: Activate a magic object via incantation
;
PINCAN  LDX     #ADJTAB         ;find a magic word?
        JSR     PARSER          ;   .
        BLE     PINC99          ;   null/illegal token
        TST     FULFLG          ;spell out the entire word?
        BEQ     PINC99          ;   nope
        STD     OBJTYP          ;store parms
;
        LDU     PLHAND          ;process left hand object
        BSR     PINC10          ;   .
        LDU     PRHAND          ;process right hand object
;
;  Are we holding a ring?
;
PINC10  BEQ     PINC99          ;   empty hand!
        LDA     P.OCCLS,U       ;do we have a ring?
        CMPA    #K.RING         ;   .
        BNE     PINC99          ;   nope
;
;  Did he say the secret word? (and win $50...)
;
        LDA     P.OCXXX+1,U     ;load special object type
        BEQ     PINC99          ;   must have already been INCANTed
        CMPA    OBJTYP          ;does it match the token code?
        BNE     PINC99          ;   nope
;
;  Transform the object...
;
        STA     P.OCTYP,U       ;set the new object type
        SWI                     ;fill in new parameters
        FCB     OCBFIL          ;   .
;
;        SOUND$  A$RING          ;make the ring sound
;
        SWI                     ;   .
        FCB     ISOUND          ;   .
        FCB     A$RING          ;   .
        SWI                     ;show the new ring
        FCB     STATUS          ;   .
        CLR     P.OCXXX+1,U     ;insure he can't do this again
;
;  Terminate the game?
;
        CMPA    #T.RN15         ;is this the OMEGA ring?
        BEQ     WINNER          ;   yes - that's all folks!!!
;
PINC99  RTS                     ;bye



;
;  WINNER: Tell Player the Good News...
;
WINNER  LDX     #WIZ2           ;star wizzard
        DEC     FADFLG          ;fade in
        SWI                     ;   (clear the status line)
        FCB     WIZIN           ;   .
		jsr putstrimm			; display victory message
		fcn '\rBEHOLD! DESTINY AWAITS THE HAND        OF A NEW WIZARD...'
;
        BRA     *               ;round and round (forever)...
;
;;;;;        END
