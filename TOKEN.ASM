;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T O K E N   T A B L E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     TOKEN
;        XDEF    CMDTAB,DIRTAB,GENTAB,ADJTAB,AUTTAB,AUTEND
;        PSCT
;
;  Are we debugging?
;
        IFNDEF  DEBFLG
DEBFLG  EQU     0
        ENDC

;
;  CMDTAB: Primary Command Tokens
;
CMDTAB  FCB     CMDNUM          ;number of entries
FOO     SET     0

XDEF    MACR
\1      EQU     FOO
FOO     SET     FOO+1
\2      EQU     *
        ENDM

;
        XDEF    T.ATTK,M$ATTK
        FCB     %00110000       ;ATTACK
        FCB     %00000011       ;ATTACK
        FCB     %01001010       ;ATTACK
        FCB     %00000100       ;ATTACK
        FCB     %01101011       ;ATTACK
;
        XDEF    T.CLIM,M$CLIM
        FCB     %00101000       ;CLIMB
        FCB     %00000110       ;CLIMB
        FCB     %11000100       ;CLIMB
        FCB     %10110100       ;CLIMB
        FCB     %01000000       ;CLIMB
;
        XDEF    T.DROP,M$DROP
        FCB     %00100000       ;DROP
        FCB     %00001001       ;DROP
        FCB     %00100111       ;DROP
        FCB     %11000000       ;DROP
;
        XDEF    T.EXAM,M$EXAM
        FCB     %00111000       ;EXAMINE
        FCB     %00001011       ;EXAMINE
        FCB     %10000000       ;EXAMINE
        FCB     %10110101       ;EXAMINE
        FCB     %00101110       ;EXAMINE
        FCB     %00101000       ;EXAMINE
;
        XDEF    T.GET,M$GET
        FCB     %00011000       ;GET
        FCB     %00001110       ;GET
        FCB     %01011010       ;GET
        FCB     %00000000       ;GET
;



;
        XDEF    T.INCN,M$INCN
        FCB     %00110000       ;INCANT
        FCB     %00010010       ;INCANT
        FCB     %11100001       ;INCANT
        FCB     %10000101       ;INCANT
        FCB     %11010100       ;INCANT
;
        XDEF    T.LOOK,M$LOOK
        FCB     %00100000       ;LOOK
        FCB     %00011000       ;LOOK
        FCB     %11110111       ;LOOK
        FCB     %10101100       ;LOOK
;
        XDEF    T.MOVE,M$MOVE
        FCB     %00100000       ;MOVE
        FCB     %00011010       ;MOVE
        FCB     %11111011       ;MOVE
        FCB     %00010100       ;MOVE
;
        XDEF    T.PULL,M$PULL
        FCB     %00100000       ;PULL
        FCB     %00100001       ;PULL
        FCB     %01010110       ;PULL
        FCB     %00110000       ;PULL
;
        XDEF    T.REVE,M$REVE
        FCB     %00110000       ;REVEAL
        FCB     %00100100       ;REVEAL
        FCB     %01011011       ;REVEAL
        FCB     %00010100       ;REVEAL
        FCB     %00101100       ;REVEAL
;
        XDEF    T.STOW,M$STOW
        FCB     %00100000       ;STOW
        FCB     %00100111       ;STOW
        FCB     %01000111       ;STOW
        FCB     %11011100       ;STOW



        XDEF    T.TURN,M$TURN
        FCB     %00100000       ;TURN
        FCB     %00101001       ;TURN
        FCB     %01011001       ;TURN
        FCB     %00111000       ;TURN
;        
        XDEF    T.USE,M$USE
        FCB     %00011000       ;USE
        FCB     %00101011       ;USE
        FCB     %00110010       ;USE
        FCB     %10000000       ;USE
;        
        XDEF    T.ZLOA,M$ZLOA
        FCB     %00101000       ;ZLOAD
        FCB     %00110100       ;ZLOAD
        FCB     %11000111       ;ZLOAD
        FCB     %10000100       ;ZLOAD
        FCB     %10000000       ;ZLOAD
;
        XDEF    T.ZSAV,M$ZSAV
        FCB     %00101000       ;ZSAVE
        FCB     %00110101       ;ZSAVE
        FCB     %00110000       ;ZSAVE
        FCB     %11011000       ;ZSAVE
        FCB     %10100000       ;ZSAVE



;
;  Debugging Commands
;
        IF      DEBFLG
;
        XDEF    T.QMAP,M$QMAP
        FCB     %00100000       ;QMAP
        FCB     %00100010       ;QMAP
        FCB     %11010000       ;QMAP
        FCB     %11000000       ;QMAP
;
        XDEF    T.QUP,M$QUP
        FCB     %00011000       ;QUP
        FCB     %00100011       ;QUP
        FCB     %01011000       ;QUP
        FCB     %00000000       ;QUP
;
        XDEF    T.QDN,M$QDN
        FCB     %00011000       ;QDN
        FCB     %00100010       ;QDN
        FCB     %01000111       ;QDN
        FCB     %00000000       ;QDN
;
        XDEF    T.QRUP,M$QRUP
        FCB     %00100000       ;QRUP
        FCB     %00100011       ;QRUP
        FCB     %00101010       ;QRUP
        FCB     %11000000       ;QRUP
;
        XDEF    T.QRDN,M$QRDN
        FCB     %00100000       ;QRDN
        FCB     %00100011       ;QRDN
        FCB     %00100010       ;QRDN
        FCB     %00111000       ;QRDN
;
        XDEF    T.QMUP,M$QMUP
        FCB     %00100000       ;QMUP
        FCB     %00100010       ;QMUP
        FCB     %11011010       ;QMUP
        FCB     %11000000       ;QMUP
;
        
        
        
        XDEF    T.QMDN,M$QMDN
        FCB     %00100000       ;QMDN
        FCB     %00100010       ;QMDN
        FCB     %11010010       ;QMDN
        FCB     %00111000       ;QMDN
;
        ENDIF                   ; DEBFLG  (end of debug command table.)
;
;
CMDNUM  EQU     FOO             ;number of entries



;
;  DIRTAB: Direction Token Tables
;
DIRTAB  FCB     DIRNUM
FOO     SET     0
;
        XDEF    T.LT,M$LT
        FCB     %00100000       ;LEFT
        FCB     %00011000       ;LEFT
        FCB     %01010011       ;LEFT
        FCB     %01010000       ;LEFT
;
        XDEF    T.RT,M$RT
        FCB     %00101000       ;RIGHT
        FCB     %00100100       ;RIGHT
        FCB     %10010011       ;RIGHT
        FCB     %10100010       ;RIGHT
        FCB     %10000000       ;RIGHT
;
        XDEF    T.BAK,M$BAK
        FCB     %00100000       ;BACK
        FCB     %00000100       ;BACK
        FCB     %00010001       ;BACK
        FCB     %10101100       ;BACK
;



        XDEF    T.AROU,M$AROU
        FCB     %00110000       ;AROUND
        FCB     %00000011       ;AROUND
        FCB     %00100111       ;AROUND
        FCB     %11010101       ;AROUND
        FCB     %11000100       ;AROUND
;
        XDEF    T.UP,M$UP
        FCB     %00010000       ;UP
        FCB     %00101011       ;UP
        FCB     %00000000       ;UP
;        
        XDEF    T.DN,M$DN
        FCB     %00100000       ;DOWN
        FCB     %00001000       ;DOWN
        FCB     %11111011       ;DOWN
        FCB     %10111000       ;DOWN
;
DIRNUM  EQU     FOO



;
;  ADJTAB: Adjective Token Tables
;
ADJTAB  FCB     ADJNUM
FOO     SET     0
;
;  Level-4
;
        XDEF    T.RN05,M$RN05
        FCB     %00111000       ;SUPREME
        FCB     %01100111       ;SUPREME
        FCB     %01011000       ;SUPREME
        FCB     %01001000       ;SUPREME
        FCB     %10101101       ;SUPREME
        FCB     %00101000       ;SUPREME
;
;  Level-3 Objects
;
        XDEF    T.RN01,M$RN01
        FCB     %00101000       ;JOULE
        FCB     %01010100       ;JOULE
        FCB     %11111010       ;JOULE
        FCB     %10110000       ;JOULE
        FCB     %10100000       ;JOULE
;
        XDEF    T.SWO1,M$SWO1
        FCB     %00110001       ;ELVISH
        FCB     %00001010       ;ELVISH
        FCB     %11001011       ;ELVISH
        FCB     %00100110       ;ELVISH
        FCB     %01101000       ;ELVISH
;
        XDEF    T.SHI1,M$SHI1
        FCB     %00111000       ;MITHRIL
        FCB     %11011010       ;MITHRIL
        FCB     %10011010       ;MITHRIL
        FCB     %00100010       ;MITHRIL
        FCB     %01001001       ;MITHRIL
        FCB     %01100000       ;MITHRIL
;



;
;  Level-2 Objects
;
        XDEF    T.SCR1,M$SCR1
        FCB     %00100000       ;SEER
        FCB     %10100110       ;SEER
        FCB     %01010010       ;SEER
        FCB     %11001000       ;SEER
;
        XDEF    T.FLA1,M$FLA1
        FCB     %00101000       ;THEWS
        FCB     %00101000       ;THEWS
        FCB     %10000010       ;THEWS
        FCB     %11011110       ;THEWS
        FCB     %01100000       ;THEWS
;
;  Level-1 Objects
;
        XDEF    T.RN03,M$RN03
        FCB     %00100000       ;RIME
        FCB     %01100100       ;RIME
        FCB     %10010110       ;RIME
        FCB     %10010100       ;RIME
;
        XDEF    T.SCR2,M$SCR2
        FCB     %00110000       ;VISION
        FCB     %10101100       ;VISION
        FCB     %10011001       ;VISION
        FCB     %10100101       ;VISION
        FCB     %11101110       ;VISION
;
        XDEF    T.FLA3,M$FLA3
        FCB     %00100000       ;ABYE
        FCB     %00000010       ;ABYE
        FCB     %00101100       ;ABYE
        FCB     %10010100       ;ABYE
;



        XDEF    T.FLA2,M$FLA2
        FCB     %00100000       ;HALE
        FCB     %00010000       ;HALE
        FCB     %00010110       ;HALE
        FCB     %00010100       ;HALE
;
        XDEF    T.TOR1,M$TOR1
        FCB     %00101001       ;SOLAR
        FCB     %01100110       ;SOLAR
        FCB     %11110110       ;SOLAR
        FCB     %00000110       ;SOLAR
        FCB     %01000000       ;SOLAR
;
        XDEF    T.SHI3,M$SHI3
        FCB     %00110000       ;BRONZE
        FCB     %11000101       ;BRONZE
        FCB     %00100111       ;BRONZE
        FCB     %10111011       ;BRONZE
        FCB     %01000101       ;BRONZE
;
;  Level-0
;
        XDEF    T.RN02,M$RN02
        FCB     %00110000       ;VULCAN
        FCB     %01101101       ;VULCAN
        FCB     %01010110       ;VULCAN
        FCB     %00001100       ;VULCAN
        FCB     %00101110       ;VULCAN
;
        XDEF    T.SWO2,M$SWO2
        FCB     %00100001       ;IRON
        FCB     %00010011       ;IRON
        FCB     %00100111       ;IRON
        FCB     %10111000       ;IRON
;



        XDEF    T.TOR2,M$TOR2
        FCB     %00101001       ;LUNAR
        FCB     %01011001       ;LUNAR
        FCB     %01010111       ;LUNAR
        FCB     %00000110       ;LUNAR
        FCB     %01000000       ;LUNAR
;
        XDEF    T.TOR4,M$TOR4
        FCB     %00100001       ;PINE
        FCB     %01100000       ;PINE
        FCB     %10010111       ;PINE
        FCB     %00010100       ;PINE
;
        XDEF    T.SHI4,M$SHI4
        FCB     %00111000       ;LEATHER
        FCB     %11011000       ;LEATHER
        FCB     %01010000       ;LEATHER
        FCB     %11010001       ;LEATHER
        FCB     %00000101       ;LEATHER
        FCB     %10010000       ;LEATHER
;
        XDEF    T.SWO3,M$SWO3
        FCB     %00110001       ;WOODEN
        FCB     %00101110       ;WOODEN
        FCB     %11110111       ;WOODEN
        FCB     %10010000       ;WOODEN
        FCB     %10101110       ;WOODEN
;



;
;  Special Objects
;
        XDEF    T.RN15,M$RN15
        FCB     %00101000       ;FINAL
        FCB     %01001100       ;FINAL
        FCB     %10010111       ;FINAL
        FCB     %00000101       ;FINAL
        FCB     %10000000       ;FINAL
;
        XDEF    T.RN11,M$RN11
        FCB     %00110000       ;ENERGY
        FCB     %01001010       ;ENERGY
        FCB     %11100010       ;ENERGY
        FCB     %11001000       ;ENERGY
        FCB     %11111001       ;ENERGY
;
        XDEF    T.RN13,M$RN13
        FCB     %00011000       ;ICE
        FCB     %01010010       ;ICE
        FCB     %00110010       ;ICE
        FCB     %10000000       ;ICE
;
        XDEF    T.RN12,M$RN12
        FCB     %00100000       ;FIRE
        FCB     %01001100       ;FIRE
        FCB     %10011001       ;FIRE
        FCB     %00010100       ;FIRE
;



        XDEF    T.RN20,M$RN20
        FCB     %00100000       ;GOLD
        FCB     %01001110       ;GOLD
        FCB     %11110110       ;GOLD
        FCB     %00010000       ;GOLD
;
        XDEF    T.FLA4,M$FLA4
        FCB     %00101000       ;EMPTY
        FCB     %00001010       ;EMPTY
        FCB     %11011000       ;EMPTY
        FCB     %01010011       ;EMPTY
        FCB     %00100000       ;EMPTY
;
        XDEF    T.TOR5,M$TOR5
        FCB     %00100001       ;DEAD
        FCB     %01001000       ;DEAD
        FCB     %01010000       ;DEAD
        FCB     %10010000       ;DEAD
;
ADJNUM  EQU     FOO



;
;  GENTAB: Generic Token Tables
;
GENTAB  FCB     GENNUM
FOO     SET     0
;
        XDEF    T.FLA0,M$FLA0
        FCB     %00101000       ;FLASK
        FCB     %00001100       ;FLASK
        FCB     %11000000       ;FLASK
        FCB     %11001101       ;FLASK
        FCB     %01100000       ;FLASK
;
        XDEF    T.RIN0,M$RIN0
        FCB     %00100000       ;RING
        FCB     %01100100       ;RING
        FCB     %10010111       ;RING
        FCB     %00011100       ;RING
;
        XDEF    T.SCR0,M$SCR0
        FCB     %00110000       ;SCROLL
        FCB     %10100110       ;SCROLL
        FCB     %00111001       ;SCROLL
        FCB     %00111101       ;SCROLL
        FCB     %10001100       ;SCROLL
;
        XDEF    T.SHI0,M$SHI0
        FCB     %00110000       ;SHIELD
        FCB     %11100110       ;SHIELD
        FCB     %10000100       ;SHIELD
        FCB     %10010101       ;SHIELD
        FCB     %10000100       ;SHIELD
;
        XDEF    T.SWO0,M$SWO0
        FCB     %00101001       ;SWORD
        FCB     %00100111       ;SWORD
        FCB     %01110111       ;SWORD
        FCB     %11001000       ;SWORD
        FCB     %10000000       ;SWORD
;



        XDEF    T.TOR0,M$TOR0
        FCB     %00101001       ;TORCH
        FCB     %01101000       ;TORCH
        FCB     %11111001       ;TORCH
        FCB     %00001101       ;TORCH
        FCB     %00000000       ;TORCH
;
GENNUM  EQU     FOO



;
;  Auto-Play Commands
;
; Temporarily replaced with ATM1 ATM2 ATM3 in missing-macros.asm
; Will uncomment when \# is supported in lwtools 4.20
;ATM     MACR
;        FCB     \#
;        FDB     \1
;   IFGT \#-1
;        FDB     \2
;   ENDC
;   IFGT \#-2
;        FDB     \3
;   ENDC
;        ENDM
;
AUTTAB  EQU     *
        ATM1    M$EXAM
        ATM3    M$PULL,M$RT,M$TOR0
        ATM2    M$USE,M$RT
        ATM1    M$LOOK
        ATM1    M$MOVE
        ATM3    M$PULL,M$LT,M$SHI0
        ATM3    M$PULL,M$RT,M$SWO0
        ATM1    M$MOVE
        ATM1    M$MOVE
        ATM2    M$ATTK,M$RT
        ATM2    M$TURN,M$RT
        ATM1    M$MOVE
        ATM1    M$MOVE
        ATM1    M$MOVE
        ATM2    M$TURN,M$RT
        ATM1    M$MOVE
        ATM1    M$MOVE
AUTEND  EQU     *
        FCB     -1
;
;;;;;        END
        