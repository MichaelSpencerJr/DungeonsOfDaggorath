;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D U N G E O N   V I E W E R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  SETSCL: Set Scaling Based on RANGE
;
SETSCL  PSHS    A,X             ;save regs
        LDX     #HLFSCL         ;assume half-step forward
        TST     HLFSTP          ;   .
        BNE     SSCL10          ;   .
;
        LEAX    (BAKSCL-HLFSCL),X       ;assume half-step backward
        TST     BAKSTP          ;   .
        BNE     SSCL10          ;   .
;
        LEAX    (NORSCL-BAKSCL),X       ;normal scaling
;
SSCL10  LDA     RANGE           ;load range
        LDA     A,X             ;load table entry
        STA     VXSCAL          ;set scaling parameters
        STA     VYSCAL          ;   .
        PULS    A,X,PC          ;restore regs/exit



;
; VIEWER: Subroutine to display, in 3-D perspective view,
;         the player's view of the inside of the maze.
;
; INPUTS:
;
;       PROW     Row occupied by player (Y-coordinate)
;
;       PCOL     Column occupied by player (X-coordinate)
;
;       PDIR     Direction player is facing
;               0 = North
;               1 = East
;               2 = South
;               3 = West
;
;       RLIGHT  Ambient light level in the dungeon. Values can range
;               from 0 to 15 where zero equals total ambient darkness
;               and 5 to 8 is the typical ambient light level at
;               dungeon levels 1 or 2, and 3 to 5 is the ambient
;               light level at dungeon levels 3 or 4.
;
;       MLIGHT  Magical light level. This value is analogous to
;               TLIGHT, but only affects the visibility of magical
;               doors, objects and magical creatures.
;               The ambient light level, RLIGHT does not affect
;               the visibility of magical things.
;
; * * * * * * * * *



;
;  VIEWER: Initialization
;
VIEWER  SWI                     ;clear alternate screen
        FCB     ZFLOP           ;   .
        CLR     RANGE           ;reset range
        LDD     PROW            ;load player position
        STD     DROW            ;make copy
;
;  Main Loop
;
VIEW10  BSR     SETSCL          ;set scaling parameters
        LDD     DROW            ;load our position
        JSR     MAP32           ;calc cell addr
        LDA     ,X              ;load cell contents
        LDU     #NEIBOR         ;extracted data goes here
        LDX     #4              ;loop counter
VIEW12  TFR     A,B             ;make copy of cell contents
        ANDB    #3              ;extract 2 LSBits
        STB     4,U             ;make two copies
        STB     ,U+             ;   .
        LSRA                    ;shift over
        LSRA                    ;   .
        LEAX    -1,X            ;decrement and loop
        BNE     VIEW12          ;   .
;
        LDB     PDIR            ;set base addr for features
        LDU     #NEIBOR         ;   .
        LEAU    B,U             ;   .



;
;  Forward-Looking Architectural Features Drawing Routine
;
VIEW20  LDY     #FLATAB         ;table base addr
;
VIEW22  LDA     ,Y+             ;load relative direction change
        BMI     VIEW30          ;   we are done
;
        LDB     A,U             ;load cell wall features
        LSLB                    ;times 2 for word entries
        CMPB    #HF.SDR*2       ;secret door?
        BNE     VIEW24          ;   nope
;
        LDX     B,Y             ;load secret door vector list addr
        DEC     MAGFLG          ;draw with magic light
        BSR     DRAWIT          ;   .
        LDB     #HF.WAL*2       ;then draw a wall (regular light)
;
VIEW24  LDX     B,Y             ;load vector list addr
        BSR     DRAWIT          ;draw with regular light
;
        LEAY    8,Y             ;advance to next table entry
        BRA     VIEW22          ;loop
COMRTS2 RTS



;
;  PDRAW: Peek-A-Boo Drawing Routine
;
PDRAW   TFR     X,Y             ;save vector list ptr
        TST     B,U             ;passage to our left?
        BNE     COMRTS2         ;   nope
        ADDB    PDIR            ;effect relative change in direction        
        STB     DIR             ;   .
        LDD     DROW            ;our position
        JSR     STEP            ;   .
        JSR     CFIND           ;anything here?
        BEQ     COMRTS2         ;   nope
        EXG     X,Y             ;swap pointers/fall into CMRDRW
;
;  CMRDRW: Draw Magical/Non-Magical Creatures
;
CMRDRW  TST     P.CCMGO,Y       ;magic creature?
        BEQ     DRAWIT          ;   non-magical creature
        DEC     MAGFLG          ;draw with magic light/fall into DRAWIT
;
;  DRAWIT: Draw Vector List in Alternate Screen
;
DRAWIT  PSHS    U               ;save regs
        SWI                     ;set the lighting levels
        FCB     SETFAD          ;   .
        LDU     FLOP            ;alternate screen VDB
        SWI                     ;draw it
        FCB     VCTLST          ;   .
        PULS    U,PC            ;restore regs/exit



;
;  Forward-Looking Creature Drawing Routine
;
VIEW30  LDD     DROW            ;our position
        JSR     CFIND           ;creature here?
        BEQ     VIEW32          ;   nope
;
        TFR     X,Y             ;copy CCB ptr
        LDB     P.CCTYP,Y       ;load creature type
        LSLB                    ;*2 for word offsets
        LDX     #FWDCRE         ;forward looking creature lists
        LDX     B,X             ;load vector list addr
        BSR     CMRDRW          ;draw the creature
VIEW32  LDB     #3              ;peek-a-boo to our left
        LDX     #LPEEK          ;   .
        BSR     PDRAW           ;   .
;
        LDB     #1              ;peek-a-boo to our right
        LDX     #RPEEK          ;   .
        BSR     PDRAW           ;   .
;
;  Draw vertical features
;
        LDX     #CELINE         ;assume ceiling line
        LDD     DROW            ;our position
        JSR     VFIND           ;any vertical features?
        BMI     VIEW40          ;   nope - draw ceiling line
;
        LDX     #FWDVER         ;forward looking vertical features
        LSLA                    ;*2 for word offset
        LDX     A,X             ;load vector list addr
VIEW40  BSR     DRAWIT          ;draw with regular light
;
;  Draw objects
;
        CLR     OFINDF          ;start at top of object lists
VIEW52  LDD     DROW            ;load position
        JSR     OFIND           ;any objects?
        BEQ     VIEW60          ;   nope
;
        LDA     P.OCCLS,X       ;load object class
        LSLA                    ;*2 for word offsets
        LDX     #FWDOBJ         ;forward-looking object vector lists
        LDX     A,X             ;load vector list addr
        DEC     MAGFLG          ;draw with both magic/regular light
        BSR     DRAWIT          ;   .
        BSR     DRAWIT          ;   .
        BRA     VIEW52          ;loop until there are no more objects



;
;  Check "Line-of-Sight"
;
VIEW60  TST     ,U              ;passage in front of us? (2022 n.b. original was 0,U)
        BNE     VIEW99          ;   nope - we are done
;
;  Take a step and increase range
;
        LDA     PDIR            ;restore original direction
        STA     DIR             ;   .
        LDD     DROW            ;our position
        JSR     STEP            ;take a step
        STD     DROW            ;update our position
;
        INC     RANGE           ;have we gone far enough?
        LDA     RANGE           ;   .
        CMPA    #9              ;   .
        LBLE    VIEW10          ;   nope
;
VIEW99  RTS                     ;common RETURN



;
; Scaling constants - look-up table
;
; Values in this table are indexed on RANGE (the distance of an
; object or feature from the player.
;
; Values in the table are fixed point, radix-7, binary.
;
;   B B B B B B B B
;    ^
;    !
;    +-----------------< Binary Point
;
NORSCL  EQU     *               ;base
;
; Range = 0: (cell occupied by player)
;
        FCB     %11001000       ; 1 72/128ths size
;
; Range = 1: (cell immediately in front of player)
;
        FCB     %10000000       ; 128/128ths size (1:1)
;
; Range = 2: (next cell out)
;
        FCB     %01010000       ; 80/128ths size
;
; Range = 3:
;
        FCB     %00110010       ; 50/128ths size
;
; Range = 4:
;
        FCB     %00011111       ; 31/128ths size
;
; Range = 5:
;
        FCB     %00010100       ; 20/128ths size
;
; Range = 6:
;
        FCB     %00001100       ; 12/128ths size
;
; Range = 7:
;
        FCB     %00001000       ; 8/128ths size
;
; Range = 8:
;
        FCB     %00000100       ; 4/128ths size
;
; Range = 9:
;
        FCB     %00000010       ; 2/128ths size



;
; "Half-Step" scaling constant table
;
HLFSCL  EQU     *               ;
;
;
; Range = 0 plus a half step
;
        FCB     255             ; 1 127/128ths size
;
; Range = 1 plus a half step
;
BAKSCL  EQU     *               ;*DEBUG
        FCB     156             ; 1 28/128ths size
;
; Range = 2 plus a half step
;
        FCB     100             ; 100/128ths size
;
; Range = 3 plus a half step
;
        FCB     65              ; 65/128ths size
;
; Range = 4 plus a half step
;
        FCB     40              ; 40/128ths size
;
; Range = 5 plus a half step
;
        FCB     26              ; 26/128ths size
;
; Range = 6 plus a half step
;
        FCB     16              ; 16/128ths size
;
; Range = 7 plus a half step
;
        FCB     10              ; 10/128ths size
;
; Range = 8 plus a half step
;
        FCB     6               ; 6/128ths size
;
; Range = 9 plus a half step
;
        FCB     3               ; 3/128ths size
;
; End of scaling table 2
;
        FCB     1               ;*DEBUG
;
;
;;;;;        END

