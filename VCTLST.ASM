;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; D I S P L A Y   L I S T   P R O C E S S O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  Inputs:
;       X - vector list pointer
;       VXSCAL - radix-7 scaling constant for Y
;       VYSCAL - radix-7 scaling constant for Y
;
;  Notes:
;
;       B B B B B B B B
;        ^
;        !
;        +-------------------Radix-7 Binary Point
;
;    Coordinate list is stored in memory as: y,x y,x y,x.....
;
;    Since there are no y values greater than 191, values from
;    192 to 255 are available for use as flags and indicators.
;
;
;
;  SETFAX: Set the Lighting Levels Based on RANGE
;
SETFAX  LDA     RLIGHT          ;assume regular light
        TST     MAGFLG          ;   .
        BEQ     SFAD10          ;   regular light
        LDA     MLIGHT          ;magic light
        CLR     MAGFLG          ;reset flag
;
SFAD10  CLRB                    ;assume maximum brightness
        SUBA    #7              ;offset brightness level
        SUBA    RANGE           ;attenuate brightness with distance
        BGE     SFAD30          ;   use maximum brightness
;
        DECB                    ;assume total darkness
        CMPA    #-7             ;   .
        BLE     SFAD30          ;   total darkness
;
        LDX     #BITMSK+8       ;magic table base addr
        LDB     A,X             ;load lighting value
;
SFAD30  STB     VCTFAD          ;set fade value
COMRTS  RTS                     ;bye



;
;  VCTLSX: Vector List Processing Routine
;
VCTLSX  EQU     *               ;where it all begins
        CLR     DRWFLG          ;flag - no starting (Y,X)
;
; Test if VCTFAD says to black out this vector list
;
        LDA     VCTFAD          ;load fade-out value
        INCA                    ;is it $FF?
        BEQ     VCTEND          ;   draw nothing/exit
;
; Special Vector List Control Code Processing
;
VCTL10  LDB     ,X              ;load y-coordinate
        SUBB    #V$RTS          ;special control code?
        BCS     VCTABS          ;   no - absolute mode processing
        LEAX    1,X             ;advance byte ptr
        LDY     #VCTDIS         ;dispatch table addr
        LDB     B,Y             ;load offset value
        JMP     B,Y             ;   .
;
VCTDIS  EQU     *               ;dispatch table
        FCB     VCTRTS-VCTDIS   ;($FA) - V$RTS
        FCB     VCTJSR-VCTDIS   ;($FB) - V$JSR
        FCB     VCTREL-VCTDIS   ;($FC) - V$REL
        FCB     VCTJMP-VCTDIS   ;($FD) - V$JMP
        FCB     VCTEND-VCTDIS   ;($FE) - V$END
        FCB     VCTNEW-VCTDIS   ;($FF) - V$NEW



;
;  VCTJSR: Jump to Vector List Subroutine
;
VCTJSR  LDD     ,X++            ;load subroutine addr
        STX     ,--S            ;store return addr
        TFR     D,X             ;process subroutine
        FCB     SKIP2           ;drop into V$NEW...
;
;  VCTJMP: Jump to a New Vector List
;
VCTJMP  LDX     ,X              ;load new vector list addr
        FCB     SKIP2           ;drop into V$NEW...
;
;  VCTRTS: Return from Vector List Subroutine
;
VCTRTS  LDX     ,S++            ;load return addr/drop into V$NEW...
;
;  VCTNEW: Start a new vector list
;
VCTNEW  CLR     DRWFLG          ;indicate we should get new start
        BRA     VCTL10          ;loop for next coordinates



;
;  VCTABS: Absolute Mode Processing
;
VCTABS  TST     DRWFLG          ;have we set starting coordinates?
        BNE     VABS00          ;   yes
;
        BSR     VABS20          ;set starting coordinates
        DEC     DRWFLG          ;say we have started
        BRA     VCTL10          ;loop for next coordinates
;
VABS00  BSR     VABS10          ;set end point
        JSR     VECTOR          ;draw the vector/exit
        BRA     VCTL10          ;loop for next coordinates
;
VABS10  BSR     NEWOLD          ;end point becomes beginning
VABS20  LDB     ,X+             ;load Y-coordinate
        STB     TY              ;store absolute value
        BSR     ASCALY          ;scale Y-coordinate
        ADDD    VCNTRY          ;add Y-centroid
        STD     Y1              ;store new end point
;
        LDB     ,X+             ;load X-coordinate
        STB     TX              ;store absolute value
        BSR     ASCALX          ;scale X-coordinate
        ADDD    VCNTRX          ;add X-centroid
        STD     X1              ;store new end point
VCTEND  RTS                     ;done



;
;  NEWOLD:  Copy Ending (Y,X) to Starting (Y,X)
;
NEWOLD  LDD     Y1              ;copy Y-end points
        STD     Y0              ;   .
        LDD     X1              ;copy X-end points
        STD     X0              ;   .
        RTS                     ;done
;
;  mSCALc: Scale Coordinates
;
;  Where:
;       m - (R)elative or (A)bsolute
;       c - (Y)-coordinate or (X)-coordinate
;  Inputs:
;       A - Y/X coordinate
;  Returns:
;       D - Y/X coordinate scaled
ASCALY  LDA     VYSCAL          ;load Y-scaling value
        SUBB    VCNTRY+1        ;distance from centroid
        BRA     ASCA10          ;   .
ASCALX  LDA     VXSCAL          ;load X-scaling value    
        SUBB    VCNTRX+1        ;distance from centroid
ASCA10  BCS     SCAL10          ;   negative
;
SCAL00  MUL                     ;perform scaling
        BRA     SCAL20          ;   .
;
SCAL10  NEGB                    ;absolute value for scaling
        MUL                     ;unsigned multiply
        JSR     NEGD            ;fix sign
SCAL20  JMP     ASRD7           ;RADIX-7/exit
;



;
;  VCTREL: Relative Mode Processing
;
VCTREL  LDA     ,X+             ;check for V$ABS
        BEQ     VCTNEW          ;   saw V$ABS/simulate V$NEW/done
        BSR     NEWOLD          ;copy end points to start ponits
;
; Extract Y-coordinate nybble
;
        LDB     -1,X            ;recover original data byte
        ASRB                    ;MSNibble into LSNibble (signed)
        ASRB
        ASRB
        ASRB
        LSLB                    ;range (-16:14)
        ADDB    TY              ;effect relative change in absolute
        STB     TY              ;   .
        BSR     ASCALY          ;scale y-coordinate
        ADDD    VCNTRY          ;add Y-centroid
        STD     Y1              ;store as new end point
;
; Extract and process X-coordinate nybble.
;
        LDB     -1,X            ;recover original data byte
        ANDB    #%00001111      ;extract LSNibble
        BITB    #%00001000      ;check "sign bit"
        BEQ     VREL20          ;   positive
        ORB     #%11110000      ;sign extend
VREL20  LSLB                    ;range (-16:14)
        ADDB    TX              ;effect relative change
        STB     TX              ;   .
        BSR     ASCALX          ;scale x-coordinate
        ADDD    VCNTRX          ;add x-centroid
        STD     X1              ;store new end point
;
        JSR     VECTOR          ;draw the vector
        BRA     VCTREL          ;loop until V$ABS is seen
;
;;;;;        END
