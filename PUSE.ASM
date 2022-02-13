;!!!!!!!!!!!!!!!!!!!!!!!!!
;  U S E   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PUSE: Activate an Object
;
;  Command Syntax:
;       USE LEFT
;       USE RIGHT
;
PUSE    JSR     PARHND          ;parse for an object
        BEQ     PUSE24          ;   empty hand
;
;  Dispatch to proper routine
;
        LDD     P.OCTYP,X       ;load the object type/class
;
PUSE10  CMPB    #K.TORC         ;torch?
        BNE     PUSE20          ;   nope
        STX     PTORCH          ;light torch
PUSE12  JSR     PSTOW0          ;stow object
;
;        SOUND$  A$TORC          ;make loud torch sound
;
        SWI                     ;   .
        FCB     ISOUND          ;   .
        FCB     A$TORC          ;   .
        SWI                     ;update the screen
        FCB     PUPDAT          ;   .
        RTS                     ;bye
;
;  Check for specific objects
;
PUSE20  TFR     X,U             ;copy OCB ptr
        LDX     #USETAB         ;dispatch table addr
PUSE22  CMPA    ,X              ;match?
        BEQ     PUSE30          ;   yes
        LEAX    3,X             ;advance to next entry
        CMPX    #USEEND         ;exhausted table?
        BLO     PUSE22          ;   nope
PUSE24  RTS                     ;loser!
;
PUSE30  JMP     [1,X]           ;dispatch to proper routine/exit



;
;  Macro To Define Specific Object Dispatch Table Entries
;
USM     MACR
        FCB     \1
        FDB     \2
        ENDM
;
USETAB  EQU     *               ;beginning of table
        FCB     T.FLA1          ;avatar flask (strength)
        FDB     UFL100
        FCB     T.FLA2          ;soma flask (healing)
        FDB     UFL200
        FCB     T.FLA3          ;gift flask (poison)
        FDB     UFL300
;
        FCB     T.SCR1          ;seer scroll (map w/all)
        FDB     USC200
        FCB     T.SCR2          ;vision scroll (plain)
        FDB     USC100
;
USEEND  EQU     *



;
;  Avatar Flask (Strength)
;
UFL100  LDD     #1000           ;increase power by 1000 pts
        ADDD    PPOW            ;   .
        STD     PPOW            ;   .
        BRA     UFL900          ;   .
;
;  Soma Flask (Healing)
;
UFL200  CLRA                    ;heal all damage
        CLRB                    ;   .
        BRA     UFL310          ;   .
;
;  Solanum Flask (Poison)
;
UFL300  LDX     PPOW            ;cause 80% damage
        LDA     #102            ;   .
        JSR     SCAL16          ;   .
        ADDD    PDAM            ;   .
UFL310  STD     PDAM            ;   .
;
;UFL900  LDB     #T.FLA4         ;now empty the flask
UFL900  LDB     #T.TOR5-1         ;now empty the flask FIXME
        STB     P.OCTYP,U       ;   .
        CLR     P.OCREV,U       ;empty flasks are always revealed
        SWI
        FCB     ISOUND
        FCB     A$FLAS          ;make flask sound
        SWI                     ;update the status line
        FCB     STATUS          ;   .
        SWI                     ;update the heartrate
        FCB     HUPDAT          ;   .
        RTS                     ;done
;
;  Vision Scroll
;
USC100  CLRA                    ;map w/o features
        FCB     SKIP2           ;   .
;
;  Seer Scroll
;
DEBMAP  EQU     *               ;debugging command
USC200  LDA     #$FF            ;map with the features
        STA     MAPFLG          ;set the flag
        TST     P.OCREV,U       ;has this object been revealed?
        BNE     USC199          ;   nope!
;
;        SOUND$  A$SCRO          ;make scroll sound
        SWI                     ;   .
        FCB     ISOUND          ;   .
        FCB     A$SCRO          ;   .
USC210  CLR     HEARTF          ;turn off the heart
        LDX     #MAPPER         ;set map display mode
        STX     DSPMOD          ;   .
        SWI                     ;update the screen



        FCB     PUPDAT          ;   .
USC199  RTS                     ;done
;
;;;;;        END
