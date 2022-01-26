;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C L I M B   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PCLIMB: Climb Up/Down Ladders
;
;  Command Syntax:
;       CLIMB                   ;climb up a ladder
;       CLIMB UP                ;   .
;       CLIMB DOWN              ;climb down
;
PCLIMB  LDD     PROW            ;our position
        JSR     VFIND           ;what kind of vertical feature?
        BMI     PCLI00          ;   no features
        STA     T0              ;save vertical features on stack
;
        LDX     #DIRTAB         ;directions
        JSR     PARSER          ;get the next token
        BLE     PCLI00          ;   null/illegal token
;
        LDB     T0              ;retrieve vertical feature code
        CMPA    #T.UP           ;climb up
        BEQ     PCLI10          ;   .
        CMPA    #T.DN           ;climb down
        BNE     PCLI00          ;   .
;
;  Go Down a level
;
        LDA     #1              ;assume we are going down
        BITB    #BIT1           ;downward vertical feature?
        BNE     PCLI20          ;   yes
PCLI00  JMP     CMDERR          ;can't go down!
;
;  Go Up a Level
;
PCLI10  LDA     #-1             ;assume we are going up
        CMPB    #VF.LUP         ;ladder up?
        BNE     PCLI00          ;   nope - no way up
;
;  Process Level Change
;
PCLI20  SWI                     ;dispay prepare message
        FCB     PREPAR          ;   .
        ADDA    LEVEL           ;change the level
        SWI                     ;create a new dungeon level
        FCB     NEWLVL          ;   .
        SWI                     ;print current screen
        FCB     INIVU           ;   .
        RTS                     ;bye
;
;;;;;        END
