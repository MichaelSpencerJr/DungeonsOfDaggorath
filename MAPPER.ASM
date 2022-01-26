;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  M A P   D I S P L A Y   G E N E R A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     MAPPER
;     LIBRY  CD
;        XDEF    MAPPER
;
;        XREF    FNDOBJ,MAP32
;        PSCT
;
;  MAPPER: Generate a Top-View Display of the Dungeon
;
;  This routines creates a top-view map of the current dungeon
;  level in the alternate screen (FLOP).
;
;  Legend:
;       Black - Clear Path
;       Blue  - Door
;       Red   - Secret Door
;       White - Wall
;
MAPPER  LDU     FLOP            ;use alternate VDB
        LDD     #$1F1F          ;set initial row,col
        STD     DROW            ;   .
;
MAPP10  LDD     DROW            ;load current position
        BSR     DSP32           ;calculate display cell addr
        JSR     MAP32           ;calculate cell addr
        CLRB                    ;assume empty cell (solid black)
        LDA     ,X              ;walled in cell?
        INCA                    ;   .
        BNE     MAPP20          ;   nope
        DECB                    ;unoccupiable cell (solid white)
;
;  Store Empty/Full Cell Pattern into Display
;
MAPP20  LDA     #6              ;loop count
MAPP22  STB     ,Y              ;store byte (2022 n.b. original was 0,Y)
        LEAY    32,Y            ;advance to next scan line
        DECA                    ;decrement and loop
        BNE     MAPP22          ;   .
;
;  Bump Counters
;
        DEC     DCOL            ;inner loop
        BPL     MAPP10          ;   .
;
        LDA     #31             ;outer loop
        STA     DCOL            ;   (reset inner loop counter)
        DEC     DROW            ;   .
        BPL     MAPP10  ;   .



;
;  Display Other Features?
;
        TST     MAPFLG          ;check the flag
        BEQ     MAPP50          ;   just show our position
;
;  Mark Objects
;
        CLR     OFINDF          ;start at top of list
MAPP30  JSR     FNDOBJ          ;find the next object on this level
        BEQ     MAPP40          ;   done
;
        TST     P.OCOWN,X       ;owned by anyone?
        BNE     MAPP30          ;   yes
;
        LDD     P.OCROW,X       ;load position
        BSR     DSP32           ;calculate display addr
        LDD     #$0008          ;mark object
        BSR     MARK4           ;   .
        BRA     MAPP30          ;loop until done
;
;  Mark Creatures
;
MAPP40  LDX     #CCBLND-CC.LEN  ;starting point
MAPP42  LEAX    CC.LEN,X        ;advance ptr
        CMPX    #CCBEND         ;done yet?
        BEQ     MAPP50          ;   yes
;
        TST     P.CCUSE,X       ;live creature?
        BEQ     MAPP42          ;   nope
;
        LDD     P.CCROW,X       ;load position
        BSR     DSP32           ;calculate display addr
        LDD     #$1054          ;mark creature
        BSR     MARK4           ;   .
        BRA     MAPP42          ;loop until done



;
;  DSP32: Local Subroutine to Calculate Display Offset
;
;  Inputs:
;       A - Row
;       B - Col
;       U - Ptr to VDB
;  Returns:
;       Y - Display Addr
;
DSP32   TFR     D,Y             ;duplicate row,col
        LDB     #32*6           ;multiply by row byte count
        MUL                     ;   .
        ADDD    P.VDBAS,U       ;add display offset
        EXG     D,Y             ;swap
        LEAY    B,Y             ;   .
        RTS                     ;restore regs/exit
;
;  MARK4: Local Subroutine to Mark the Inner Cells
;
MARK4   STA     32*1,Y
        STB     32*2,Y
        STB     32*3,Y
        STA     32*4,Y
COMRTS1 RTS



;
;  Mark Player
;
MAPP50  LDD     PROW            ;our position
        BSR     DSP32           ;calculate display addr
        LDD     #$2418          ;mark our position
        BSR     MARK4           ;"X" marks the spot
;
;  Mark Vertical Features
;
        LDX     VFTPTR          ;vertical features index
        BSR     MAPP60          ;up vertical features
;
;  Common Subroutine to mark Vertical Features
;
MAPP60  LDA     ,X+             ;end of table?
        BMI     COMRTS1         ;   yes - we are done
        LDD     ,X++            ;load position
        BSR     DSP32           ;calculate display addr
        LDD     #$3C24          ;mark the cell
        BSR     MARK4           ;   .
        BRA     MAPP60          ;loop until done
;
;;;;;        END
