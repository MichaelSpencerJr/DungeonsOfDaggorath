;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  R E V E A L   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     PREVEA
;     LIBRY  CD
;        XDEF    PREVEA,PREV00
;
;        XREF    PARHND
;        PSCT
;
;  PREVEA: Reveal a given magical object
;
;  Command Syntax:
;       REVEAL LEFT
;       REVEAL RIGHT
;
PREVEA  JSR     PARHND          ;determine left/right hand
        LDU     ,U              ;load object ptr
        BEQ     PREV99          ;   empty hand
;
;  Confirm Power Requirements have been met
;
        LDA     P.OCREV,U       ;do we have enough power to reveal?
        BEQ     PREV99          ;   already revealed
        LDB     #25             ;   .
        MUL                     ;   .
        CMPD    PPOW            ;   .
        BGT     PREV99          ;   nope
;
;  Transform and Reveal the Object
;
        LDA     P.OCTYP,U       ;copy new parameters
PREV00  SWI                     ;   .
        FCB     OCBFIL          ;   .
        CLR     P.OCREV,U       ;mark as revealed
        SWI                     ;update the status line
        FCB     STATUS          ;   .
;
PREV99  RTS                     ;exit
;
;;;;;        END
