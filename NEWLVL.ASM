;        TTL NEWLVL - Create a New Dungeon Level
;
;  NEWLVX: Create a New Dungeon Level
;
;  Inputs:
;       A - level to be created
;
NEWLVX  EQU     *
;
;  Calculate a new creature matrix index
;
        STA     LEVEL           ;store the level number
        LDB     #CTYPES         ;number of creatures
        MUL                     ;   .
        ADDD    #CMXLND         ;   .
        STD     CMXPTR          ;   .
;
;  Calculate Vertical Features Index
;
        LDB     LEVEL           ;load the level number
        LDX     #VFTTAB         ;table base addr
NLVL10  STX     VFTPTR          ;assume this is correct
NLVL12  LDA     ,X+             ;search for negative
        BPL     NLVL12          ;   .
        DECB                    ;done?
        BPL     NLVL10          ;   nope
;
;  Armagedon!
;
        LDX     #CCBLND         ;table base addr
        LDU     #CCBEND         ;ending addr
        SWI                     ;clear the entire CCB table
        FCB     ZERO            ;   .
;
;  Create a new world...
;
        JSR     SYSTCB          ;creat new system TCBs
        JSR     DGNGEN          ;create the new level
;
;  Give this new world LIFE...
;
        LDU     CMXPTR          ;load CMXLND index
		ldb #32				; maximum number of creatures to make
		pshs b				; save for later
        LDA     #CTYPES-1       ;start with most ferocious creatures
NLVL30  LDB     A,U             ;number of this type of creature
        BEQ     NLVL34          ;   done
NLVL32  JSR     CBIRTH          ;give birth to a creature
		dec ,s				; created maximum number of creatures?
		beq NLVL36			; brif max created
        DECB                    ;one less creature to create
        BNE     NLVL32          ;   until we are done
NLVL34  DECA                    ;advance to next creature type
        BPL     NLVL30          ;   until done



;
;  Randomly Attach Creature-Owned Objects
;
NLVL36		leas 1,s			; clean up stack
        LDU     #CCBLND-CC.LEN  ;land of creatures
        CLR     OFINDF          ;start at top of object list
NLVL40  JSR     FNDOBJ          ;find the next object on our level
        BEQ     NLVL50          ;   exhausted objects
        TST     P.OCOWN,X       ;is this object creature owned
        BPL     NLVL40          ;   nope
;
;  Find the next creature
;
NLVL42  LEAU    CC.LEN,U        ;find a creature
        CMPU    #CCBEND         ;exhausted table
        BLO     NLVL44          ;   nope
        LDU     #CCBLND         ;start at top
;
NLVL44  TST     P.CCUSE,U       ;this creature alive?
        BEQ     NLVL42          ;   nope
;
;  Attach Object to Creature
;
        LDD     P.CCOBJ,U       ;load creature object ptr
        STX     P.CCOBJ,U       ;insert object
        STD     P.OCPTR,X       ;   .
        BRA     NLVL40          ;up top for another
;
;  Determine VDGINV Setting
;
NLVL50  LDA     LEVEL           ;load the level number
        ANDA    #BIT0           ;determine even/odd (0/1)
        NEGA                    ;convert to mask ($00/$FF)
        STA     VDGINV          ;set the inverse byte
        STA     P.TXINV+TXTPRI  ;update the primary TXB inverse flag
        STA     P.TXINV+TXTEXA  ;update examine TXB inverse flag
        COMA                    ;invert the "inverse" flag
        STA     P.TXINV+TXTSTS  ;update the status TXB inverse flag
;
        RTS                     ;done
;;;;;        END
