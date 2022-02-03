;       TTL MISC - Miscellaneous SWI Routines
;
;  PROMPT: Prompt the Human for Input
;
PROMPX  LDX     #M$PROM1        ;y'ungry?
        SWI                     ;m'ungry...
        FCB     OUTSTR          ;   .
        RTS                     ;t'seet...
;
M$PROM1 FCB     I.CR,I.DOT
M$CURS  FCB     I.BAR,I.BS,$FF
;
;
;  WAITX: Delay Processing 1.5 Second
;
WAITX   LDB     #81             ;delay for 1.35 seconds
WAIT10  SYNC                    ;wait for a jiffy to occur
        DECB                    ;decrement and loop
        BNE     WAIT10          ;   .
        RTS
;
;  ZERO: Zero a block of RAM  (Called via COMSWI)
;  NEGRAM: Set a Block of RAM to negative ones ($FF)
;
;  Inputs:
;       X - starting addr
;       U - ending addr
;
ZEROX   CLRA                    ;zero RAM
        FCB     SKIP2           ;   .
NEGRAX  LDA     #$FF            ;set RAM to negative ones
;
SETRAX  STA     ,X+             ;set the next byte
        CMPX    10,S            ;are we done?
        BNE     SETRAX          ;   nope
        RTS                     ;done



;
;  WIZIX: Fade In the Wizard
;
;  Inputs:
;       X - vector list addr
;
WIZIX   CLR     HBEATF          ;turn off the heart
        SWI                     ;zap the status line
        FCB     CLRSTS          ;   .
WIZIX0  SWI                     ;clear the primary text area
        FCB     CLRPRI          ;   .
        LDD     #$8080          ;manually set range to one
        STD     VXSCAL          ;   .
;
;  Immediate or Face in?
;
        LDB     FADFLG          ;check flag
        BEQ     WIZI10          ;   show up now!
;
        LDB     #32             ;fade-in
        DEC     NOISEF          ;buzzing noise
;
WIZI10  BSR     WIZZES          ;display the wizard
        DECB                    ;decrease the amount of fade
        DECB                    ;   .
        BPL     WIZI10          ;loop until done
        CLR     NOISEF          ;turn off noise
        CLR     FADFLG          ;reset flag
;
WIZI20  SWI                     ;loud explosion
        FCB     ISOUND          ;   .
        FCB     A$EXP1          ;   .
        RTS                     ;done
;
;  WIZOX: Fade Out the Wizard
;  Inputs:
;       X - vector list addr
;
WIZOX   SWI                     ;clear the primary text area
        FCB     CLRPRI          ;   .
        BSR     WIZI20          ;loud explosion
        CLRB                    ;loud to soft, fade out
        DEC     NOISEF          ;more noise
;
WIZO10  BSR     WIZZES          ;display the wizard
        INCB                    ;increase amount of fade
        INCB                    ;   .
        CMPB    #32             ;   until done
        BNE     WIZO10          ;   .
        CLR     NOISEF          ;turn off noise
        RTS                     ;done



;
;  WIZZES: Draw the Wizard
;
;  Inputs:
;       B - amount of fade/noise
;       X - vector list addr
;
WIZZES  PSHS    X,U             ;save regs
        STB     VCTFAD          ;set fade value
        STB     NOISEV          ;set buzz volume
        SWI                     ;blank the alternate screen
        FCB     ZFLOP           ;   .
        SWI                     ;   .
        FCB     VCTLST          ;   .
        DEC     UPDATE          ;flag for update
        SYNC                    ;wait for flip
        PULS    X,U,PC          ;restore regs/exit



;
;  PREPAR: Display "PREPARE!" on EXAMINE Screen
;
PREPAX  JSR     EXAMIO          ;prepare to do i/o to EXAMINE screen
        LDD     #32*9+12        ;set cursor position
        STD     P.TXCUR,U       ;   .
        SWI                     ;deliver the message
        FCB     OUTSTI          ;   .
        FCB     %00111100       ;PREPARE!
        FCB     %00100100       ;PREPARE!
        FCB     %01011000       ;PREPARE!
        FCB     %00000110       ;PREPARE!
        FCB     %01000101       ;PREPARE!
        FCB     %11011000       ;PREPARE!
;
        CLR     TXBFLG          ;restore standard i/o
        DEC     UPDATE          ;request screen update
        RTS                     ;bye
;;;;;        END

        