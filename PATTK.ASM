;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  A T T A C K   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PATTK: Player attack routine
;
;  Command Syntax:
;       ATTACK LEFT             ;attack with object in left hand
;       ATTACK RIGHT            ;attack with object in right hand
;
PATTK   JSR     PARHND          ;select a hand
        LDU     ,U              ;load held object
        BNE     PATT10          ;   something in hand
        LDU     #EMPHND         ;empty hand
;
;  Set Up ATTACK Parameter Blocks
;
PATT10  TFR     U,Y             ;make copy of OCB ptr
        LDA     P.OCMGO,U       ;copy offensive parms to PLRBLK
        STA     PMGO            ;   .
        LDA     P.OCPHO,U       ;   .
        STA     PPHO            ;   .
;
;  Calculate amount of energy expended
        ADDA    PMGO            ;physical + magic offense
        RORA                    ;1/8th of total offensive pct
        LSRA                    ;   .
        LSRA                    ;   .
        LDX     PPOW            ;load current power rating
        JSR     SCAL16          ;   .
        ADDD    PDAM            ;increase damage
        STD     PDAM            ;   .
;
;  Attack Sound Effect Goes Here
;
        LDA     P.OCCLS,U       ;make object sound
        ADDA    #SNDOBJ         ;   .
        LDB     #$FF            ;loud
        SWI                     ;   .
        FCB     SOUNDS          ;   .
;
;  Decrement Ring Usage Counters
;
        LDA     P.OCTYP,U       ;player using incantable ring?
        CMPA    #T.RN11         ;   .
        BLT     PATT20          ;   loser
        CMPA    #T.RN12         ;   .
        BGT     PATT20          ;   loser
;
        DEC     P.OCXXX,U       ;decrement usage counter
        BNE     PATT20          ;   charges still left
        LDA     #T.RN20         ;gold ring (useless)
        STA     P.OCTYP,U       ;change used rings into gold
        JSR     PREV00          ;   .



;
;  Is there something to attack?
;
PATT20  LDD     PROW            ;is there a creature here?
        JSR     CFIND           ;   .
        BEQ     PATT99          ;   nope
;
;  Attempt to hit creature
;
        LDU     #PLRBLK         ;player is attacker
        EXG     X,U             ;creature is the defender
;
        LDA     P.OCCLS,Y       ;check for a ring
        CMPA    #K.RING         ;   .
        BEQ     PATT24          ;   rings are guaranteed to hit
;
        JSR     ATTACK          ;swing at the creature
        BMI     PATT99          ;   big miss
;
;  Potentially hit creature - how dark is it?
;
        LDY     PTORCH          ;using a torch?
        BEQ     PATT22          ;   nope
        LDA     P.OCTYP,Y       ;what kind of torch...
        CMPA    #T.TOR5         ;dead?
        BNE     PATT24          ;   nope
PATT22  SWI                     ;only 25% of normal percentage
        FCB     RANDOM          ;   .
        ANDA    #3              ;   (use the two LSBits)
        BNE     PATT99          ;   sorry - darkness prevails
;
;  We hit the creature!
;
PATT24
        SWI
        FCB     ISOUND
        FCB     A$KLK2          ;KLINK!!!
		jsr putstrimm			; display "!!!" for a hit
		fcn '!!!'
;
        JSR     DAMAGE          ;take a chunk out of him
        BHI     PATT99          ;   still alive



;
;  DEAD Creature!  Drop all objects to the floor
;
PATT30  LEAX    P.CCOBJ,U       ;load initial object ptr
PATT32  LDX     P.OCPTR,X       ;advance to next object
        BEQ     PATT40          ;   done
        CLR     P.OCOWN,X       ;mark object unowned
        LDD     P.CCROW,U       ;drop objects where creature stands
        STD     P.OCROW,X       ;mark new position
        BRA     PATT32          ;do next object
;
;  Decrement proper entry in CMXLND
;
PATT40  LDX     CMXPTR          ;creature matrix pointer
        LDB     P.CCTYP,U       ;load creature type
        DEC     B,X             ;decrement table entry
        CLR     P.CCUSE,U       ;mark creature as dead
        SWI                     ;update the screen
        FCB     PUPDAT          ;   .
;
;        SOUND$  A$EXP0          ;loud explosion!
;
        SWI                     ;loud explosion!
        FCB     ISOUND          ;   .
        FCB     A$EXP0          ;   .
;
;  Absorb "life-energy" of creature
;
        LDD     P.CCPOW,U       ;increase PPOW by 1/8th of creature
        BSR     ASRD3           ;   .
        ADDD    PPOW            ;add to our power level
        BPL     PATT42          ;   power within limits
        LDA     #$7F            ;peg power at approximately 32K
PATT42  STD     PPOW            ;update player power
;
;  Check for Fake Wizard (Plain)
;
        LDA     P.CCTYP,U       ;plain wizard?
        CMPA    #10             ;   .
        BEQ     ENDGAM          ;   nope
;
;  Check for Evil Wizard (Crescent)
;
        CMPA    #11             ;evil wizard?
        BNE     PATT99          ;   nope



;
;  Perform Special Ring Riddle Code
        DEC     FRZFLG          ;stop all creature activity
        LDD     #$0713          ;set lighting levels
        STD     PRLITE          ;   .
        LDX     #OCBLND+OC.LEN  ;single object (OMEGA ring)
        STX     OCBPTR          ;   .
        LDD     BIGZER          ;zero all ptrs
        STD     BAGPTR          ;nothing in bag
        STD     PTORCH          ;no torch
        STD     PRHAND          ;nothing in hands
        STD     PLHAND          ;   .
        SWI                     ;update the screen
        FCB     INIVU           ;   .
PATT99  SWI                     ;update the heartrate
        FCB     HUPDAT          ;   .



;  ASRDn: 16-bit Arithmetic Shift Right
;
ASRD7   ASRA
        RORB
ASRD6   ASRA
        RORB
ASRD5   ASRA
        RORB
ASRD4   ASRA
        RORB
ASRD3   ASRA
        RORB
ASRD2   ASRA
        RORB
ASRD    ASRA
        RORB
        RTS



ENDGAM  LDX     #WIZ1           ;fade in crescent wizzard
        SWI                     ;   (clear the status line)
        FCB     WIZIN           ;   .
;
		jsr putstrimm			; display the angry message after level 3
		fcn '\r ENOUGH! I TIRE OF THIS PLAY...   PREPARE TO MEET THY DOOM!!!'
        SWI                     ;take your time...
        FCB     WAIT            ;   .



;
;  Strip player of everything/save PLHAND, PRHAND, PTORCH
;
        LDU     PTORCH          ;torch is the only object left in the bag
        STU     BAGPTR          ;   .
        BEQ     EGAM10          ;   no torch even!
        CLRA                    ;terminate object list
        CLRB                    ;   .
        STD     P.OCPTR,U       ;   .
;
EGAM10  LDD     #200            ;set penalty weight
        STD     POBJWT          ;   .
;
;  Create Endgame Upper Level
;
        LDA     #3              ;endgame upper level
        SWI                     ;   .
        FCB     NEWLVL          ;   .
        JSR     FNDCEL          ;a new position for the player
        STD     PROW            ;   .
;
        SWI                     ;now fade the wizzard out
        FCB     WIZOUT          ;   .
        SWI                     ;display initial screen
        FCB     INIVU           ;   .
        RTS                     ;bye



;
;  ATTACK: Combat Resolution Routine
;
;  Inputs:
;       X - Attacker Attack Block
;       U - Defender Attack Block
;  Returns:
;       N - condition code set if attack fails
;
ATTACK  PSHS    A,B,X,U         ;save regs
        LDA     #15             ;set percentage index
        STA     T0              ;   .
;
;  Calculate Defender/Attacker Percentage Index (steps of 25%)
        LDD     P.ATPOW,U       ;defender power
        SUBD    P.ATDAM,U       ;minus defender damage
        JSR     LSLD2           ;times 4
;
ATTK10  SUBD    P.ATPOW,X       ;multiple subtractions
        BCS     ATTK20          ;   finally minus
        DEC     T0              ;decrement index
        BNE     ATTK10          ;   loop until zero
;
;  Use Index to Calculate Reward/Penalty Percentage
;
ATTK20  LDB     T0              ;load percentage index
        SUBB    #3              ;offset index
        BPL     ATTK22          ;   reward anything above 100%
;
        NEGB                    ;penalize anything below 75%
        LDA     #25             ;   .
        MUL                     ;   .
        JSR     NEGD            ;   .
        BRA     ATTK30          ;   .
;
ATTK22  LDA     #10             ;reap the rewards
        MUL                     ;   .
;
ATTK30  STD     ,--S            ;stack reward/penalty
        SWI                     ;create 16-bit random number (0:255)
        FCB     RANDOM          ;   .
        TFR     A,B             ;   .
        CLRA                    ;   .
        ADDD    ,S++            ;calculate weighted percentage
        SUBD    #127            ;did we hit him?
ATTK99  PULS    A,B,X,U,PC      ;restore regs/exit
;
;  DAMAGE: Process Damage Done
;
;  Inputs:
;       X - Attacker ATB ptr
;       U - Defender ATB ptr
;  Returns:
;       N - condition code set if defender died
;
DAMAGE  PSHS    A,B,X,Y,U       ;save regs
        TFR     X,Y             ;copy attacker ATB ptr
;
;  Calculate Magical Damage
;
        LDX     P.ATPOW,Y       ;channel power thru magic offense pct
        LDA     P.ATMGO,Y       ;   .
        BSR     SCAL16          ;   .
        TFR     D,X             ;filter damage thru magic defense pct
        LDA     P.ATMGD,U       ;   .
        BSR     SCAL16          ;   .
        ADDD    P.ATDAM,U       ;accumulate defender damage
        STD     P.ATDAM,U       ;   .
;
;  Calculate Magical Damage
;
        LDX     P.ATPOW,Y       ;channel power thru physical offense pct
        LDA     P.ATPHO,Y       ;   .
        BSR     SCAL16          ;   .
        TFR     D,X             ;filter damage thru physical defense pct
        LDA     P.ATPHD,U       ;   .
        BSR     SCAL16          ;   .
        ADDD    P.ATDAM,U       ;accumulate defender damage
        STD     P.ATDAM,U       ;   .
;
        LDX     P.ATPOW,U       ;compare power vs damage
        CMPX    P.ATDAM,U       ;   .
        PULS    A,B,X,Y,U,PC    ;restore regs/exit



;
;  SCAL16: Multiply 16-bit number by RADIX-7 value
;
;  Inputs:
;       X - 16-bit unsigned number
;       A - RADIX-7 value
;  Returns:
;       D - 16-bit unsigned result
;
SCAL16  PSHS    A,B,X           ;save regs
        CLR     T0              ;reset MSByte of result
        LDB     3,S             ;LSByte of 16-bit number
        MUL                     ;multiply by RADIX-7 value
        STD     T1              ;T1:carry, T2:LSByte of result
;
        LDA     ,S              ;load RADIX-7 value (2022 n.b. original was 0,S)
        LDB     2,S             ;load MSByte of 16-bit number
        MUL                     ;multiply
        ADDD    T0              ;add carry portion
;
        LSL     T2              ;MSBit of LSByte into carry
        ROLB                    ;shift carry into final result
        ROLA                    ;   .
        STD     ,S              ;return as parm (2022 n.b. original was 0,S)
        PULS    A,B,X,PC        ;restore regs/exit
;
;;;;;        END
