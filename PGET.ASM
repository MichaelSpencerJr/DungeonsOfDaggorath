;!!!!!!!!!!!!!!!!!!!!!!!!!
;  G E T   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     PGET
;     LIBRY  CD
;        XDEF    PGET,PDROP,PSTOW,PSTOW0,PPULL
;
;        XREF    PARHND,PAROBJ,CMDERR,OFIND,OBJWGT
;        PSCT
;
;
;
;  PGET: Grab an object with either hand
;
;  Command Syntax:
;       GET LEFT <generic>
;       GET LEFT <specific>
;       GET RIGHT <generic>
;       GET RIGHT <specific>
;
PGET    BSR     HNDPAR          ;determine left/right hand
        BNE     ERRCMD1         ;   something already in hand!
;
;  Search the cell for the object
;
PGET10  JSR     PAROBJ          ;determine generic/specific object
        CLR     OFINDF          ;start search from the beginning
PGET20  LDD     PROW            ;position
        JSR     OFIND           ;get the next object
        BEQ     ERRCMD1         ;   can't find the object
;
        TST     SPEFLG          ;generic/specific?
        BNE     PGET22          ;   specific
;
        LDA     P.OCCLS,X       ;perform generic compare
        CMPA    OBJCLS          ;   .
        BRA     PGET24          ;   .
;
PGET22  LDA     P.OCTYP,X       ;perform specific compare
        CMPA    OBJTYP          ;   .
PGET24  BNE     PGET20          ;   loop if failure
;
;  Place the object into the correct hand
;
PGET30  STX     ,U              ;store object ptr into correct hand
        INC     P.OCOWN,X       ;mark object as owned
        LDB     P.OCCLS,X       ;accumulate weight
        LDX     #OBJWGT         ;   .
        LDB     B,X             ;   .
        CLRA                    ;16-bit value/fall into WUPDAT
        BRA     WUPDAT          ;   .
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D R O P   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PDROP: Drop an object
;
;  Command Syntax:
;       DROP LEFT               ;drop object in left hand
;       DROP RIGHT              ;drop object in right hand
;
PDROP   BSR     HNDPAR          ;left/right hand
        BEQ     ERRCMD1         ;   empty hand!
;
        CLRA                    ;mark hand empty
        CLRB                    ;   .
        STD     ,U              ;   .
        CLR     P.OCOWN,X       ;mark object unowned
        LDD     PROW            ;load our position
        STD     P.OCROW,X       ;store as object position
        LDA     LEVEL           ;store the current level
        STA     P.OCLVL,X       ;   .
;
;  Decrease Player Weight
;
        LDB     P.OCCLS,X       ;load generic class
        LDX     #OBJWGT         ;table base addr
        LDB     B,X             ;load weight value
        NEGB                    ;negate weight (16-bit value)
        SEX                     ;   .
;
;  WUPDAT: Common Player Weight Modification Routine
;
;  Used by PGET,PDROP
;
WUPDAT  ADDD    POBJWT          ;effect relative change
        STD     POBJWT          ;update player weight
        SWI                     ;update the heartrate
        FCB     HUPDAT          ;   .
        BRA     COMUPD          ;update status line/display
;
;  Local Jumps
;
ERRCMD1 JMP     CMDERR          ;flag errors
HNDPAR  JMP     PARHND          ;dispatch to hand parse routine



;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S T O W   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PSTOW: Put an object into our bag
;
;  Command Syntax:
;       STOW LEFT
;       STOW RIGHT
;
PSTOW   BSR     HNDPAR          ;determine left/right hand
        BEQ     ERRCMD1         ;   empty hand!
;
PSTOW0  LDD     BAGPTR          ;insert object into bag list
        STD     P.OCPTR,X       ;   .
        STX     BAGPTR          ;   .
;
        CLRA                    ;zap hand pointer
        CLRB                    ;   .
        STD     ,U              ;   .
        BRA     COMUPD          ;update status line/display
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  P U L L   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PPULL: Take an object from our bag
;
;  Command Syntax:
;       PULL LEFT <generic>
;       PULL LEFT <specific>
;       PULL RIGHT <generic>
;       PULL RIGHT <specific>
;
PPULL   BSR     HNDPAR          ;determine left/right hand
        BNE     ERRCMD1         ;   non-empty hand
        JSR     PAROBJ          ;determine generic/specific name
;
;  Attempt to find object in BAG
;
        LDX     #BAGPTR         ;starting point of the loop
PULL10  TFR     X,Y             ;save current link ptr
        LDX     ,X              ;advance link ptr
        BEQ     ERRCMD1         ;   search failure
        TST     SPEFLG          ;generic/specific?
        BNE     PULL12          ;   specific
;
        LDA     P.OCCLS,X       ;perform generic compare
        CMPA    OBJCLS          ;   .
        BRA     PULL14          ;   .
;
PULL12  LDA     P.OCTYP,X       ;perform specific compare
        CMPA    OBJTYP          ;   .
PULL14  BNE     PULL10          ;   loop if failure
;
;  Place the Object into the Correct Hand
;
        LDD     P.OCPTR,X       ;remove object from bag list
        STD     ,Y              ;   .
        STX     ,U              ;store object into correct hand
;
        CLRA                    ;clear ACCA, ACCB
        CLRB                    ;   .
        CMPX    PTORCH          ;using this object as a torch?
        BNE     COMUPD          ;   nope
        STD     PTORCH          ;no longer using this torch
;
COMUPD  SWI                     ;update status line
        FCB     STATUS          ;   .
        SWI                     ;update main display
        FCB     PUPDAT          ;   .
        RTS                     ;bye
;
;;;;;        END
