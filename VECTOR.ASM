;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  V E C T O R   G E N E R A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        NAM     VECTOR
;     LIBRY  CD
;        XDEF    VECTOR,NEGD,DIVIDE,BITMSK
;
;        XREF    ASRD6,ASRD3,LSLD5
;        PSCT
        PAGE
;
;  DIVIDE: Software Division Routine
;
;  Inputs:
;       D - 16-bit unsigned dividend
;       X - divisor
;  Returns:
;       D - 16-bit unsigned result (RADIX-8: bbbbbbbb.bbbbbbbb)
;  Destroys:
;       T0,T1,T2
;
DIVIDE  PSHS    A,B,X           ;save regs
        CLR     ,S              ;reset quotient (2022 n.b. original was 0,S)
        CLR     1,S             ;   .
        CLR     T0              ;store dividend (T0:T1:T2)
        STD     T1              ;   .
;
;  Special Test for Zero/One
;
        BEQ     DIV99           ;   dividend was zero
        CMPD    2,S             ;dividend = divisor?
        BNE     DIV00           ;   nope
        INC     ,S              ;set result (2022 n.b. original was 0,S)
        BRA     DIV99           ;done
;
;  Shift and Subtract
;
DIV00   LDX     #16             ;number of times to loop
DIV10   LSL     T2              ;dividend * 2
        ROL     T1              ;   .
        ROL     T0              ;   .
        LSL     1,S             ;quotient * 2
        ROL     ,S              ;   . (2022 n.b. original was 0,S)
;
;  Trial Subtraction
;
        LDD     T0              ;16-MSBits of dividend
        SUBD    2,S             ;trial subtraction successful?
        BCS     DIV20           ;   nope
        STD     T0              ;update 16-MSBits of dividend
        INC     1,S             ;quotient = quotient + 1
;
DIV20   LEAX    -1,X            ;decrement and loop
        BNE     DIV10           ;   .
DIV99   PULS    A,B,X,PC        ;return parm/exit



;
;  NEGD: 16-bit Negation Routine
;
NEGD    COMA                    ;16-bit complement
        COMB                    ;   .
        ADDD    #1              ;plus one
        RTS                     ;   .
;
;  INCRE: Calculate Incremental Values
;
;  Inputs:
;       D - 16-bit signed value
;       LENGTH - 16-bit divisor
;  Returns:
;       D - result of (D/LENGTH)
;
INCRE   PSHS    A,B,X           ;save regs
        LDX     LENGTH          ;load length into X
        LDD     ,S              ;check sign (2022 n.b. original was 0,S)
        BPL     INCR10          ;   D is already positive
;
;  D is negative
;
        BSR     NEGD            ;use absolute value
        BSR     DIVIDE          ;use software division routine
        BSR     NEGD            ;make negative again
        FCB     SKIP2           ;   .
;
INCR10  BSR     DIVIDE          ;use software division routine
INCR90  STD     ,S              ;store return parameter (2022 n.b. original was 0,S)
        PULS    A,B,X,PC        ;return parm/exit



;
;  VECTOR: Simple Digital Differential Analyzer
;
VECT00  JMP     VECT99          ;local jump
VECTOR  PSHS    A,B,X,Y,U       ;save regs
;
;  Set Fade Parameters
;
        INC     VCTFAD          ;invisible line?
        BEQ     VECT00          ;   yes - don't draw anything
        LDA     VCTFAD          ;set initial fade count
        STA     FADCNT          ;   .
;
;  Calculate Length
;
        LDD     X1              ;dx = (x1-x0)
        SUBD    X0              ;   .
        STD     DX+1            ;   .
        BPL     VECT12          ;   already absolute value
        BSR     NEGD            ;make absolute
VECT12  STD     LENGTH          ;assume this will be our length
;
        LDD     Y1              ;dy = (y1-y0)
        SUBD    Y0              ;   .
        STD     DY+1            ;   .
        BPL     VECT14          ;   already absolute value
        BSR     NEGD            ;make absolute
VECT14  CMPD    LENGTH          ;length = max (abs(dx),abs(dy))
        BLT     VECT20          ;   .
        STD     LENGTH          ;   .
        BEQ     VECT00          ;zero length means skip processing
;
;  Calculate X,Y Increments
;
VECT20  LDD     DX+1            ;dx = (x1-x0)/length
        BSR     INCRE           ;   .
        STD     DX+1            ;   .
        TFR     A,B             ;extend sign
        SEX                     ;   .
        LDB     #1              ;byte move delta
        STA     DX              ;   .
        BPL     VECT22          ;   positive delta
        NEGB                    ;negative delta
VECT22  STB     DELTAX          ;store byte move delta
;
        LDD     DY+1            ;dy = (y1-y0)/length
        BSR     INCRE           ;   .
        STD     DY+1            ;   .
        TFR     A,B             ;extend sign
        SEX                     ;   .
        LDB     #32             ;scan line delta
        STA     DY              ;   .
        BPL     VECT24          ;   positive delta
        NEGB                    ;negative delta
VECT24  STB     DELTAY          ;store scan line delta
;



;  Set (XX = X0 + 0.5)   (YY = Y0 + 0.5)
;
        LDD     X0              ;set integer portion of XX,YY
        STD     XX              ;   .
        LDD     Y0              ;   .
        STD     YY              ;   .
        LDA     #BIT7           ;set fraction portion of XX,YY
        STA     XX+2            ;   .
        STA     YY+2            ;   .
;
;  Calculate Initial Screen Coordinate
;
        LDX     P.VDEND,U       ;store display ending, base addr
        STX     VDEND           ;   (frees U-reg)
        LDX     P.VDBAS,U       ;   .
        STX     VDBAS           ;   .
;
        LDD     YY              ;load Y-coordinate
        JSR     LSLD5           ;multiply by 32 to get scan line addr
        LEAX    D,X             ;add to base addr
;
        LDD     XX              ;load X-coordinate
        JSR     ASRD3           ;divide by 8 to get byte addr
        LEAX    D,X             ;we now have exact display byte addr
;
        LDU     #BITMSK         ;load bit mask
        LDY     LENGTH          ;loop counter
;
;  Process Fade Function
;
VECT30  DEC     FADCNT          ;should we plot this dot?
        BNE     VECT40          ;   nope
        LDA     VCTFAD          ;reset counter
        STA     FADCNT          ;   .
;
;  Clip all offscreen points
;
        TST     XX              ;clip X-coordinate
        BNE     VECT40          ;   .
        CMPX    VDBAS           ;clip Y-coordinate
        BLO     VECT40          ;   .
        CMPX    VDEND           ;   .
        BHS     VECT40          ;   .
;
;  Plot Next Point
;
        LDB     XX+1            ;load low order byte
        ANDB    #7              ;MOD 8 to get bit position
        LDA     B,U             ;load positioned byte
        TST     VDGINV          ;normal or inverse mode
        BEQ     VECT32          ;   normal mode
        COMA                    ;inverse mask
        ANDA    ,X              ;clear bit
        FCB     SKIP2           ;   .
VECT32  ORA     ,X              ;mark bit
        STA     ,X              ;update display byte



;
;  Increment X,Y
;
VECT40  LDA     XX+1            ;modify and save middle byte
        ANDA    #%11111000      ;   .
        STA     T0              ;   .
;
        LDD     XX+1            ;increment middle, low bytes
        ADDD    DX+1            ;   .
        STD     XX+1            ;   .
        LDB     XX              ;increment high byte
        ADCB    DX              ;   .
        STB     XX              ;   .
;
        ANDA    #%11111000      ;time for byte move?
        CMPA    T0              ;   .
        BEQ     VECT50          ;   nope
        LDB     DELTAX          ;move byte
        LEAX    B,X             ;   .
;
VECT50  LDD     YY+1            ;increment middle, low bytes
        STA     T0              ;save middle byte for later
        ADDD    DY+1            ;   .
        STD     YY+1            ;update middle, low bytes
        LDB     YY              ;increment high byte
        ADCB    DY              ;   .
        STB     YY              ;   .
;
        CMPA    T0              ;time for scan line change?
        BEQ     VECT60          ;   nope
        LDB     DELTAY          ;change scan lines
        LEAX    B,X             ;   .
;
;  Decrement Loop Counter
;
VECT60  LEAY    -1,Y            ;decrement and loop
        BNE     VECT30          ;   .
;
VECT99  DEC     VCTFAD          ;restore VCTFAD to original value
        PULS    A,B,X,Y,U,PC    ;restore regs/exit
;
BITMSK  FCB     BIT7
        FCB     BIT6
        FCB     BIT5
        FCB     BIT4
        FCB     BIT3
        FCB     BIT2
        FCB     BIT1
        FCB     BIT0
;
;;;;;        END
