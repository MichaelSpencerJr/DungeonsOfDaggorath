;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  H U M A N   I N T E R F A C E   M O D U L E
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PLAYER: Keyboard Input/Autoplay Task
;
;       This task takes its input from the keyboard
;       or from the AUTOPLAY tables.  A character at
;       a time is fed to the subroutine HUMAN.  This
;       task runs as often as possible (delay: 1 jiffy).
;
PLAYER  TST     AUTFLG          ;autoplay?
        BNE     PLAY20          ;   yes
;
;  Process Keyboard Buffer
;
PLAY10  JSR     KBDGET          ;get the next char
        TSTA                    ;check for nulls
        BEQ     PLAY99          ;   NULL means we are done
;
        TST     FAINT           ;did we faint?
        BNE     PLAY10          ;   yes - just eat chars
        bsr HUMAN			; go process input character
        BRA     PLAY10          ;loop



;
;  Process Autoplay Commands
;
PLAY20  LDY     AUTPTR          ;load ptr to next command
        LDB     ,Y+             ;load token count
        BPL     PLAY30          ;   commands still left
;
        SWI                     ;otherwise hang around for awhile
        FCB     WAIT            ;   .
        SWI                     ;   .
        FCB     WAIT            ;   .
        JMP     DEMO            ;then restart the whole shebang!!!
;
;  Feed next autoplay command to HUMAN
;
PLAY30  LDU     ,Y++            ;load next token string ptr
        SWI                     ;delay between words
        FCB     WAIT            ;   .
        FCB     SKIP2           ;   .
;
PLAY40  BSR     HUMAN           ;process the char
        LDA     ,U+             ;load next char
        BNE     PLAY40          ;   valid chars goto HUMAN
;
        LDA     #C.SP           ;terminate tokens with spaces
        BSR     HUMAN           ;   .
;
        DECB                    ;decrement token count
        BNE     PLAY30          ;   until no more tokens
;
PLAY50  LDA     #C.CR           ;terminate commands with return
        BSR     HUMAN           ;   .
        STY     AUTPTR          ;update ptr
;
PLAY99  SCHED$  1,Q.JIF         ;once per jiffy
        RTS



;
;  HUMAN: Process Character Input/Command Dispatch
;
;  Inputs:
;       A - Char to be processed
;  Returns:
;       LINBUF - Char buffered
;       LINPTR - updated
;
;  Notes:
;       This routine is reponsible for maintaining the
;       primary text display.  It handles character echoing
;       erasing deleted characters, and prompting the player.
;       As characters are received, they are buffered until
;       a line terminator (carriage return) is seen.  This
;       routine will atempt to dispatch to the proper command
;       handler based on the first TOKEN in the line buffer.
;
HUMAN   PSHS    A,B,X,Y,U       ;save regs LD24C
;
;  Check if we are displaying the map
;
HMAN10  TST     HEARTF          ;are we in map mode?
        BNE     HMAN20          ;   nope
        SWI                     ;forward-looking display
        FCB     INIVU           ;   .
        SWI                     ;fake the prompt
        FCB     PROMPT          ;   .
;
;  Process Characters
;
HMAN20  LDU     LINPTR          ;load line buffer ptr
        CMPA    #C.CR           ;check for line terminator
        BEQ     HMAN30          ;   .
        CMPA    #C.BS           ;check for character delete
        BEQ     HMAN40          ;   .
;
;  Buffer Normal Chars
;
		cmpa #C.SP			; is it control character?
		blo HMAN99			; brif so - ignore it
		cmpa #C.DEL-1			; above ascii?
		bhi HMAN99			; brif so - ignore it
		jsr putchr			; render the character


        STA     ,U+             ;buffer char and advance ptr
        LDX     #M$CURS         ;print the cursor
        jsr     putstr          ;go render the cursor
        CMPU    #LINEND         ;insure against buffer overruns
        BNE     HMAN99          ;   buffer still has room



;
;  Process Carriage Returns
;
HMAN30  lda     #C.SP           ;erase old cursor
        jsr     putchr          ;   .
        LDD     BIGZER          ;terminate buffer
        STD     ,U++            ;   .
        LDU     #LINBUF         ;reset line buffer ptr for parsing
        STU     LINPTR          ;   .
        BRA     HMAN50          ;drop into dispatching code
;
;  Process Character Delete
;
HMAN40  CMPU    #LINBUF         ;check buffer boundary
        BEQ     HMAN99          ;   .
        LEAU    -1,U            ;decrement ptr
        LDX     #M$ERAS         ;print <BS><SP><BS>
        jsr     putstr          ;   .
        BRA     HMAN99          ;loop for more
;
M$ERAS  FCB     I.SP,I.BS,I.BS,I.BAR,I.BS,$FF
;
;  Dispatch to Proper Routine
;
HMAN50  LDX     #CMDTAB         ;primary commands
        JSR     PARSER          ;get the next token
        BEQ     HMAN70          ;   null token
        BPL     HMAN60          ;   legal command
        JSR     CMDERR          ;indicate error
        BRA     HMAN70          ;flush rest of line
;
HMAN60  LSLA                    ;code*2 for offset
        LDX     #DISPAT         ;dispatch table base addr
        JSR     [A,X]           ;dispatch to correct routine
;
HMAN70  LDU     #LINBUF         ;reset line buffer ptr
        TST     HEARTF          ;are we in map mode?
        BEQ     HMAN99          ;   yes - no prompt
        TST     FAINT           ;are we unconscious?
        BNE     HMAN99          ;   yes - no prompt
;
        SWI                     ;prompt the human
        FCB     PROMPT          ;   .
;
HMAN99  STU     LINPTR          ;update the line ptr 
        PULS    A,B,X,Y,U,PC    ;restore regs/exit
;
;;;;;        END
