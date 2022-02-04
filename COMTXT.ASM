;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T E X T   D I S P L A Y   S E R V I C E   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  These routines maintain a scrolling text display
;  in Graphic Resolution-6 (G6R) mode.  Include are
;  character/string output routines and a software
;  character generator.
;
;  Depending on a flag (P.TXSGL), the routines will
;  generate text information in a single or both display
;  planes
;
        NAM     COMTXT
;     LIBRY  CD
;        XDEF    TXTXXX,TXTSCR,TXTDPB
;        XDEF    LSLD5,LSLD4,LSLD3,LSLD2,LSLD
;
;        XREF    SWCTAB,SPCTAB
;        PSCT
;
;  TXTXXX: Character Handling Routines
;
TXTXXX  CMPA    #I.BS           ;backspace? (left arrow key)
        BEQ     TXTBS           ;   yes
        CMPA    #I.CR           ;carriage return?
        BEQ     TXTCR           ;   yes
;
;  Printable Characters
;
        BSR     TXTDPB          ;deposit byte into display
        LEAX    1,X             ;advance cursor
        RTS                     ;bye
;
;  Backspace
;
TXTBS   LEAX    -1,X            ;cursor back one position
        CMPX    NEGONE          ;wraparound?
        BNE     TXTBS1          ;   nope
        LDX     P.TXCNT,U       ;wraparound to end
        LEAX    -1,X            ;   .
TXTBS1  RTS                     ;bye
;
;  Carriage Return
;
TXTCR   LEAX    32,X            ;down one line
        EXG     D,X             ;perform logical operation on IX
        ANDB    #%11100000      ;back to beginning of line
        EXG     D,X             ;restore regs
        RTS                     ;go home



;
;  TXTSCR: Screen Scrolling Routine
;
;  Inputs:
;       U - TXB pointer
;  Returns:
;       X - new cursor position (beginning of last line)
;         - screen scrolled up one line
;
TXTSCR  PSHS    A,B,X,Y         ;save regs
        LDX     P.TXBAS,U       ;pointer to first line
        LDD     P.TXCNT,U       ;form byte count
        SUBD    #32             ;minus one line
        STD     2,S             ;return new cursor position
        BSR     LSLD3           ;byte count = chars * 8
        TFR     D,Y             ;copy byte count
;
TSCR10  LDD     32*8,X          ;copy two bytes from next line
        TST     P.TXSGL,U       ;processing single/double screen?
        BNE     TSCR12          ;  single
        STD     G6.LEN,X        ;deposit two bytes into second screen
TSCR12  STD     ,X++            ;deposit two bytes into first screen
        LEAY    -2,Y            ;decrement loop count
        BNE     TSCR10          ;loop
;
        LDB     P.TXINV,U       ;process inverse-mode
        SEX                     ;   (magic cuz' P.TXINV is 0 or -1)
        LDY     #32*8           ;'clear last line' counter
;
TSCR20  TST     P.TXSGL,U       ;processing single/double screen?
        BNE     TSCR22          ;  single
        STD     G6.LEN,X        ;deposit two bytes into second screen
TSCR22  STD     ,X++            ;deposit two bytes into first screen
        LEAY    -2,Y            ;decrement loop count
        BNE     TSCR20          ;loop
;
        PULS    A,B,X,Y,PC      ;restore regs/exit
;
;  LSLDn: 16-bit Logic Shift Left
;
LSLD5   LSLB                    ;MSB into carry
        ROLA                    ;carry into LSB
LSLD4   LSLB                    ;and so on...
        ROLA                    ;   .
LSLD3   LSLB                    ;   .
        ROLA                    ;   .
LSLD2   LSLB                    ;   .
        ROLA                    ;   .
LSLD    LSLB                    ;   .
        ROLA                    ;   .
        RTS                     ;go home



;
;  TXTDPB: Software Character Generator
;
;  Inputs:
;       A - Display Code Character
;       U - Pointer to TXB
;
TXTDPB  PSHS    A,B,X,Y,U       ;save regs

skip2		macro noexpand
		fcb $8c
		endm

		tsta				; is it space?
		beq LCA29b			; brif so
		cmpa #$1b			; is it an printing character?
		blo LCA29a			; brif so
		beq LCA29c			; brif !
		cmpa #$1c			; is it _?
		beq LCA29d			; brif so
		cmpa #$1d			; is it ??
		beq LCA29e			; brif so
		cmpa #$1e			; is it .?
		beq LCA29f			; brif so
		adda #128-32			; offset to special characters in font data
		skip2				; go render the font data
LCA29a		adda #$40			; adjust to letter area of font
		skip2				; go render font data
LCA29b		lda #32				; code for space
		skip2
LCA29c		lda #'!				; code for !
		skip2
LCA29d		lda #'_				; code for _
		skip2
LCA29e		lda #'?				; code for ?
		skip2
LCA29f		lda #'.				; code for .
		ldb #8				; 8 bytes per font entry
		mul				; now D is offset
		addd #SWCTAB-(32*8)		; offset into table
		tfr d,x				; put pointer somewhere useful




;
;  Calculate Display Screen Address
;
;
;  Note:  P.TXCUR,U contains the following bit pattern
;
;               LLLL LLLL LLLC CCCC
;
;  Where:  L - forms the LINE count
;          C - forms the COLUMN count
;
;  display offset = (LINE*32*8) + COLUMN
;
DPB00   LDD     P.TXCUR,U       ;load cursor position
        BSR     LSLD3           ;magic bit manipulation!!!
        LSRB                    ;   .
        LSRB                    ;   .
        LSRB                    ;   .
        ADDD    P.TXBAS,U       ;add base addr to get pointer
        TFR     D,Y             ;transfer to index register
;
;  At this point:
;       X - ptr to software character (8-bytes)
;       Y - display screen addr
;       U - ptr to TXB
;
        LDB     #8              ;loop count
DPB10   LDA     ,X+             ;load next byte
        EORA    P.TXINV,U       ;process inverse mode
        STA     ,Y              ;deposit into display
        TST     P.TXSGL,U       ;write to a single screen?
        BNE     DPB20           ;   yes
        STA     G6.LEN,Y        ;write into both displays
DPB20   LEAY    32,Y            ;advance to next scan line
        DECB                    ;decrement loop count
        BNE     DPB10           ;loop until done
;
        PULS    A,B,X,Y,U,PC    ;restore regs/exit
;
;;;;;        END
