SCHED$  MACR
        LDD     #(\1*256)+\2
        ENDM

;Look-down drawing method symbols referenced in macros but definitions removed
;before ROM went to Radio Shack for production.
DFLASK  EQU     0
DRING   EQU     0
DSCROL  EQU     0
DSHIEL  EQU     0
DSWORD  EQU     0
DTORCH  EQU     0

NOCALL  MACR
        ENDM

ATM1    MACR
        FCB     1
        FDB     \1
        ENDM

ATM2    MACR
        FCB     2
        FDB     \1
        FDB     \2
        ENDM

ATM3    MACR
        FCB     3
        FDB     \1
        FDB     \2
        FDB     \3
        ENDM

SVORG   MACR
SVX     SET     \1
SVY     SET     \2
        FCB     \1,\2,V$REL
        ENDM

SVECT   MACR
        FCB     ((((\1-SVX)/2)&$000F)*16)+(((\2-SVY)/2)&$000F)
SVX     SET     \1
SVY     SET     \2
        ENDM
        
SVEND   MACR
        SVNEW
        FCB     V$END
        ENDM
        
SVNEW   MACR
        FCB     V$ABS
        ENDM
