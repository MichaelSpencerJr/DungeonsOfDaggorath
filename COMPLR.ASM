;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C O M M O N   P L A Y E R   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     COMPLR
;     LIBRY  CD
;        XDEF    BURNER,LUKNEW,HSLOW
;
;        XREF    ASRD6,MAPPER,ADJTAB,GENTAB,T.TOR05
;        PSCT
;
;
;
;  BURNER: Torch Burn-Time Task
;
BURNER  LDU     PTORCH          ;load ptr to torch OCB
        BEQ     BURN99          ;   no torch!
;
;  Decrement timer
;
        LDA     P.OCXXX,U       ;load timer value
        BEQ     BURN99          ;   dead torch
        DECA                    ;decrement timer
        STA     P.OCXXX,U       ;update timer
        CMPA    #5              ;dead torch at FIVE minutes to go
        BGT     BURN10          ;   still ok
;
;  Torch just died...
;
        LDB     #T.TOR5         ;mark as dead
        STB     P.OCTYP,U       ;   .
        CLR     P.OCREV,U       ;insure it shows up as dead
;
;  Adjust regular/magic light as necessary
;
BURN10  CMPA    P.OCXXX+1,U     ;adjust regular light?
        BGE     BURN20          ;   nope
        STA     P.OCXXX+1,U     ;update regular light
;
BURN20  CMPA    P.OCXXX+2,U     ;adjust magic light?
        BGE     BURN99          ;   nope
        STA     P.OCXXX+2,U     ;adjust magic light
BURN99  DEC     NEWLUK          ;request delayed screen update
;
;        SCHED$  1,Q.MIN         ;once per minute
;
        LDD     #(1*256)+Q.MIN  ;once per minute
        RTS



;
;  LUKNEW: Task to Update the Screen if necessary
;
LUKNEW  TST     NEWLUK          ;did a creature request an update?
        BNE     LNEW10          ;   yes
;
        LDX     #MAPPER         ;is the map display up?
        CMPX    DSPMOD          ;   .
        BNE     LNEW99          ;   nope
;
LNEW10  CLR     NEWLUK          ;reset flag
        SWI                     ;update the screen
        FCB     PUPDAT          ;   .
LNEW99  LDD     #(3*256)+Q.TEN  ;twice per second
        RTS



;
;  HSLOW: Player Damage Recovery
;
HSLOW   CLRA                    ;reset accumulator
        CLRB                    ;   .
        SUBD    PDAM            ;recover 1/64th of damage
        JSR     ASRD6           ;   .
        ADDD    PDAM            ;-(pdmage/64) + pdmage
        BGT     HSLOW2          ;still damage left
;
HSLOW1  CLRA                    ;can't have negative damage
        CLRB                    ;   .
HSLOW2  STD     PDAM            ;update damage counter
        SWI                     ;update the heart rate
        FCB     HUPDAT          ;   .
;
;  Heartrate determines execution frequency
;
        LDA     HEARTR          ;delay time
        LDB     #Q.JIF          ;jiffy queue
        RTS
;
;;;;;        END
