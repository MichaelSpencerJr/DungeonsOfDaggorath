;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  P A R S I N G   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  GETTOK: Return the next token in LINBUF
;
;  Inputs:
;       LINPTR - where to start search
;
;  Returns:
;       LINPTR - poniting past token
;       TOKEN  - token terminated by a ($FF)
;       N - condition code set if no token found
;
GETTOK  PSHS    A,X,U           ;save some regs
        LDX     LINPTR          ;load line buffer pointer
        LDU     #TOKEN          ;load token buffer base addr
;
;  Eat leading spaces
;
GTOK10  LDA     ,X+             ;get next input char
        BEQ     GTOK10          ;   eat leading spaces
        BRA     GTOK22          ;drop into loop
;
;  Copy non-spaces to TOKEN
;
GTOK20  LDA     ,X+             ;get input string char
GTOK22  BLE     GTOK30          ;   ($FF) or space means we are done
        STA     ,U+             ;otherwise copy char to token buffer
        CMPU    #TOKEND         ;insure token buffer is not overrun
        BLO     GTOK20          ;   .
;
;  Terminate token with ($FF)
;
GTOK30  LDA     #$FF            ;terminator
        STA     ,U+             ;   .
        STX     LINPTR          ;update pointer
        TST     TOKEN           ;return N set if no token
        PULS    A,X,U,PC        ;restore regs/go home



;
;  PAROBJ: Parse an object from the line buffer
;
;  Inputs:
;       LINBUF - line buffer
;       LINPTR - line buffer pointer
;  Returns:
;       A - object class
;       B - object type
;       OBJCLS - object class
;       OBJTYP - object type
;       LINPTR - updated past object tokens
;  Format:
;       1) <generic>
;       2) <adjective> <generic>
;  Examples:
;       1) "SCROLL"
;       2) "GUIDANCE SCROLL"
;
PAROBJ  CLR     SPEFLG          ;assume generic form
        LDX     #GENTAB         ;generic token search
        BSR     PARSER          ;   .
        BMI     POBJ10          ;   search failure
        BEQ     PARERR          ;   null tokens are illegal
        STD     OBJTYP          ;store parms
        RTS                     ;go home
;
;  Check for an adjective
;
POBJ10  DEC     SPEFLG          ;must be specific form
        LDX     #ADJTAB         ;search for an adjective
        BSR     PARSE0          ;   .
        BLE     PARERR          ;   null/illegal tokens not allowed
        STD     OBJTYP          ;save adjective parms
;
        LDX     #GENTAB         ;search for generic tokens
        BSR     PARSER          ;   .
        BLE     PARERR          ;   null/illegal tokens
        CMPB    OBJCLS          ;matching class?
        BNE     PARERR          ;   nope - loser
POBJ99  RTS                     ;return as a winner!



;
;  PARERR: Tell user the bad news
;
PARERR  LEAS    2,S             ;remove return addr
CMDERR  SWI
        FCB     OUTSTI
        FCB     %00010111       ;???
        FCB     %01111011       ;???
        FCB     %11010000       ;???
;
        RTS



;
;  PARSER: Get and Classify the next TOKEN
;
;  Inputs:
;       X - pointer to token table
;       LINPTR - Line Buffer Pointer
;  Returns:
;       A - Token type
;       B - Token class
;       TOKEN - TOken
;       LINPTR - updated past last token
;       N - condition code set if search failure
;
PARSE0  PSHS    A,B,X,Y,U       ;secondary entry ponit
        CLRA                    ;   .
        BRA     PARS02          ;   .
;
PARSER  PSHS    A,B,X,Y,U       ;save some regs
        CLRA                    ;assume next token is null
        CLRB                    ;   .
        BSR     GETTOK          ;get the next token
        BMI     PARS92          ;   token is null
;
PARS02  CLR     PARFLG          ;reset "seen match" flag
        CLR     FULFLG          ;reset "full word" match flag
        LDB     ,X+             ;load the number of tokens
        STB     PARCNT          ;store as loop count
;
;  Compare TOKEN against next command
;
PARS10  LDU     #TOKEN          ;reset token byte pointer
        SWI                     ;expand 5-bit string
        FCB     EXPAND          ;   .
        LDY     #STRING+2       ;load command byte pointer
PARS12  LDB     ,U+             ;load next token byte
        BMI     PARS20          ;   winner - end of token
        CMPB    ,Y+             ;token match command?
        BNE     PARS30          ;   nope - loser
        TST     ,Y              ;reach end of command?
        BPL     PARS12          ;   nope - continue comparisons
        TST     ,U              ;end of token?
        BPL     PARS30          ;   nope - loser
        DEC     FULFLG          ;end token/command - full match
;
;  We have a Winner!
;
PARS20  TST     PARFLG          ;have we already seen a match?
        BNE     PARS90          ;   can't have two matches!
        INC     PARFLG          ;flag successful command match
        LDB     STRING+1        ;load token class
        STD     ,S              ;store return values (2022 n.b. original was 0,S)



;
;  Advance to next command
;
PARS30  INCA                    ;bump command counter
        DEC     PARCNT          ;decrement loop counter
        BNE     PARS10          ;   loop until table exhausted
;
;  Finish up and go home
;
        TST     PARFLG          ;did we match a command?
        BNE     PARS99          ;   yes - go home a winner
PARS90  LDD     NEGONE          ;loser...
PARS92  STD     ,S              ;   . (2022 n.b. original was 0,S)
PARS99  PULS    A,B,X,Y,U,PC    ;restore regs/go home



;
;  PARHND:  Parse LEFT or RIGHT hand
;
;  Inputs:
;       LINPTR
;  Returns:
;       A - Token Type
;       B - Token Class
;       U - #PLHAND or #PRHAND
;       TOKEN - token
;       LINPTR - updated past last token
;       N - condition code set if parse fails
;
PARHND  LDX     #DIRTAB         ;directions
        BSR     PARSER          ;get the next token
        BLE     PARERR          ;   null/illegal token
        LDU     #PRHAND         ;right hand
        CMPA    #T.RT           ;   .
        BEQ     PHND90          ;   .
        LDU     #PLHAND         ;left hand
        CMPA    #T.LT           ;   .
        BNE     PARERR          ;   .
PHND90  LDX     ,U              ;load OCB ptr
        RTS                     ;exit
;
;;;;;        END
