;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  V E R T I C A L   F E A T U R E   V E C T O R   L I S T S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        NAM     VERT
;     LIBRY  CD
;        XDEF    FWDVER,CELINE
;        OPT     NOMEX,NOGEN
;        DSCT
;
;  Forward Looking Features Table
;
FWDVER  FDB     HOLEUP          ;(0) VF.HUP
        FDB     FLUP            ;(1) VF.LUP
        FDB     HOLEDN          ;(2) VF.HDN
        FDB     FLDN            ;(3) VF.LDN
;
;  Forward Looking Ladder Up Sequence
;
FLUP    FCB     V$JSR           ;subroutine
        FDB     LADDER          ;   ladder
        FCB     V$JMP           ;jump to
        FDB     HOLEUP          ;   hole-up
;
;  Forward Looking Ladder Down Sequece
;
FLDN    FCB     V$JSR           ;subroutine
        FDB     LADDER          ;   ladder
        FCB     V$JMP           ;jump to
        FDB     HOLEDN          ;   hole-down



;
;  Forward Looking Ladder Vector List Subroutine
;
LADDER  FCB     24,116          ;upper left corner
        FCB     128,116         ;lower left corner
        FCB     V$NEW
;
        FCB     24,140          ;upper right corner
        FCB     128,140         ;lower right corner
        FCB     V$NEW
;
;;;;;;;;;FIXME
;        FCB     28,116          ;1st rung
;        FCB     28,140
;        FCB     V$NEW
;
        FCB     40,116          ;2nd rung
        FCB     40,140
        FCB     V$NEW
;
        FCB     52,116          ;3rd rung
        FCB     52,140
        FCB     V$NEW
;
        FCB     64,116          ;4th rung
        FCB     64,140
        FCB     V$NEW
;
        FCB     76,116          ;5th rung
        FCB     76,140
        FCB     V$NEW
;
        FCB     88,116          ;6th rung
        FCB     88,140
        FCB     V$NEW
;
        FCB     100,116          ;7th rung
        FCB     100,140
        FCB     V$NEW
;
        FCB     112,116          ;8th rung
        FCB     112,140
        FCB     V$NEW
;
        FCB     123,116          ;9th rung
        FCB     123,140
        FCB     V$NEW
;
        FCB     V$RTS           ;return



;
;  Forward Looking Ceiling Hole Vector List
;
HOLEUP  FCB     34,100          ;back left corner
        FCB     24,92           ;front left corner
        FCB     24,164          ;nearer horizontal edge
        FCB     34,156          ;right edge
        FCB     34,100          ;farther horizontal edge
;
        FCB     24,100          ;line up on left
        FCB     V$NEW           ;start new sequence of vectors
;
        FCB     34,156          ;farther right corner
        FCB     24,156          ;line up on right
        FCB     V$NEW           ;start new sequence of vectors
;
        FCB     28,47           ;left end of left ceiling line
        FCB     28,96           ;right end of left ceiling line
        FCB     V$NEW           ;start new sequence of vectors
;
        FCB     28,161          ;left end of right ceiling line
        FCB     28,210          ;right end of right ceiling line
        FCB     V$END           ;done



;
;  Forward Looking Floor Hole Vector List
;
HOLEDN  FCB     118,100         ;back left corner
        FCB     128,92          ;front left corner
        FCB     128,164         ;nearer horizontal edge
        FCB     118,156         ;right edge
        FCB     118,100         ;farther edge
;
        FCB     128,100         ;line down on left
        FCB     V$NEW           ;start new sequence of vectors
;
        FCB     118,156         ;farther right corner
        FCB     128,156         ;line down on right
        FCB     V$NEW           ;fall into CELINE
;
; Forward "Passage" (line across ceiling)
;
CELINE  FCB     28,47           ;line across ceiling
        FCB     28,210          ;
VNULL   FCB     V$END           ;end of vector list
;
;;;;;        END
