;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T U R N   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PTURN: Change the Player Direction
;
;  Command Syntax:
;       TURN LEFT               ;left-hand 90-degree turn
;       TURN RIGHT              ;right-hand 90-degree turn
;       TURN AROUND             ;180-degree turn
;
PTURN   LDX     #DIRTAB         ;direction names
        JSR     PARSER          ;get the second token
        BLE     ERRCMD2         ;   null/illegal token
        LDB     PDIR            ;load current facing direction
;
;  Check for left turn
;
        CMPA    #T.LT           ;left turn?
        BNE     PTUR10          ;   nope
        DECB                    ;change directions
        BSR     PREVU           ;create next display
        BSR     LRTURN          ;display left-to-right turn
        BRA     PTUR90          ;   .
;
;  Check for right turn
;
PTUR10  CMPA    #T.RT           ;right turn?
        BNE     PTUR20          ;   nope
        INCB                    ;change directions
        BSR     PREVU           ;create next display
        BRA     PTUR22          ;display right-to-left turn
;
;  Check for about-face
;
PTUR20  CMPA    #T.AROU         ;turn around?
        BNE     ERRCMD2         ;   loser2!
        ADDB    #2              ;change directions
        BSR     PREVU           ;create next display
        BSR     RLTURN          ;round and round
PTUR22  BSR     RLTURN          ;   .
;
;  Show the next display
;
PTUR90  DEC     UPDATE          ;request screen update
        SYNC                    ;   .
        RTS



;
;  PREVU: Generate the next display in FLOP
;
PREVU   ANDB    #3              ;directions are MOD 4
        STB     PDIR            ;   .
        JMP     PUPSUB          ;generate display without update
;
;  LRTURN: Display Left-to-Right Turn Sequence
LRTURN  EQU     *               ;--- start of procedure LRTURN
        BSR     TURN00          ;do initialization
        BNE     LRTU99          ;   not looking forward
;
        LDD     #8              ;start from left side
LRTU10  BSR     TURN10          ;draw/erase line
        ADDD    #32             ;move toward the right
        TSTA                    ;done yet?
        BEQ     LRTU10          ;   nope
LRTU99  RTS                     ;--- end of procedure LRTURN
;
;  RLTURN: Display Right-to-Left Sequence
;
RLTURN  EQU     *               ;--- start of procedure RLTURN
        BSR     TURN00          ;do initialization
        BNE     RLTU99          ;   not looking forward
;
        LDD     #248            ;start from right side
RLTU10  BSR     TURN10          ;draw/erase the line
        SUBD    #32             ;move toward left
        BPL     RLTU10          ;   .
RLTU99  RTS                     ;--- end of procedure RLTURN
;
;  Local Jumps
;
ERRCMD2 JMP     CMDERR          ;flag errors
;
;  TURN00: Initialization
;
TURN00  LDU     DSPMOD          ;are we in forward viewing mode?
        CMPU    #VIEWER         ;   .
        BNE     TURN02          ;   nope - don't do anything
;
        LDX     #$8080          ;manually set scaling
        STX     VXSCAL          ;   .
        CLR     RANGE           ;set the range
        SWI                     ;set the amount of fading
        FCB     SETFAD          ;   .
;
        SWI                     ;erase the CURRENT screen
        FCB     ZFLIP           ;   .
        LDX     #LINES          ;draw horizontal lines
        SWI                     ;   .
        FCB     VCTLST          ;   .
;
        LDX     #17             ;set Y-coordinates
        STX     Y0              ;   .



        LDX     #135            ;   .
        STX     Y1              ;   .
;
        CLRA                    ;successful return
TURN02  RTS                     ;bye
;
;  TURN10:  Draw/Erase a line
;
TURN10  STD     X0              ;store x-coordinates
        STD     X1              ;   .
        BSR     TURN12          ;draw the line
TURN12  JSR     VECTOR          ;then erase it
        COM     VDGINV          ;   .
        RTS                     ;   .
;
;  LINES: Horizontal Lines
;
LINES   FCB     16,0
        FCB     16,255
        FCB     V$NEW
;
        FCB     136,0
        FCB     136,255
        FCB     V$END
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  M O V E   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PMOVE: Player Movement
;
;  Command Syntax:
;       MOVE                    ;move forward
;       MOVE BACKWARD           ;take a step backward
;       MOVE LEFT               ;sidestep left
;       MOVE RIGHT              ;sidestep right
;
PMOVE   LDX     #DIRTAB         ;direction names
        JSR     PARSER          ;get the second token
        BLT     ERRCMD2         ;   illegal token
        BGT     PMOV20          ;   legal token
;
;  Move Forward
;
        DEC     HLFSTP          ;request half-step view
        SWI                     ;   .
        FCB     PUPDAT          ;   .
        CLRB                    ;step forward
        CLR     HLFSTP          ;   .
        BRA     PMOV22          ;   .
;
;  Move Backward
;
PMOV20  CMPA    #T.BAK          ;backward
        BNE     PMOV30          ;   .
        DEC     BAKSTP          ;flag for back half-step
        SWI                     ;update the screen
        FCB     PUPDAT          ;   .
        LDB     #2              ;step backward
        CLR     BAKSTP          ;   .
PMOV22  BSR     PSTEP           ;   .
        BRA     PMOV90          ;   .
;
;  Move Left/Right
;
PMOV30  CMPA    #T.RT           ;sidestep right?
        BNE     PMOV40          ;   nope
        LDB     #1              ;take a step right
        BSR     PSTEP           ;   .
        BNE     PMOV90          ;   we couldn't move
        BSR     RLTURN          ;right-to-left line
        BRA     PMOV90          ;   .
;
PMOV40  CMPA    #T.LT           ;sidestep left?
        BNE     ERRCMD2         ;   nope - error
        LDB     #3              ;take a step left
        BSR     PSTEP           ;   .
        BNE     PMOV90          ;   we couldn't move
        JSR     LRTURN          ;left-to-right line



;
;  Determine energy requirements
;
PMOV90  LDD     POBJWT          ;(weight / 8) + 3
        JSR     ASRD3           ;divide by 8
        ADDD    #3              ;   .
        ADDD    PDAM            ;accumulate as damage
        STD     PDAM            ;   .
        SWI                     ;   .
        FCB     HUPDAT          ;   .
        DEC     UPDATE          ;request screen switch
        SYNC                    ;wait for it to happen
        RTS                     ;   .



;
;  PSTEP: Move the Player
;
;  Inputs:
;       B - relative change in direction
;  Returns:
;       PROW - updated
;       PCOL - updated
;
PSTEP   PSHS    A,B             ;save some regs
        CLR     ,-S             ;assume we will win
;
        ADDB    PDIR            ;effect relative change
        ANDB    #3              ;MOD 4
        STB     DIR             ;save direction
        LDD     PROW            ;player position
        JSR     STEPOK          ;can we legally move?
        BEQ     PSTP10          ;   yes
;
;  We can't move!
;
;
;        SOUND$  A$THUD          ;THUD!!!
;
        SWI                     ;   .
        FCB     ISOUND          ;   .
        FCB     A$THUD          ;   .
        DEC     ,S              ;loser (2022 n.b. original was 0,S)
        LDD     PROW            ;restore original position
;
PSTP10  STD     PROW            ;update position
        JSR     PUPSUB          ;create image in backplane
;
PSTP99  TST     ,S+             ;set condition codes
        PULS    A,B,PC          ;restore regs/exit
;
;;;;;        END
