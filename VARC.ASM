;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  A R C H I T E C T U R A L   V E C T O R   L I S T S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     VARC  - Architectural Vector Lists
;     LIBRY  CD
;
;        XDEF    LPASAG,RPASAG,FPASAG
;        XDEF    LDOOR,RDOOR,FDOOR
;        XDEF    LSDOOR,RSDOOR,FSDOOR
;        XDEF    LWALL,RWALL,FWALL
;        XDEF    LPEEK,RPEEK
;        DSCT
;
; Vector lists are stored as point pairs, with the Y
; coordinate appearing first: y,x,y,x,y,x,.....
;
; Special command codes can appear in place of the Y-coordinate
; (see COMDEF definitions).
;
; When describing creature parts, left and right are from the
; creature's point of view.
;
; When describing inanimate objects, left and right are from
; the player's point of view. (screen left and right)
;
; When in offset-mode, each data byte is divided into 2 4-bit
; nybbles, each of which are 4-bit two's complement offsets
; which are each multiplied by 2 and added to the preceeding
; point's coordinates to obtain the next y,x coordinate. The
; hi-order nybble is the y offset and the lo-order nybble is
; the x offset.
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  A R C H I T E C T U R A L   F E A T U R E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
; Left Wall
;
LWALL   FCB     16,27           ;top horizontal line
        FCB     38,64
        FCB     114,64          ;far vertical line
        FCB     136,27          ;bottom horizontal line
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Right Wall
;
RWALL   FCB     16,229          ;top horizontal line
        FCB     38,192
        FCB     114,192         ;far vertical line
        FCB     136,229         ;bottom horizontal line
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Forward Wall
;
FWALL   FCB     38,64           ;top horizontal line
        FCB     38,192
        FCB     V$NEW           ;start new sequence of vectors
;
        FCB     114,64          ;bottom horizontal line
        FCB     114,192
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Left Passage
;
LPASAG  FCB     38,29           ;top horizontal line
        FCB     38,64
        FCB     114,64          ;vertical line
        FCB     114,27          ;bottom horizontal line
        FCB     V$NEW           ;start new vector sequence
;
        FCB     16,27           ;continuation of top wall line
        FCB     38,64
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Right Passage
;
RPASAG  FCB     38,229          ;top horizontal line
        FCB     38,192
        FCB     114,192         ;vertical line
        FCB     114,229         ;bottom horizontal line



        FCB     V$NEW           ;start new vector sequence
;
        FCB     16,229          ;continuation of top wall line
        FCB     38,192          ;
FPASAG  FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Left Door
;
LDOOR   FCB     128,40          ;nearer vertical line
        FCB     65,40
        FCB     68,56           ;top line
        FCB     119,56          ;farther vertical line
        FCB     V$NEW           ;start new vector sequence
;
        FCB     92,48           ;doorknob
        FCB     93,52
;
        FCB     V$JMP           ;chain to another list
        FDB     LWALL           ;superimpose left wall
;
; * * * * * * * * *
;
; Right Door
;
RDOOR   FCB     128,216         ;nearer vertical line
        FCB     65,216
        FCB     68,200          ;top line
        FCB     119,200         ;farther vertical line
        FCB     V$NEW           ;start new vector sequence
;
        FCB     92,208          ;doorknob
        FCB     93,204
;
        FCB     V$JMP           ;chain to another list
        FDB     RWALL           ;superimpose right wall
;
; * * * * * * * * *
;
; Forward Door
;
FDOOR   FCB     114,108         ;left side vertical line
        FCB     67,108
        FCB     67,148          ;top line
        FCB     114,148         ;right side vertical line
        FCB     V$NEW           ;start new vector sequence
;
        FCB     94,126          ;doorknob
        FCB     94,130
;
        FCB     V$JMP           ;chain to another list
        FDB     FWALL           ;superimpose forward wall
;
; * * * * * * * * *
;



; Left Secret-Door
;
LSDOOR  FCB     128,40          ;nearer line
        FCB     66,50           ;apex of triangle
        FCB     117,58          ;farther line
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Right Secret-Door
;
RSDOOR  FCB     128,216         ;nearer line
        FCB     66,206          ;apex of triangle
        FCB     117,198         ;farther line
        FCB     V$END           ;end of this list
;
; * * * * * * * * *
;
; Forward Secret-Door
;
FSDOOR  FCB     113,108         ;left line
        FCB     67,128          ;apex of triangle
        FCB     114,148         ;right line
        FCB     V$END           ;end of this list
;



; * * * * * * * * *
;
; Left Peek-a-boo shape vector list
;
LPEEK   SVORG   100,28
        SVECT   108,36
        SVECT   112,32
        SVECT   120,36
        SVECT   128,28
        SVEND
;
; * * * * * * * * *
;
; Right Peek-a-boo shape vector list
;
RPEEK   SVORG   100,228
        SVECT   108,220
        SVECT   112,224
        SVECT   120,220
        SVECT   128,228
        SVEND
;
;
; * * * * * * * * *
;;;;;        END