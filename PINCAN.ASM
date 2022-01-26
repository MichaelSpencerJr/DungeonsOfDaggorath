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
        SWI                     ;we have a winner
        FCB     OUTSTI          ;   .
        FCB     %11111111       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %11000100       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %01010100       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00111101       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %10000100       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %11011000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00001000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %01011001       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %11010001       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00101110       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %11001000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00000011       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %01110000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %10100110       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %10010011       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00000101       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00010000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %01010000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00100000       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00101110       ;^BEHOLD! DESTINY AWAITS THE HAND
        FCB     %00100000       ;^BEHOLD! DESTINY AWAITS THE HAND
;
        SWI                     ;and so on...
        FCB     OUTSTI          ;   .
        FCB     %11001000       ;        OF A NEW WIZARD...
        FCB     %00000000       ;        OF A NEW WIZARD...
        FCB     %00000000       ;        OF A NEW WIZARD...
        FCB     %00000000       ;        OF A NEW WIZARD...
        FCB     %00000000       ;        OF A NEW WIZARD...
        FCB     %00000011       ;        OF A NEW WIZARD...
        FCB     %11001100       ;        OF A NEW WIZARD...
        FCB     %00000000       ;        OF A NEW WIZARD...
        FCB     %10000001       ;        OF A NEW WIZARD...
        FCB     %11000101       ;        OF A NEW WIZARD...
        FCB     %10111000       ;        OF A NEW WIZARD...
        FCB     %00101110       ;        OF A NEW WIZARD...
        FCB     %10011101       ;        OF A NEW WIZARD...
        FCB     %00000110       ;        OF A NEW WIZARD...
        FCB     %01000100       ;        OF A NEW WIZARD...
        FCB     %11110111       ;        OF A NEW WIZARD...
        FCB     %10111100       ;        OF A NEW WIZARD...
;
        BRA     *               ;round and round (forever)...
;
;;;;;        END
