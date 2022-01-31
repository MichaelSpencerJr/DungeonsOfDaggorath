;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  O B J E C T   V E C T O R   L I S T S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     VOBJ
;     LIBRY  CD
;
;        XDEF    FSHIEL,FFLASK,FRING
;        XDEF    FSCROL,FSWORD,FTORCH
;        OPT     NOMEX,NOGEN
;        DSCT
;
; Looking Forward - Shield
;
FSHIEL  FCB     134,172         ;bottom left of shield
        FCB     128,192
        FCB     122,186
        
        SVORG   128,168
        SVECT   134,164
        SVECT   134,172
        SVEND

; * * * * * * * * *
;
; Looking Forward - Torch
;
FTORCH  SVORG   118,60          ;tip of torch
        SVECT   116,74
        SVECT   114,72
        SVECT   118,60
        SVEND
        
;
; * * * * * * * * *
;
; Looking Forward - Sword
;
FSWORD  FCB     114,80          ;base of handle
        FCB     124,100         ;tip of blade
        FCB     V$NEW
;
        FCB     118,82          ;hand guard
        FCB     114,86
        FCB     V$END           ;end of vector list
;
; * * * * * * * * *



; * * * * * * * * *
;
; Looking Forward - Flask
;
FFLASK  SVORG   110,162         ;top of flask
        SVECT   120,164
        SVECT   120,160
        SVECT   110,162
        SVEND                   ;end of vector list

;
;
; * * * * * * * * *
;
; Looking Forward - Ring
;
FRING   SVORG   122,60          ;top of ring
        SVECT   124,62
        SVECT   126,60
        SVECT   124,58
        SVECT   122,60
        SVEND



; * * * * * * * * *
;
; Looking Forward - Scroll
;
FSCROL  SVORG   118,194         ;top of scroll
        SVECT   120,192
        SVECT   126,200
        SVECT   124,202
        SVECT   118,194
        SVEND
;
;
; * * * * * * * * *
;;;;;        END
