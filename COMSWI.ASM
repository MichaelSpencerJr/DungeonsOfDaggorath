;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C O M M O N   S W I   D I S P A T C H
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        NAM     COMSWI
;     LIBRY  CD.TXT
;        XDEF    SWISER,SW2SER
;        XDEF    PUPSUB,SNDOBJ,OBJNAM,PLOOK
        
;        XREF    ASRD4,ASRD5,ASRD6,BITMSK
;        XREF    STSVDB,PRIVDB,VFTTAB,EXAMIO,FNDOBJ
;        XREF    SYSTCB,DGNGEN,CBIRTH,VIEWER,TXTXXX,TXTSCR
;        XREF    ADJTAB,GENTAB,FNDCEL,ODBTAB,COPY,XXXTAB
;        XREF    WIZ1,T.SHI4,T.SW03,T.TOR4
;        PSCT
;
;  SWISER: SWI Interrupt Handler
;
SWISER  ANDCC   #~(CC.I&$FF)    ;restore IRQ interrupts
;
        LDX     10,S            ;load return addr
        LDA     ,X+             ;load parameter byte
        STX     10,S            ;update return addr
;
        LDX     #SWIBEG         ;first entry in dispatch table
        LDU     #SWITAB         ;offset table addr
SSER10  LDB     ,U+             ;load next offset
        ABX                     ;add to base addr
        DECA                    ;decrement counter
        BPL     SSER10          ;   not done yet
        STX     ,--S            ;stack dispatch addr
;
        LDD     3,S             ;restore regs before dispatching
        LDX     6,S             ;   .
        LDU     10,S            ;   .
        JSR     [,S++]          ;disatch to routine/exit
        RTI                     ;dismiss the interrupt
;
;  SW2SER: SWI2 Interrupt Handler
;
SW2SER  CLRB                    ;switch to BASIC dp
        TFR     B,DP            ;   .
;
        LDU     10,S            ;load return addr
        LDB     ,U+             ;load BASIC parameter byte
        STU     10,S            ;update return addr
;
        LDU     #$A000          ;table base addr
        JSR     [B,U]           ;dispatch to routine
;
        STA     1,S             ;return parameters
        STX     4,S             ;   .
        RTI                     ;bye



;
;
;  NUM: Define SWI Codes
;
;
FOO     SET     0
;
SETFAD  EQU     FOO             ;set amount of fade based on RANGE
;
VCTLST  EQU     FOO+1           ;vector list processor
;
OUTSTI  EQU     FOO+2           ;string output (string follows)
;
OUTSTR  EQU     FOO+3           ;string output
;
OUTCHR  EQU     FOO+4           ;character output
;
EXPAND  EQU     FOO+5           ;string decompression routine
;
EXPAN0  EQU     FOO+6           ;   secondary entry point
;
RANDOM  EQU     FOO+7           ;random number generator
;
ZFLIP   EQU     FOO+8           ;current screen clear
;
ZFLOP   EQU     FOO+9           ;alternate screen clear
;
CLRSTS  EQU     FOO+10          ;status line clear
;
CLRPRI  EQU     FOO+11          ;primary text area clear
;
HUPDAT  EQU     FOO+12          ;update the heartrate
;
STATUS  EQU     FOO+13          ;update the status line
;
PUPDAT  EQU     FOO+14          ;update the main screen
;
PROMPT  EQU     FOO+15          ;prompt the human for input
;
WAIT    EQU     FOO+16          ;wait for a number of jiffies
;
ZERO    EQU     FOO+17          ;clear RAM
;
NEGRAM  EQU     FOO+18          ;set RAM to negative one
;
WIZIN   EQU     FOO+19          ;fade-in
;   
WIZIN0  EQU     FOO+20          ;   secondary entry point
;
WIZOUT  EQU     FOO+21          ;fade-out
;
PREPAR  EQU     FOO+22          ;"PREPARE!" msg on EXAMINE screen
;
OBIRTH  EQU     FOO+23          ;object creation routine
;
OCBFIL  EQU     FOO+24          ;OCB filling routine



;
INIVU   EQU     FOO+25          ;create initial view
;
NEWLVL  EQU     FOO+26          ;create a new level
;
ISOUND  EQU     FOO+27          ;   secondary entry point
;
SOUNDS  EQU     FOO+28          ;sound routines
;
SWIBEG  EQU     *               ;where the code starts
;
;;;;;        END
