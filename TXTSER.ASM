;        TTL TXTSER - Text Service Routines
;
;  TXTSTI: Compressed String Output Immediate
;          Called via COMSWI.
;  Inputs:
;       PC - points to compressed
;  Returns:
;       PC <-- PC + (length of string)
;
TXTSTI  LDX     12,S            ;load string addr
        SWI                     ;expand the string
        FCB     EXPAND          ;   .
        STX     12,S            ;update the return addr
        LDX     #STRING+1       ;expanded string addr
        FCB     SKIP2           ;drop into TXTSTR
;
;  TXTSTR: Output a character string to the display
;          Called via COMSWI.
;  Input:
;       X - pointer to string
;
TSTR10  SWI                     ;print the char
        FCB     OUTCHR          ;   .
TXTSTR  LDA     ,X+             ;get next char
        BPL     TSTR10          ;   loop until terminator ($FF)
        RTS                     ;exit
;
;  TXTCHR: Output a character to the screen
;          Called via COMSWI.
;
;  Input:
;       A - Char to write
;
TXTCHR  TST     TXBFLG          ;do standard i/o?
        BNE     TCHR10          ;   nope
        LDU     #TXTPRI         ;i/o to primary text area
;
TCHR10  LDX     P.TXCUR,U       ;load cursor position
        JSR     TXTXXX          ;dispatch to routine
        CMPX    P.TXCNT,U       ;need to scroll?
        BLO     TCHR99          ;   nope
        JSR     TXTSCR          ;scroll one line
TCHR99  STX     P.TXCUR,U       ;update cursor position
        RTS                     ;go home
;
;;;;;        END
