;
;  HUPDAX:  Update the heart rate
;
;  Note:
;              (P * 64)
;       J = --------------- - 19
;             P + (D * 2)
;
;  Where:
;       J = jiffy delay count (HEARTR)
;       P = power (PPOW)
;       D = damage (PDAM)
;
;  All calculations are done with 24-bit arithmatic.
;
;  Temp Storage:
;       T0 - denominator (24-bit)
;       T1 -      "
;       T2 -      "
;       T3 - numerator (24-bit)
;       T4 -     "
;       T5 -     "
;       T6 - dividend (8-bit)
;
HUPDAX  EQU     *               ;the beginning
;
;  Calculate numerator
;
HUPD00  CLR     T0              ;(p*64)
        LDD     PPOW            ;   .
        STD     T1              ;   .
        LDA     #6              ;   (64=2**6)
HUPD10  LSL     T2              ;least significant byte
        ROL     T1              ;middle byte
        ROL     T0              ;most significant byte
        DECA                    ;   .
        BNE     HUPD10          ;   .
;
;  Calculate denominator
;
        CLR     T3              ;(d*2)
        LDD     PDAM            ;   .
        STD     T4              ;   .
        LSL     T5              ;least significant byte
        ROL     T4              ;middle byte
        ROL     T3              ;most significant byte
        LDD     PPOW            ;(p+(d*2))
        ADDD    T4              ;   .
        STD     T4              ;   .
        LDB     T3              ;   .
        ADCB    #0              ;   .
        STB     T3              ;   .



;
;  Calculate divident
;
        CLR     T6              ;reset dividend
HUPD20  LDD     T1              ;16 LSBits of numerator
        SUBD    T4              ;subtract 16 LSBits of denominator
        STD     T1              ;store back into numerator
        LDA     T0              ;8 MSBits of numerator
        SBCA    T3              ;sub 8 LSBits of denominator + carry
        STA     T0              ;store back into numerator
        INC     T6              ;bump dividend
        BCC     HUPD20          ;loop until numerator goes negative
;
;  Update the heartrate
;
        LDA     T6              ;load dividend
        SUBA    #19             ;subtract nineteen
        STA     HEARTR          ;store as new heartrate
;
;  Are we unconscious (fainted)?
;
        TST     FAINT           ;check the flag
        BNE     HUPD40          ;   we are out cold!
;
        CMPA    #3              ;should we faint?
        BGT     HUPD90          ;   nope
;
;  Special Effects - Fainting
;
        SWI                     ;clear primary text area
        FCB     CLRPRI          ;   .
        LDA     RLIGHT          ;save RLIGHT for later
        STA     OLIGHT          ;   .
;
HUPD30  DEC     MLIGHT          ;reduce lighting
        JSR     [DSPMOD]        ;show the new view
        DEC     UPDATE          ;request and wait for screen update
        SYNC                    ;   .
        DEC     RLIGHT          ;lower lighting
        LDA     RLIGHT          ;done?
        CMPA    #-8             ;   .
        BGT     HUPD30          ;   nope
;
HUPD32  SWI                     ;insure screen is blank
        FCB     ZFLOP           ;   .
        DEC     UPDATE          ;   .
        DEC     FAINT           ;indicate we have fainted
        CLR     KBDHDR          ;insure empty buffer
        CLR     KBDTAL          ;   .
        BRA     HUPD90          ;   .



;
;  We Fainted - should we recover?
;
HUPD40  CMPA    #4              ;should we get up?
        BLE     HUPD90          ;   nope
;
HUPD42  JSR     [DSPMOD]        ;create the new scene
        DEC     UPDATE          ;request screen update
        SYNC                    ;   .
        INC     MLIGHT          ;increase lighting
        INC     RLIGHT          ;   .
        LDA     RLIGHT          ;done yet?
        CMPA    OLIGHT          ;   .
        BLE     HUPD42          ;   nope
;
        CLR     FAINT           ;time to waike up
        SWI                     ;fake the prompt
        FCB     PROMPT          ;   .
;
;  Check for Death
;
HUPD90  LDX     PPOW            ;more power than damage?
        CMPX    PDAM            ;   .
        BLO     DEATH           ;   bought the farm
        RTS                     ;bye
;
;  We have a dead player on our hands...
;
DEATH   LDX     #WIZ1           ;the crescent wizzard
        DEC     FADFLG          ;(fade-in)
        SWI                     ;   (clear the status line)
        FCB     WIZIN           ;   .
;
		jsr putstrimm			; display the death message
		fcn '\r YET ANOTHER DOES NOT RETURN...'



        CLR     FAINT           ;force GAME restart on char
        DEC     AUTFLG          ;   .
        BRA     *               ;then loop forever
;;;;;        END
