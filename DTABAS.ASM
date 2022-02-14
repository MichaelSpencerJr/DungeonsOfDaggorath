;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D A T A B A S E   D E F I N I T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     DTABAS
;     LIBRY  CD
;        XDEF    DISPAT
;        XDEF    CDBTAB,ODBTAB,FWDCRE,XXXTAB
;        XDEF    OMXTAB,OMXEND,FWDOBJ,OBJWGT
*
;        XREF    T.RN11,T.RN12,T.RN13,T.RN15
;        PSCT
*
 IFNDEF DEBFLG
DEBFLG  EQU     0
   ENDC



*
*  CMDXXX: Command Definition Macro
*
*  Arguments:
*       0) Command String
*       1) 4 letter abbreviation
*       2) Zero
*       3) Service Routine
*
CMDXXX  MACR
        \1      ATTACK,ATTK,0,PATTK
        \1      CLIMB,CLIM,0,PCLIMB
        \1      DROP,DROP,0,PDROP
        \1      EXAMINE,EXAM,0,PEXAM
        \1      GET,GET,0,PGET
        \1      INCANT,INCN,0,PINCAN
        \1      LOOK,LOOK,0,PLOOK
        \1      MOVE,MOVE,0,PMOVE
        \1      PULL,PULL,0,PPULL
        \1      REVEAL,REVE,0,PREVEA
        \1      STOW,STOW,0,PSTOW
        \1      TURN,TURN,0,PTURN
        \1      USE,USE,0,PUSE
        \1      ZLOAD,ZLOA,0,PZLOAD
        \1      ZSAVE,ZSAV,0,PZSAVE
        \1      ZPAUSE,ZPAU,0,PZPAUS
        ENDM
*
*  Debugging Commands Macro
*
*  Arguments:
*       0) Command String
*       1) 4 letter abbreviation
*       2) Zero
*       3) Service Routine
*
DEBXXX  MACR
        \1      QMAP,QMAP,0,DEBMAP
        ENDM



*
*  Direction Token Macro
*
*  Arguments:
*       0) Command String
*       1) 4 letter abbreviation
*       2) Zero
*
DIRXXX  MACR
        \1      LEFT,LT,0
        \1      RIGHT,RT,0
        \1      BACKWARD,BAK,0
        \1      AROUND,AROU,0
        \1      UP,UP,0
        \1      DOWN,DN,0
        ENDM



*
*  GENXXX: General Object Definition Macro
*
*  Arguments:
*       0) Object Name
*       1) 4-letter abbreviation
*       2) Class
*       3) Forward Looking Vector List
*       4) Look Down Vector List
*       5) Object Weight
*


GENXXX  MACR
        \1      FLASK,FLA0,K.FLAS,FFLASK,DFLASK,5
        \1      RING,RIN0,K.RING,FRING,DRING,1
        \1      SCROLL,SCR0,K.SCRO,FSCROL,DSCROL,10
        \1      SHIELD,SHI0,K.SHIE,FSHIEL,DSHIEL,25
        \1      SWORD,SWO0,K.SWOR,FSWORD,DSWORD,25
        \1      TORCH,TOR0,K.TORC,FTORCH,DTORCH,10
        ENDM



*
*  OBJXXX: Object Definition Macro
*
*  Arguments:
*       0) Object Name
*       1) 4-letter Abbreviation
*       2) Generic Class
*       3) Reveal Power Requirements
*       4) Magic Offense
*       5) Physical Offense
*       6) Initial Level where object shows up
*       7) Number of objects
*
*  Arguments (8-A) if present will generate an entry
*  in XXXTAB (special object parameters).
*
LVL0    EQU     0
LVL1    EQU     1
LVL2    EQU     2
LVL3    EQU     3
LVL4    EQU     4
LVL5    EQU     5
;*
; 2022 Edit:
;
; Modified this macro again to use \1 for 8-argument lists and \2 for 11-argument.
; Must be called with two macros, one which accepts 8-argument lists and one for 11.
; Also defined macro NOCALL in missing-macros.asm which does nothing, so 8 arg lines
; can be skipped for 11-arg-only macros.  Will change when \# is supported in lwtools 4.20
OBJXXX  MACR
*
*  Level-4 Objects
*
        \2      SUPREME,RN05,K.RING,255,0,5,LVL4,1,3,T.RN15,0
*
*  Level-3 Objects
*
        \2      JOULE,RN01,K.RING,170,0,5,LVL3,1,3,T.RN11,0
        \1      ELVISH,SWO1,K.SWOR,150,64,64,LVL3,1
        \2      MITHRIL,SHI1,K.SHIE,140,13,26,LVL3,2,64,64,0
*
*  Level-2 Objects
*
        \1      SEER,SCR1,K.SCRO,130,0,5,LVL2,3
        \1      THEWS,FLA1,K.FLAS,70,0,5,LVL2,3
*
*  Level-1 Objects
*
        \2      HOTH,RN03,K.RING,52,0,5,LVL1,1,3,T.RN13,0
        \1      VISION,SCR2,K.SCRO,50,0,5,LVL1,3
        \1      ABYE,FLA3,K.FLAS,48,0,5,LVL1,6
        \1      HALE,FLA2,K.FLAS,40,0,5,LVL1,4
        \2      SOLAR,TOR1,K.TORC,70,0,5,LVL1,4,60,13,11
        \2      BRONZE,SHI3,K.SHIE,25,0,26,LVL1,6,96,128,0
*
*  Level-0 Objects
*
        \2      VULCAN,RN02,K.RING,13,0,5,LVL0,1,3,T.RN12,0
        \1      IRON,SW02,K.SWOR,13,0,40,LVL0,4
        \2      LUNAR,TOR2,K.TORC,25,0,5,LVL0,8,30,10,4
        \2      PINE,TOR4,K.TORC,5,0,5,LVL0,8,15,7,0
        \2      LEATHER,SHI4,K.SHIE,5,0,10,LVL0,3,108,128,0
        \1      WOODEN,SWO3,K.SWOR,5,0,16,LVL0,4
*
        ENDM



*
*  SPCXXX: Special Object Definition Macro
*
*  2022 update: to work around LWTools missing NARG, argument count is
*               being added to the head of these value lists.
*  Arguments:
*       0) Object Name
*       1) 4-letter Abbreviation
*       2) Generic Class
*       3) Reveal Power Requirements (zero)
*       4) Magic Offense
*       5) Physical Offense
*
SPCXXX  MACR
        \1      FINAL,RN15,K.RING,0,0,0
        \1      ENERGY,RN11,K.RING,0,255,255
        \1      ICE,RN13,K.RING,0,255,255
        \1      FIRE,RN12,K.RING,0,255,255
        \1      GOLD,RN20,K.RING,0,0,5
        \1      EMPTY,FLA4,K.FLAS,0,0,5
        \2      DEAD,TOR5,K.TORC,5,0,5,0,0,0,0,0
        ENDM



*
*  Creature Definition Macro
*
*  Arguments:
*       0) Vector List
*       1) Movement Delay Time
*       2) Attack Delay Time
*       3) Magic Offense
*       4) Magic Defense
*       5) Physical Offense
*       6) Physical Defense
*       7) Hit Points
*
CREXXX  MACR
        \1      SPIDER,23,11,0,255,128,255,32
        \1      VIPER,15,7,0,255,80,128,56
        \1      SGINT1,29,23,0,255,52,192,200
        \1      BLOB,31,31,0,255,96,167,304
        \1      KNIGT1,13,7,0,128,96,60,504
        \1      SGINT2,17,13,0,128,128,48,704
        \1      SCORP,5,4,255,128,255,128,400
        \1      KNIGT2,13,7,0,64,255,8,800
        \1      WRAITH,3,3,192,16,192,8,800
        \1      BALROG,4,3,255,5,255,3,1000
        \1      WIZ0,13,7,255,6,255,0,1000
        \1      WIZ1,13,7,255,6,255,0,8000
        ENDM



*
*  DISPAT: Command Dispatch Macro
*
CDM     MACR
;        XREF    \3
        FDB     \4
        ENDM
*
DISPAT  EQU     *
        CMDXXX  CDM
        IF      DEBFLG
        DEBXXX  CDM
        ENDIF



*
*  FWDOBJ: Object Forward Looking Vector Lists
*
FLVL    MACR
;        XREF    \3
        FDB     \4
        ENDM
*
FWDOBJ  EQU     *
        GENXXX  FLVL



*
*  OBJWGT: Object Weight Table
*
WGT     MACR
        FCB     \6
        ENDM
*
OBJWGT  EQU     *
        GENXXX  WGT



*
*  ODBTAB: Object Definition Blocks
*
ODB     MACR
        FCB     \3,\4
        FCB     \5,\6
        ENDM
*
ODBTAB  EQU     *
        OBJXXX  ODB,ODB
        SPCXXX  ODB,ODB



*
*  XXXTAB: Special Parameter Tables
*
*  For Torches:
*       .OCXXX+0 ==> timer value
*       .OCXXX+1 ==> regular lighting value
*       .OCXXX+2 ==> magical lighting value
*
*  For Shields:
*       .OCXXX+0 ==> Magical Defense Filter
*       .OCXXX+1 ==> Physical Defense Filter
*       .OCXXX+2 ==> unused
*
XXX     MACR
        FCB     T.{2}
        FCB     {9}
        FCB     {10}
        FCB     {11}
        ENDM
*
XXXTAB  EQU     *
        OBJXXX  NOCALL,XXX
        SPCXXX  NOCALL,XXX
;
        FCB     -1              ;table terminator



*
*  OMXTAB: Object Distribution Table
*
*  Bit7-4: Object Level Number
*  Bit3-0: Number of objects
*
;OMX     MACR
;LH      SET     (\6!.$0F)!<4
;RH      SET     (\7!.$0F)
;        FCB     LH!+RH
;        ENDM
OMX     MACR
        FCB     ((\7&$0F)*16)+(\8&$0F)
        ENDM
*
OMXTAB  EQU     *
        OBJXXX  OMX,OMX
OMXEND  EQU     *



*
*  FWDCRE: Forward Looking Creature Vector Lists
*
CVL     MACR
;        XREF    \0
        FDB     \1
        ENDM
*
FWDCRE  EQU     *
        CREXXX  CVL



*
*  CDBTAB: Creature Definition Blocks
*
CDB     MACR
        FDB     \8              ;power
        FCB     \4,\5           ;magical offense/defense
        FCB     \6,\7           ;physical offense/defense
        FCB     \2,\3           ;movement/attack delay times
        ENDM
*
CDBTAB  EQU     *
        CREXXX CDB
;;;;;        END
