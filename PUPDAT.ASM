;  PUPDAX: Update the screen
;
PUPDAX  TST     FAINT           ;are we unconscious?
        BNE     PUPD99          ;   yes - don't do anything
;
        BSR     PUPSUB          ;generate next display in FLOP
        DEC     UPDATE          ;request screen switch
        SYNC                    ;wait for it to happen
PUPD99  RTS                     ;exit
;
PUPSUB  PSHS    A,B,X,Y,U       ;save some regs
        LDD     PRLITE          ;load player regular/magic light values
        LDU     PTORCH          ;load torch OCB ptr
        BEQ     PSUB10          ;   no torch!
        ADDA    P.OCXXX+1,U     ;add regular light component
        ADDB    P.OCXXX+2,U     ;add magic light component
PSUB10  STD     RLIGHT          ;store player values
;
        JSR     [DSPMOD]        ;create new screen in FLOP
        PULS    A,B,X,Y,U,PC    ;restore regs/go home
;;;;;        END
