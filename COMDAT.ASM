;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  I N I T I A L I Z A T I O N   D A T A
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     COMDAT
;     LIBRY  CD
;        XDEF    TCBDAT,RAMDAT,DEMDAT,GAMDAT
;        XDEF    DSP0,DSP1,STSVDB,PRIVDB
;        XDEF    CMTTAB,CMTEND
;
;        XREF    T.SWO2,T.SWO3,T.TOR4,T.SHI4
;        XREF    PLAYER,LUKNEW,HSLOW,BURNER,CREGEN
;        XREF    CLOCK,SWISER,GAME,AUTTAB
;        XREF    SW2SER
;
;        PSCT
;
;
;  DEMDAT: Demonstration Mode Initial Player Objects
;
DEMDAT  EQU     *               ;where data starts
        FCB     T.SWO2          ;iron sword
        FCB     T.TOR4          ;pine torch
        FCB     T.SHI4          ;leather shield
        FCB     -1              ;end of data
;
;  GAMDAT: Game Mode Initial Player Objects
;
GAMDAT  EQU     *               ;where data starts
        FCB     T.SWO3          ;wooden sword
        FCB     T.TOR4          ;pine torch
        FCB     -1              ;end of data
;
;  System Task Control Blocks
;
TCBDAT  EQU     *               ;where the data starts
        FDB     PLAYER          ;Human Input Module
        FDB     LUKNEW          ;Delayed Update Task
        FDB     HSLOW           ;Heartrate Hysteresis Task
        FDB     BURNER          ;Torch Burn Module
        FDB     CREGEN          ;Creature Regeneration
        FDB     0               ;end of initial system TCBs



;
;  Initialization Data Format:
;
;          +----------------+
;  Byte 0  !   Byte Count   !
;          +----------------+----------------+
;  Byte 1  !        Starting Address         !
;          +----------------+----------------+
;
INI     MACR
        FCB     \2              ;byte count
        FDB     \1              ;addr
        ENDM



RAMDAT  EQU     *
;
;  Interrupt Vectors
;
        INI     V$SWI2,3*2      ;two interrupt vectors
        JMP     SW2SER          ;SWI2
        JMP     SWISER          ;SWI
        INI     V$IRQ,3*1       ;one IRQ vector        
        JMP     CLOCK           ;IRQ
;
;  ONCE-only Initialization Parameters
;
        INI     BIGONE+1,23     ;where to start
        FCB     1               ;BIGONE (RH)
        FDB     $FFFF           ;NEGONE
        FDB     128             ;VCNTRX
        FDB     76              ;VCNTRY
        FDB     DSP0            ;FLIP
        FDB     DSP1            ;FLOP
        FDB     AUTTAB          ;AUTPTR
        FDB     OCBLND          ;ODBPTR
        FDB     LINBUF          ;LINPTR
        FCB     12              ;PROW
        FCB     22              ;PCOL
        FDB     30+5            ;POJBWT
        FCB     $17,160          ;PPOW
;
;  Text Control Blocks
;
        INI     TXTEXA,(TX.LEN*3)+(CTYPES*5)
;
        FDB     D0$BAS          ;TXTEXA.TXBAS
        FDB     32*19           ;TXTEXA.TXCHR
        FDB     0               ;TXTEXA.TXCUR
        FCB     0,-1            ;TXTEXA.TXINV,,TXTEXA.TXSGL
;
        FDB     D0$BAS+(256*19) ;TXTSTS.TXBAS
        FDB     32*2            ;TXTSTS.TXCHR
        FDB     0               ;TXTSTS.TXCUR
        FCB     -1,0            ;TXTSTS.TXINV,,TXTSTS.TXSGL
;
        FDB     D0$BAS+(256*20) ;TXTPRI.TXBAS
        FDB     32*4            ;TXTPRI.TXCHR
        FDB     0               ;TXTPRI.TXCUR
        FCB     0,0             ;TXTPRI.TXINV,,TXTPRI.TXSGL
;
;  Creature/Level Matrix
;
CMTTAB  FCB     9,9,4,2,0,0,0,0,0,0,0,0
        FCB     2,4,0,6,6,6,0,0,0,0,0,0



        FCB     0,0,0,4,0,6,8,4,0,0,1,0
        FCB     0,0,0,0,0,0,8,6,6,4,0,0
        FCB     2,2,2,2,2,2,2,4,4,8,0,1
CMTEND  EQU     *



;
;  Empty Hand Parameters
;
        INI     P.OCCLS+EMPHND,4 ;two bytes
        FCB     4,0             ;sword noises
        FCB     0,5             ;magic/physical offense
;
;  End of Direct Page RAM Initial Values
;
        FCB     0



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  P U R E   D A T A   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  Vector Display Control Blocks
;
DSP0    FDB     D0$BAS          ;display base addr
        FDB     D0$END          ;display ending addr
        FDB     D0.SAM          ;magic number for SAM
;
DSP1    FDB     D1$BAS          ;display base addr
        FDB     D1$END          ;display ending addr
        FDB     D1.SAM          ;magic number for SAM
;
STSVDB  FDB     D0$BAS+152*32   ;152nd scan line
        FDB     D0$BAS+160*32   ;160th scan line
        FDB     0               ;filler
;
        FDB     D1$BAS+152*32   ;   .
        FDB     D1$BAS+160*32   ;   .
        FDB     0               ;   .
;
PRIVDB  FDB     D0$BAS+160*32   ;160th scan line
        FDB     D0$BAS+192*32   ;192nd scan line
        FDB     0               ;filler
;
        FDB     D1$BAS+160*32   ;   .
        FDB     D1$BAS+192*32   ;   .
        FDB     0               ;   .
;
;;;;;        END
