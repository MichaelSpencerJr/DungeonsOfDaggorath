;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D U N G E O N   G E N E R A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  DGNGEN: Subroutine to generate the dungeon.
;
; Resulting dungeon is created in a row/column matrix
; based at DGNMAP.
;
; Architecture and contents of the dungeon are based
; on predetermined "seeds" passed to the random number
; generator in COMMON.TXT
;
; Dungeon matrix format is as follows:
;
;   B B B B B B B B
;   --- --- --- ---
;    !   !   !   !
;    !   !   !   +--------- North Features
;    !   !   !
;    !   !   +------------- East Features
;    !   !
;    !   +----------------- South Features
;    !
;    +--------------------- West Features
;
; Bit Patterns denote:
;       00 = Passage
;       01 = Regular Door
;       10 = Secret Door
;       11 = Wall
;
N.WALL  EQU     %00000011
E.WALL  EQU     %00001100
S.WALL  EQU     %00110000
W.WALL  EQU     %11000000
;
;  FRIEND: Copy Neighbors to Storage
;
;  Inputs:
;       A - row
;       B - column
;       U - addr of storage
;  Returns:
;       0,U  1,U  2,U   \
;       3,U  4,U  5,U    >  3x3 matrix centered on ROW,COL
;       6,U  7,U  8,U   /
;
FRIEND  PSHS    A,B,X,U         ;save regs
        DECA                    ;upper row
        BSR     FSUB10          ;   .
        INCA                    ;middle row
        BSR     FSUB10          ;   .
        INCA                    ;lower row
        BSR     FSUB10          ;   .
        PULS    A,B,X,U,PC      ;restore regs/exit
;
FSUB10  PSHS    A,B             ;save regs
        DECB                    ;left column
        BSR     FSUB20          ;   .
        INCB                    ;center column
        BSR     FSUB20          ;   .
        INCB                    ;right column
        FCB     SKIP2           ;drop into FSUB20 (hack!)...
;
FSUB20  PSHS    A,B             ;save position
        BSR     BORDER          ;are we out of bounds?
        BNE     FSUB22          ;   yes
        BSR     MAP32           ;calculate map addr
        LDA     ,X              ;load cell contents
        FCB     SKIP2           ;   .
;
FSUB22  LDA     #$FF            ;solid wall pattern
        STA     ,U+             ;store into storage
        PULS    A,B,PC          ;restore regs/exit






;
;  RNDCEL: Pick A Random Cell in DGNMAP
;
;  Returns:
;       A - Row
;       B - Column
;       X - DGNMAP addr
;  Calls:
;       MAP32
;
RNDCEL  SWI                     ;a pair of random numbers
        FCB     RANDOM          ;
        ANDA    #31             ;MOD 32
        TFR     A,B             ;   .
        SWI                     ;   (then fall into MAP32)
        FCB     RANDOM          ;   .
        ANDA    #31             ;MOD 32
;
;  MAP32: Calculate Map Address Based on ROW/COL
;
;  Inputs:
;       A - row
;       B - col
;  Returns:
;       X - DGNMAP addr
;
MAP32   PSHS    A,B             ;save regs
        ANDA    #31             ;insure row/col are MOD 32
        ANDB    #31             ;   .
        TFR     D,X             ;make a copy of row/col
        LDB     #32             ;offset = row*32 + col
        MUL                     ;   .
        ADDD    #MAZLND         ;add base addr
        EXG     D,X             ;D<--row/col, X<--DGNMAP+(row*32)
        ABX                     ;add col to addr
        PULS    A,B,PC          ;restore regs/exit



;
;  BORDER: Are we out-of-bounds?
;
;  Inputs:
;       A - row
;       B - col
;  Returns:
;       Z - Condition code set if position is legal
;
BORDER  PSHS    A,B             ;---start of procedure BORDER
        ANDA    #31             ;MOD 32
        CMPA    ,S              ;still same after MOD? (2022 n.b. original was 0,S)
        BNE     BORD99          ;   nope
        ANDB    #31             ;MOD 32
        CMPB    1,S             ;still same?
BORD99  PULS    A,B,PC          ;--- end of procedure BORDER



;
;  DGNGEN: Create the Dungeon Maze
;
DGNGEN  EQU     *               ;in the beginning...
;
;  Phase I: Create Maze
;
        LDX     #MAZLND         ;all of "maze" to $FF
        LDU     #MAZEND         ;   .
        SWI                     ;   .
        FCB     NEGRAM          ;   .
;
; Initialize RANDOM number generator
        LDX     #LVLTAB         ;point to random seed table
        LDB     LEVEL           ;load dungeon level #
        ABX                     ;point to 3-byte seed
        LDD     ,X++            ;first two bytes
        STD     SEED            ;   .
        LDA     ,X              ;third byte
        STA     SEED+2          ;   .
;
        LDY     #500            ;number of cells to create
        JSR     RNDCEL          ;pick a random starting cell
        STD     DROW            ;   .



;
;  Select a Random Direction/Distance
;
DGEN10  SWI                     ;random direction
        FCB     RANDOM          ;   .
        ANDA    #3              ;MOD 4
        STA     DIR             ;   .
        SWI                     ;random distance
        FCB     RANDOM          ;   .
        ANDA    #7              ;MOD 8
        INCA                    ;range (1:8)
        STA     DST             ;   .
        BRA     DGEN30          ;   .
;
;  Perform Distance Check
DGEN20  LDD     ROW             ;update position
        STD     DROW            ;   .
        DEC     DST             ;decrement distance counter
        BEQ     DGEN10          ;   done - select a new dir/dst
;
;  Take a "tentative" step
;
DGEN30  LDD     DROW            ;parms to STEP
        JSR     STEP            ;take a step
        BSR     BORDER          ;out-of-bounds?
        BNE     DGEN10          ;   yes!



;
;  Have we been here before?
;
        STD     ROW             ;store position for later
        TST     ,X              ;have we been here before?
        BEQ     DGEN20          ;   non-virgin/loop
;
;  Check for "cleared" corner patterns
;
        LDU     #NEIBOR         ;addr of "neighbors" storage
        JSR     FRIEND          ;copy our "friends"
;
        LDA     3,U             ;upper left corner
        ADDA    ,U              ;   . (2022 n.b. original was 0,U)
        ADDA    1,U             ;   .
        BEQ     DGEN10          ;   loser
;
        LDA     1,U             ;upper right corner
        ADDA    2,U             ;   .
        ADDA    5,U             ;   .
        BEQ     DGEN10          ;   loser
;
        LDA     5,U             ;lower right corner
        ADDA    8,U             ;   .
        ADDA    7,U             ;   .
        BEQ     DGEN10          ;   loser
;
        LDA     7,U             ;lower left corner
        ADDA    6,U             ;   .
        ADDA    3,U             ;   .
        BEQ     DGEN10          ;   loser
;
;  Count new cells and loop
;
        CLR     ,X              ;mark a new cell
        LEAY    -1,Y            ;decrement cell count
        BNE     DGEN20          ;loop until done



;
;  Phase II: Create Walls
;
        CLR     DROW            ;reset indices
        CLR     DCOL            ;   .
;
DGEN50  LDD     DROW            ;calculate cell addr
        JSR     MAP32           ;   .
        LDA     ,X              ;load cell contents
        INCA                    ;check for completely walled cell
        BEQ     DGEN70          ;   skip processing
;
;  Determine Neighbors
;
        LDD     DROW            ;load position
        LDU     #NEIBOR         ;where to put neighbors
        JSR     FRIEND          ;find our friends
        LDA     ,X              ;load cell contents
        LDB     #$FF            ;solid wall pattern
;
;  Create Walls
;
        CMPB    1,U             ;wall to the north?
        BNE     DGEN60          ;   nope
        ORA     #N.WALL         ;create northern wall
;
DGEN60  CMPB    3,U             ;wall to the west?
        BNE     DGEN62          ;   nope
        ORA     #W.WALL         ;create western wall
;
DGEN62  CMPB    5,U             ;wall to the east?
        BNE     DGEN64          ;   nope
        ORA     #E.WALL         ;create eastern wall
;
DGEN64  CMPB    7,U             ;wall to the south?
        BNE     DGEN66          ;   nope
        ORA     #S.WALL         ;create southern wall
;
DGEN66  STA     ,X              ;store "walled" cell



;
;  Bump Indexes and Loop
;
DGEN70  LDB     #32             ;rollover value
        INC     DCOL            ;bump column counter
        CMPB    DCOL            ;   .
        BNE     DGEN50          ;   loop
        CLR     DCOL            ;reset column counter
;
        INC     DROW            ;bump row counter
        CMPB    DROW            ;   .
        BNE     DGEN50          ;   loop
;
;  Create Doors/Secret Doors
;
        LDB     #70             ;number of regular doors
        LDU     #DORTAB         ;   .
DGEN80  BSR     MAKDOR          ;put in a door
        DECB                    ;decrement count
        BNE     DGEN80          ;   .
;
        LDB     #45             ;number of secret doors
        LDU     #SDRTAB         ;   .
DGEN82  BSR     MAKDOR          ;put in a secret door
        DECB                    ;decrement count
        BNE     DGEN82          ;   .
;
;  Spin the random number generator
;
        LDB     SECOND          ;use the jiffy counter
DGEN90  SWI                     ;another random number
        FCB     RANDOM          ;   .
        DECB                    ;decrement counter
        BNE     DGEN90          ;   .
;
        RTS                     ;bye



;
;  MAKDOR: Create Doors
;
;  Inputs:
;       A - door pattern
;       U - table of doors
;
MAKDOR  PSHS    A,B,X,Y,U       ;save regs
        LDY     #MSKTAB         ;table of bit masks
;
;  Where can we put a door in?
;
MDOR10  JSR     RNDCEL          ;get a random cell
        STD     ROW             ;store for later use
        LDB     ,X              ;can we put a door here?
        CMPB    #$FF            ;   .
        BEQ     MDOR10          ;   nope
;
        SWI                     ;random (0:3)
        FCB     RANDOM          ;   .
        ANDA    #3              ;   .
        STA     DIR             ;this will be our direction
        BITB    A,Y             ;can we put a door in?
        BNE     MDOR10          ;   nope
;
;  Found a suitable place for a door...
;
        ORB     A,U             ;put the door in
        STB     ,X              ;   .
;
        LDD     ROW             ;calculate coordinates
        JSR     STEP            ;remember to fix adjoining cell
        LDB     DIR             ;load original direction
        ADDB    #2              ;opposite wall
        ANDB    #3              ;MOD 4
        LDA     ,X              ;load adjoining cell features
        ORA     B,U             ;mark new door
        STA     ,X              ;update cell
;
        PULS    A,B,X,Y,U,PC    ;restore regs/exit



;
;  Dungeon Generator Seeds
;
LVLTAB  EQU     *
;DEBUG         FCB     $25             ;level-0
        FCB     $73             ;level-1
        FCB     $C7             ;level-2
        FCB     $5D             ;level-3
        FCB     $97             ;level-4
        FCB     $F3             ;level-5
        FCB     $13             ;   .
        FCB     $87             ;   .
;
;  Bit Mask Table
;
MSKTAB  FCB     %00000011       ;north
        FCB     %00001100       ;east
        FCB     %00110000       ;south
        FCB     %11000000       ;west
;
;  Regular Door Table
;
DORTAB  FCB     HF.DOR          ;north
        FCB     HF.DOR*4        ;east
        FCB     HF.DOR*16       ;south
        FCB     HF.DOR*64       ;west
;
;  Secret Door Table
;
SDRTAB  FCB     HF.SDR          ;north
        FCB     HF.SDR*4        ;east
        FCB     HF.SDR*16       ;south
        FCB     HF.SDR*64       ;west
;
;;;;;        END
