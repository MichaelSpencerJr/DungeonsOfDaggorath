;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D I S P L A Y   C L E A R I N G   R O U T I N E
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
ZFLIPX  LDU     FLIP            ;current VDB ptr
        FCB     SKIP2           ;   .
ZFLOPX  LDU     FLOP            ;alternate VDB ptr
        LDB     VDGINV          ;load inverse mode value
        BSR     CLEAR           ;clear the screen
        STU     10,S            ;return the VDB ptr
        RTS                     ;bye
;
CLRSTX  LDX     #TXTSTS         ;home cursor
        LDU     #STSVDB         ;clear both screens
        BRA     CLRSUB          ;   .
;
CLRPRX  LDX     #TXTPRI         ;home cursor
        LDU     #PRIVDB         ;clear both screens
;
CLRSUB  CLR     P.TXCUR,X       ;home cursor
        CLR     P.TXCUR+1,X     ;   .
        LDB     P.TXINV,X       ;load inverse flag value
        BSR     CLEAR           ;clear the screen
        LEAU    VD.LEN,U        ;advance to next VDB
;
CLEAR   PSHS    A,B,X,Y,U       ;save regs
        SEX                     ;propogate ACCB across ACCA
        TFR     D,Y             ;copy pattern to IY
        LEAX    P.VDBAS,U       ;load ptr to base addr
        LDU     P.VDEND,U       ;load last addr
;
CLEAR1  PSHU    D,Y             ;clear 4 bytes at a time
        CMPU    ,X              ;   .
        BNE     CLEAR1          ;loop until done
        PULS    A,B,X,Y,U,PC    ;restore regs/exit
;
;;;;;        END
