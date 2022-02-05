;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  E X A M I N E   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PEXAM: Examine our Backpack and the Floor
;
;  Command Syntax:
;       EXAMINE
;
PEXAM   LDX     #EXAMIN         ;set the examine display mode
        STX     DSPMOD          ;   .
        SWI                     ;update the display
        FCB     PUPDAT          ;   .
        RTS                     ;bye



;
;  EXAMIN: "EXAMINE" Command Display Generator
;
EXAMIO  SWI                     ;clear alternate screen
        FCB     ZFLOP           ;   .
        LDX     P.VDBAS,U       ;load base addr
        LDU     #TXTEXA         ;i/o to EXAMine screen
        STX     P.TXBAS,U       ;set base address
        DEC     TXBFLG          ;indicate non-std i/o
        RTS                     ;bye
;
EXAMIN  BSR     EXAMIO          ;prepare for i/o to EXAMINE screen
        CLR     NEWLIN          ;indicate we are on a new line
;
;  Print Header
;
        LDD     #10             ;set cursor position
        STD     P.TXCUR,U       ;   .
		jsr putstrimm
		fcn 'IN THIS ROOM\r'
;
;  Check for Creatures
;
        LDD     PROW            ;check for a creature
        JSR     CFIND           ;   .
        BEQ     EXAM10          ;   nothing here
;
        LDX     P.TXCUR,U       ;position cursor
        LEAX    11,X            ;   .
        STX     P.TXCUR,U       ;   .
		jsr putstrimm
		fcn '!CREATURE!\r'



;
;  Check for Objects on the Floor
;
EXAM10  CLR     OFINDF          ;start at beginning
EXAM12  LDD     PROW            ;find an object
        JSR     OFIND           ;   .
        BEQ     EXAM20          ;   no more objects
        BSR     PRTOBJ          ;print object name/new line
        BRA     EXAM12          ;loop



;
;  Draw Separation Line
;
EXAM20  TST     NEWLIN          ;check new line flag
        BEQ     EXAM24          ;   .
        BSR     PCRLF           ;force new line
;
EXAM24  LDD     #(I.EXCL*256)+32        ;I.EXCL,,32
EXAM26  SWI                     ;   .
        FCB     OUTCHR          ;   .
        DECB                    ;   .
        BNE     EXAM26          ;   .
;
;  Print Header
;
        LDX     P.TXCUR,U       ;position cursor
        LEAX    12,X            ;   .
        STX     P.TXCUR,U       ;   .
		jsr putstrimm
		fcn 'BACKPACK\r'
;
;  Display Bag Contents        
;
        LDX     #BAGPTR         ;initial ptr
EXAM30  LDX     P.OCPTR,X       ;advance to next object
        BEQ     EXAM99          ;   exhausted list
;
;  Check for the TORCH
;
        CMPX    PTORCH          ;lighted torch?
        BNE     EXAM32          ;   nope
        COM     P.TXINV,U       ;highlight burning torch
;
EXAM32  BSR     PRTOBJ          ;print object name/new line
        BRA     EXAM30          ;round and round
;
EXAM99  CLR     TXBFLG          ;restore standard i/o
        RTS                     ;bye



;
;  PCRLF: Print Carriage Return/Linefeed
;
PCRLF   LDA     #I.CR           ;print carriage return
        SWI                     ;   .
        FCB     OUTCHR          ;   .
        CLR     NEWLIN          ;reset flag
        RTS
;
;  PRTOBJ: Print the Object Name in Regular Mode
;
PRTOBJ  PSHS    A,B,X           ;save regs
        JSR     OBJNAM          ;determine object name
        SWI                     ;print object name
        FCB     OUTSTR          ;   .
;
        LDA     VDGINV          ;insure highlighting is off
        STA     P.TXINV,U       ;   .
;
;  Determine TAB/CRLF
;
        COM     NEWLIN          ;flip flag
        BEQ     POBJ101         ;   perform new line function
;
        LDD     P.TXCUR,U       ;load cursor position
        ADDD    #16             ;adjust cursor
        ANDB    #$F0            ;   .
        STD     P.TXCUR,U       ;update cursor
        FCB     SKIP2           ;   .
;
POBJ101 BSR     PCRLF           ;output CRLF
POBJ990 PULS    A,B,X,PC        ;restore regs/exit
;
;;;;;        END
