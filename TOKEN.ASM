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
        fcb     \4
\2      EQU     *
        fcn     '\3'
        ENDM

T.GRAM  SET     0

;
        XDEF    T.ATTK,M$ATTK,ATTACK,T.GRAM
;
        XDEF    T.CLIM,M$CLIM,CLIMB,T.GRAM
;
        XDEF    T.DROP,M$DROP,DROP,T.GRAM
;
        XDEF    T.EXAM,M$EXAM,EXAMINE,T.GRAM
;
        XDEF    T.GET,M$GET,GET,T.GRAM
;



;
        XDEF    T.INCN,M$INCN,INCANT,T.GRAM
;
        XDEF    T.LOOK,M$LOOK,LOOK,T.GRAM
;
        XDEF    T.MOVE,M$MOVE,MOVE,T.GRAM
;
        XDEF    T.PULL,M$PULL,PULL,T.GRAM
;
        XDEF    T.REVE,M$REVE,REVEAL,T.GRAM
;
        XDEF    T.STOW,M$STOW,STOW,T.GRAM



        XDEF    T.TURN,M$TURN,TURN,T.GRAM
;        
        XDEF    T.USE,M$USE,USE,T.GRAM
;        
        XDEF    T.ZLOA,M$ZLOA,ZLOAD,T.GRAM
;
        XDEF    T.ZSAV,M$ZSAV,ZSAVE,T.GRAM

        XDEF    T.ZPAU,M$ZPAU,ZPAUSE,T.GRAM


;
;  Debugging Commands
;
        IF      DEBFLG
;
        XDEF    T.QMAP,M$QMAP,QMAP,T.GRAM
;
        XDEF    T.QUP,M$QUP,QUP,T.GRAM
;
        XDEF    T.QDN,M$QDN,QDN,T.GRAM
;
        XDEF    T.QRUP,M$QRUP,QRUP,T.GRAM
;
        XDEF    T.QRDN,M$QRDN,QRDN,T.GRAM
;
        XDEF    T.QMUP,M$QMUP,QMUP,T.GRAM
;
        
        
        
        XDEF    T.QMDN,M$QMDN,QMDN,T.GRAM
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
        XDEF    T.LT,M$LT,LEFT,T.GRAM
;
        XDEF    T.RT,M$RT,RIGHT,T.GRAM
;
        XDEF    T.BAK,M$BAK,BACK,T.GRAM
;



        XDEF    T.AROU,M$AROU,AROUND,T.GRAM
;
        XDEF    T.UP,M$UP,UP,T.GRAM
;        
        XDEF    T.DN,M$DN,DOWN,T.GRAM
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
        XDEF    T.RN05,M$RN05,SUPREME,T.RIN0
;
;  Level-3 Objects
;
        XDEF    T.RN01,M$RN01,JOULE,T.RIN0
;
        XDEF    T.SWO1,M$SWO1,ELVISH,T.SWO0
;
        XDEF    T.SHI1,M$SHI1,MITHRIL,T.SHI0
;



;
;  Level-2 Objects
;
        XDEF    T.SCR1,M$SCR1,SEER,T.SCR0
;
        XDEF    T.FLA1,M$FLA1,THEWS,T.FLA0
;
;  Level-1 Objects
;
        XDEF    T.RN03,M$RN03,RIME,T.RIN0
;
        XDEF    T.SCR2,M$SCR2,VISION,T.SCR0
;
        XDEF    T.FLA3,M$FLA3,ABYE,T.FLA0
;



        XDEF    T.FLA2,M$FLA2,HALE,T.FLA0
;
        XDEF    T.TOR1,M$TOR1,SOLAR,T.TOR0
;
        XDEF    T.SHI3,M$SHI3,BRONZE,T.SHI0
;
;  Level-0
;
        XDEF    T.RN02,M$RN02,VULCAN,T.RIN0
;
        XDEF    T.SWO2,M$SWO2,IRON,T.SWO0
;



        XDEF    T.TOR2,M$TOR2,LUNAR,T.TOR0
;
        XDEF    T.TOR4,M$TOR4,PINE,T.TOR0
;
        XDEF    T.SHI4,M$SHI4,LEATHER,T.SHI0
;
        XDEF    T.SWO3,M$SWO3,WOODEN,T.SWO0
;



;
;  Special Objects
;
        XDEF    T.RN15,M$RN15,FINAL,T.RIN0
;
        XDEF    T.RN11,M$RN11,ENERGY,T.RIN0
;
        XDEF    T.RN13,M$RN13,ICE,T.RIN0
;
        XDEF    T.RN12,M$RN12,FIRE,T.RIN0
;



        XDEF    T.RN20,M$RN20,GOLD,T.RIN0
;
;        XDEF    T.FLA4,M$FLA4,EMPTY,T.FLA0  FIXME
FOO     SET     FOO+1
;
        XDEF    T.TOR5,M$TOR5,DEAD,T.TOR0
;
ADJNUM  EQU     FOO



;
;  GENTAB: Generic Token Tables
;
GENTAB  FCB     GENNUM
FOO     SET     0
;
        XDEF    T.FLA0,M$FLA0,FLASK,T.FLA0
;
        XDEF    T.RIN0,M$RIN0,RING,T.RIN0
;
        XDEF    T.SCR0,M$SCR0,SCROLL,T.SCR0
;
        XDEF    T.SHI0,M$SHI0,SHIELD,T.SHI0
;
        XDEF    T.SWO0,M$SWO0,SWORD,T.SWO0
;



        XDEF    T.TOR0,M$TOR0,TORCH,T.TOR0
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
        