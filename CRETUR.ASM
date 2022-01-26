;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   M O V E M E N T   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The actions of a creature are governed primarily by
;  what is in the cell with him/her/it:
;
;  1)  Treasures/Magical Objects
;           A creature will pick up whatever is in the cell.
;      If there is more than one object, the creature will
;      pick them up one at a time.  Since the highest priority
;      action for a creature is to gather objects, the human
;      can delay creature attacks by dropping objects.
;
;  2)  Attacking Unlucky Adventurers
;           If a human should happen to be in the same cell as
;      creature, the creature will attack.  Creature attacks will
;      be repeated at "attack" speed (shorter delay times).
;
;  3)  Moving toward Tasty Humans
;             If there is nothing in the cell, the creature will
;      "look" for the human.  If it can see the human, the
;      creature will attempt to close.  The creature will move
;      randomly if it cannot see the human.



;
;  CMOVE:  Creature Movement Task
;
CMOVE   LDY     P.TCDTA,U       ;load CCB pointer
        TST     FRZFLG          ;are we "frozen"?
        BNE     CMOV12          ;   yes!
;
;  Kill Off Dead Creatures
;
        LDB     P.CCUSE,Y       ;are we still alive?
        BNE     CMOV10          ;   yes
        RTS                     ;dead creature - zap the TCB
;
;  Should I pick up objects?
;
CMOV10  LDA     P.CCTYP,Y       ;what am I?
        CMPA    #6              ;   .
        BEQ     CMOV20          ;   I am a SCORPION!
        CMPA    #10             ;   .
        BGE     CMOV20          ;   I am a WIZZARD!
;
;  Look for Treasures/Objects
;
        LDD     P.CCROW,Y       ;our position
        CLR     OFINDF          ;look for an object
        JSR     OFIND           ;   .
        BEQ     CMOV20          ;   no objects here
;
;  Pick up an object
;
        LDD     P.CCOBJ,Y       ;load current object ptr
        STX     P.CCOBJ,Y       ;new object becomes our first object
        STD     P.OCPTR,X       ;link new object with rest of list
        DEC     P.OCOWN,X       ;mark object as creature owned
        SWI                     ;request immediate update
        FCB     PUPDAT          ;   .
;
CMOV12  JMP     CMOV90          ;done for this turn



;
;  Attack Any Unlucky Adventurers
;
CMOV20  LDD     P.CCROW,Y       ;is the player here?
        CMPD    PROW            ;   .
        BNE     CMOV50          ;   nope
;
        LDA     P.CCTYP,Y       ;creature type
        LDB     #$FF            ;loud
        SWI                     ;   .
        FCB     SOUNDS          ;   .
;
;  Set Player Shielding Parameters
;
        LDD     #$8080          ;load minimal shielding values
        LDX     PLHAND          ;process left hand
        BSR     SHIELD          ;   .
        LDX     PRHAND          ;process right hand
        BSR     SHIELD          ;   .
        STA     PMGD            ;store shielding parameters
        STB     PPHD            ;   .
;
;  Process Actual Attack
;
        TFR     Y,X             ;creature is the attacker
        LDU     #PLRBLK         ;the player is the defender
        JSR     ATTACK          ;drop the hammer!
        BMI     CMOV30          ;   missed...
;
;
;
;        SOUND$  A$KLK3          ;CLANK!!!
;
        SWI                     ;CLANK!!!
        FCB     ISOUND          ;   .
        FCB     A$KLK3          ;   .
        JSR     DAMAGE          ;we took a chunk out of him
;
CMOV30  SWI                     ;update the heartrate
        FCB     HUPDAT          ;   .
        JMP     CMOV92          ;prepare for next attack
;
;  SHIELD: Local routine to process Shield
;
SHIELD  PSHS    A,B,X           ;save regs
        BEQ     SHLD99          ;   empty hand!
        LDA     P.OCCLS,X       ;load class
        CMPA    #K.SHIE         ;is it a shield?
        BNE     SHLD99          ;   nope
        LDX     P.OCXXX,X       ;store greater value as return parms
        CMPX    ,S              ;   . (2022 n.b. original was 0,S)
        BHS     SHLD99          ;   current shielding is superior
        STX     ,S              ;upgrade shielding (2022 n.b. original was 0,S)
SHLD99  PULS    A,B,X,PC        ;restore regs/exit



;
;  See if we are vertically/horizontally in line with player
;
CMOV50  CMPA    PROW            ;   .
        BNE     CMOV52          ;   nope
;
        LDA     P.CCCOL,Y       ;are we west/east of player?
        LDB     #1              ;assume we are west of player
        SUBA    PCOL            ;   .
        BMI     CMOV60          ;   west of player
        LDB     #3              ;east of player
        BRA     CMOV60          ;   .
;
CMOV52  LDD     P.CCROW,Y       ;same column as player?
        CMPB    PCOL            ;   .
        BNE     CMOV70          ;   nope
;
        LDB     #2              ;assume north
        SUBA    PROW            ;   .
        BMI     CMOV60          ;   north of player
        CLRB                    ;south of player
;
;  In-Line with Player - can we see him?
;
CMOV60  STB     DIR             ;store the direction
        LDD     P.CCROW,Y       ;load current position
;
CMOV62  BSR     STEPOK          ;take a tentative step
        BNE     CMOV70          ;   loser - we hit a wall!
        CMPD    PROW            ;player here?
        BNE     CMOV62          ;   not here - keep looking
;
;  Saw the player!
;
        LDB     DIR             ;load direction of travel
        STB     P.CCDIR,Y       ;face creature toward player
        CLRB                    ;no relative change in direction
        BRA     CMOV78          ;move toward player if possible



;
;  Select Random Movement Sequence
;
CMOV70  LDX     #MOVTAB         ;assume fwd/lt/rt sequence
        SWI                     ;use other sequence?
        FCB     RANDOM          ;   .
        TSTA                    ;   .
        BMI     CMOV72          ;   nope
        LEAX    3,X             ;use fwd/rt/lt sequence
;
;  Attempt to change directions 25% of the time
;
CMOV72  ANDA    #3              ;use 2 LSBits of random for that 25%
        BNE     CMOV74          ;   not this time
        LEAX    1,X             ;(LT/RT) or (RT/LT) before FWD (magic!)
;
;  Try the preferential directions
;
CMOV74  LDA     #3              ;loop count
CMOV76  LDB     ,X+             ;load next relative change
        BSR     CWALK           ;attempt to move
        BEQ     CMOV90          ;   winner!
        DECA                    ;try again
        BNE     CMOV76          ;   .
;
        LDB     #2              ;finally try to back out
CMOV78  BSR     CWALK           ;don't care if we can't move
;
CMOV90  LDA     P.CCTMV,Y       ;assume movement delay time
;
        LDX     P.CCROW,Y       ;same square as player?
        CMPX    PROW            ;   .
        BNE     CMOV98          ;   nope
        SWI                     ;force update
        FCB     PUPDAT          ;   .
        CLR     NEWLUK          ;no need for delayed update
;
CMOV92  LDA     P.CCTAT,Y       ;use.attack delay time
CMOV98  LDB     #Q.TEN          ;into the TENTH queue
CMOV99  RTS                     ;that's all folks!!!
;
;  Preferential Random Movement Table
;
MOVTAB  FCB     0               ;forward
        FCB     3               ;left
        FCB     1               ;right
;
        FCB     0               ;forward
        FCB     1               ;right
        FCB     3               ;left
        FCB     0               ;forward



;
;  STEP:  Take a step in the current direction
;
;  Inputs:
;       A - row position
;       B - column position
;       DIR - direction to move
;
;  Returns:
;       A - new position
;       B - new position
;       X - cell address
;
STEP    PSHS    A,B             ;stack row/col
        LDB     DIR             ;load current direction
        ANDB    #%00000011      ;MOD 4
        LSLB                    ;*2 for word offset
        LDX     #STPTAB         ;load base addr
        LDD     B,X             ;load row/col offsets
        ADDA    ,S+             ;offset row
        ADDB    ,S+             ;offset column
        JMP     MAP32           ;calculate cell addr
;
;  Row/Column Modification Table
;
STPTAB  FCB     -1,0            ;north
        FCB     0,1             ;east
        FCB     1,0             ;south
        FCB     0,-1            ;west



;
;  STEPOK: Attempt to Take a Step
;
;  Inputs:
;       A - Row
;       B - Column
;       DIR - direction
;  Returns:
;       A - Possibly Updated Row
;       B - Possibly Updated Column
;       X - Possibly Updated to Cell Addr
;       Z - Condition code set if step is legal
;
STEPOK  PSHS    A,B,X,Y,U       ;save regs
        BSR     STEP            ;take a tentative step
        JSR     BORDER          ;perform border check
        BNE     STOK99          ;   loser - o.b.
;
        TFR     D,U             ;save updated row/col
        LDA     ,X              ;load cell features
        INCA                    ;solid walls ($FF)?
        BEQ     STOK98          ;   yes - loser
;
        STU     ,S              ;update position (2022 n.b. original was 0,S)
        STX     2,S             ;update cell addr
        LDA     #1              ;insure Z-condition code will be set
;
STOK98  DECA                    ;set/reset Z-condition code
STOK99  PULS    A,B,X,Y,U,PC    ;restore regs/exit



;
;  CWALK: Attempt to move creature in desired direction
;
;  Inputs:
;       B - relative change in direction
;       Y - pointer to CCB
;  Returns:
;       P.CCDIR,Y - modified if CWALK wins
;       P.CCROW,Y - modified if CWALK wins
;       P.CCCOL,Y - modified if CWALK wins
;       Z - Condition code set if CWALK wins
;  Destroys:
;       DIR,ROW,COL
;
CWALK   PSHS    A,B,X           ;save some regs
        ADDB    P.CCDIR,Y       ;effect relative change in direction
        ANDB    #3              ;MOD 4
        STB     DIR             ;   .
;
;  Is the next cell occupiable?
;
        LDD     P.CCROW,Y       ;load current position
        BSR     STEPOK          ;take a tentative step
        BNE     CWLK99          ;   loser
;
;  Somebody here already?
;
        JSR     CFIND           ;use updated coordinates
        BNE     CWLK99          ;   occupied cell - loser
;
        STD     P.CCROW,Y       ;update creature position
        LDB     DIR             ;update direction
        STB     P.CCDIR,Y       ;   .
;
;  Need to update screen?
;
        LDD     P.CCROW,Y       ;load position
;
        SUBA    PROW            ;absolute row difference
        BPL     CWLK10          ;   .
        NEGA                    ;   .
CWLK10  SUBB    PCOL            ;absolute column difference
        BPL     CWLK12          ;   .
        NEGB                    ;   .

;
CWLK12  STB     T0              ;store column difference
        CMPA    T0              ;bigger difference into ACCA
        BGE     CWLK20          ;   .
        EXG     A,B             ;   .
;
CWLK20  STA     T0              ;store big difference
        CMPA    #8              ;greater than 8?
        BGT     CWLK92          ;   no update/no sounds
;
        CMPB    #2              ;check little difference
        BGT     CWLK92          ;   no update/no sounds



;
;  Should we make a sound?
;
        SWI                     ;make sounds 50% of the time
        FCB     RANDOM          ;   .
        BITA    #BIT0           ;   .
        BEQ     CWLK90          ;   silence...
;
;  Creatures are louder as they approach
;
        LDA     T0              ;use range to attenuate volume
        LDB     #31             ;   .
        MUL                     ;   .
        COMB                    ;   .
        LDA     P.CCTYP,Y       ;creature type as index
        SWI                     ;   .
        FCB     SOUNDS          ;   .
;
CWLK90  DEC     NEWLUK          ;request screen update
CWLK92  CLRA                    ;winner - set Z-condition code
;
CWLK99  PULS    A,B,X,PC        ;restore regs/go home
;
;;;;;        END
