;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   M O V E M E N T   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  OFIND: Find an unowned object based on position
;
;  Inputs:
;       A - Row
;       B - Column
;       OFINDF - flag to indicate ptr "rewind" (0 - start again)
;  Returns:
;       X - pointer to Object Control Block (OCB)
;       Z - condition code set if search fails
;
OFIND   BSR     FNDOBJ          ;find next object on our level
        BEQ     OFIND9          ;   search failure
        CMPD    P.OCROW,X       ;position match?
        BNE     OFIND           ;   nope - try again
        TST     P.OCOWN,X       ;owned by anyone?
        BNE     OFIND           ;   yes - try again
        ANDCC   #~(CC.Z&$FF)    ;winner!
OFIND9  RTS                     ;bye



;
;  FNDOBJ: Find the next object on our level
;
;  Inputs:
;       OFINDF - flag to indicate ptr "rewind" (0 - start again)
;  Returns:
;       X - ptr to Object Control Block (OCB)
;       Z - condition code set if search fails
;
FNDOBJ  PSHS    A               ;save regs
        LDA     LEVEL           ;load current level number
;
        LDX     OFINDP          ;assume old ptr
        TST     OFINDF          ;initialize ptr?
        BNE     FIND10          ;   nope
        LDX     #OCBLND-OC.LEN  ;top of table
        DEC     OFINDF          ;say we have started
;
FIND10  LEAX    OC.LEN,X        ;advance to next entry
        STX     OFINDP          ;update ptr
        CMPX    OCBPTR          ;reach end of table?
        BEQ     FIND99          ;   yes - loser
;
        CMPA    P.OCLVL,X       ;is this object on our level?
        BNE     FIND10          ;   nope
        ANDCC   #~(CC.Z&$FF)    ;winner!
FIND99  PULS    A,PC            ;restore regs/exit



;
;  CFIND: Find a creature based on position
;
;  Inputs:
;       A - Row
;       B - Column
;
;  Returns:
;       X - Pointer to CCB (invalid if search fails)
;       Z - condition code set if search fails
;
CFIND   LDX     #CCBLND-CC.LEN  ;load pointer to CCB table
;
CFND10  LEAX    CC.LEN,X        ;advance to next CCB
        CMPX    #CCBEND         ;check for overrun
        BEQ     CFND99          ;   loser!
        CMPD    P.CCROW,X       ;is this the creature we want?
        BNE     CFND10          ;   nope
;
CFND30  TST     P.CCUSE,X       ;insure that this is a live creature
        BEQ     CFND10          ;   oops - dead (invalid) creature
;
CFND99  RTS                     ;winner!
;
;  FNDCEL: Find an occupiable cell
;
;  Returns:
;       A - Row
;       B - Col
;
FNDCEL  PSHS    A,B,X           ;save regs
FCEL10  JSR     RNDCEL          ;pick a cell, any cell
        STD     ,S              ;assume row/col is ok (2022 n.b. original was 0,S)
        LDA     ,X              ;can we live here?
        INCA                    ;   (solid wall = $FF)
        BEQ     FCEL10          ;   nope
        PULS    A,B,X,PC        ;restore regs/exit



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   P O P U L A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  CBIRTH: Give Birth to a Creature
;
;  Inputs:
;       A - Creature Type
;  Outputs:
;         - Creates a Creature Control Block (CCB)
;         - Creates and schedules CMOVE TCB
;
CBIRTH  PSHS    A,B,X,Y,U       ;save some regs
;
;  Find the next available CCB
;
        LDU     #CCBLND-CC.LEN  ;CCB table base addr
CBIR00  LEAU    CC.LEN,U        ;advance to next CCB
        TST     P.CCUSE,U       ;is this CCB free?
        BNE     CBIR00          ;   no
        DEC     P.CCUSE,U       ;mark CCB in-use
;
;  Fill in the new CCB
;
        STA     P.CCTYP,U       ;store the creature type
        LDB     #CD.LEN         ;calculate offset into CDBTAB
        MUL                     ;   .
        ADDD    #CDBTAB         ;add CDB table base addr
        TFR     D,Y             ;source ptr
        TFR     U,X             ;destination ptr
        LDA     #CD.LEN         ;number of bytes to copy
        JSR     COPY            ;copy ROM info
;
;  Place the new creature in the maze
;
CBIR20  BSR     FNDCEL          ;find an occupiable cell
        BSR     CFIND           ;does somebody else already live here?
        BNE     CBIR20          ;   oops, somebody here already
        STD     P.CCROW,U       ;save position in CCB
;
;  Create the Creature Movement TCB
;
        TFR     U,X             ;copy CCB ptr
        JSR     GETTCB          ;allocate core for TCB
        STX     P.TCDTA,U       ;store CCB ptr
        LDD     #CMOVE          ;store routine name
        STD     P.TCRTN,U       ;   P.
        LDA     P.CCTMV,X       ;load the delay time
        LDB     #Q.TEN          ;into the TENTH queue
        JSR     QUEADD          ;add to the correct queue
;
        PULS    A,B,X,Y,U,PC    ;restore regs/go home



;
;  VFIND: Vertical Feature Search Routine
;
;  Inputs:
;       A - row
;       B - column
;  Returns:
;       A - vertical feature code
;       N - condition code set if earch fails
;
VFIND   PSHS    A,B,X,U         ;save regs
        LDU     VFTPTR          ;base addr of vertical features table
        BSR     VSUB00          ;check for vertical features up
        TSTA                    ;   .
        BPL     VFIND9          ;   winner
;
        BSR     VSUB00          ;check for vertical features down
        ADDA    #2              ;   .
VFIND9  STA     ,S              ;store return code (2022 n.b. original was 0,S)
        PULS    A,B,X,U,PC      ;restore regs/exit
;
VSUB00  LDA     ,U+             ;load vertical feature code
        BMI     VSUB99          ;   end of table
        LDX     ,U++            ;load vertical feature position
        CMPX    2,S             ;did we get a match?
        BNE     VSUB00          ;   nope
VSUB99  RTS                     ;bye



;
;  Vertical Features Table
;
VFTTAB  EQU     *
;                               ;level  0    1    2    3    4
        FCB     -128            ;
        FCB     1,00,23         ;ladder DN   UP
        FCB     0,15,04         ;hole   DN   UP
        FCB     0,20,17         ;hole   DN   UP
        FCB     1,28,30         ;ladder DN   UP
        FCB     -128            ;
        FCB     1,02,03         ;ladder      DN   UP
        FCB     0,03,31         ;hole        DN   UP
        FCB     0,19,20         ;hole        DN   UP
        FCB     0,31,00         ;hole        DN   UP
        FCB     -128            ;
        FCB     -128            ;
        FCB     0,00,31         ;hole                  DN   UP
        FCB     0,05,00         ;hole                  DN   UP
        FCB     0,22,28         ;hole                  DN   UP
        FCB     0,31,16         ;hole                  DN   UP
        FCB     -128            ;
        FCB     -128            ;



;
;  CREGEN: Creature Regeneration Task
;
CREGEN  LDX     CMXPTR          ;load current matrix level ptr
        LDB     #CTYPES-1       ;number of creatures - 1
        CLRA                    ;reset accumulator
;
CGEN10  ADDA    B,X             ;figure number of creatures on level
        DECB                    ;are we done?
        BPL     CGEN10          ;   nope
;
        CMPA    #32             ;max number of creatures on this level?
        BHS     CGEN99          ;   yes
;
        SWI                     ;create a random creature
        FCB     RANDOM          ;   .
        ANDA    #7              ;(0-7)
        ADDA    #2              ;(2-9)
        INC     A,X             ;allow an extra creature of this type
;
CGEN99  SCHED$  5,Q.MIN         ;re-sched every 5 minutes
        RTS
;
;
;;;;;        END
