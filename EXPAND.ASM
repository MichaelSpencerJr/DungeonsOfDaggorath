;  EXPAND: 5-Bit Character String Expansion Routine
;
;  Inputs:
;       X - pointer to 5-bit string
;       U - expansion buffer addr (EXPAN0 only)
;  Returns:
;       X - points past 5-bit string
;       STRING - expanded 5-bit character string
;
EXPANX  LDU     #STRING+1       ;default expansion buffer addr
EXPA00  EQU     *               ;secondary entry point
;
;  Expand 5-Bit Character String
;
        LEAY    -1,U            ;IY <- 5-bit offset counter address
        CLR     ,Y              ;reset 5-bit char offset (2022 n.b. original was 0,Y)
        BSR     GETFIV          ;get first 5-bit char
        TFR     B,A             ;use as byte count
;
EXPA10  BSR     GETFIV          ;get the next 5-bit character
        STB     ,U+             ;buffer bytes...
        DECA                    ;decrement byte count
        BPL     EXPA10          ;   loop until done
        STA     ,U              ;terminate buffer with $FF
;
;  Strings Terminate on Byte Boundaries
;
        TST     ,Y              ;are we already on byte boundary? (2022 n.b. original was 0,Y)
        BEQ     EXPA90          ;   yes
        LEAX    1,X             ;advance to next byte
;
;  Found our man...
;
EXPA90  STX     6,S             ;return parameter
        RTS                     ;that's all folks!!!



;
;  GETFIV: Get the next 5-bit Char
;
;  Inputs:
;       X - pointer to compressed string (byte pointer)
;       0,Y - 5-bit offset counter
;  Returns:
;       B - 5-bit character
;       X - updated
;       0,Y - updated
;
GETFIV  PSHS    A,U             ;save regs
;
;  Dispatch to correct routine
;
        LDA     ,Y              ;use 5-bit char offset as index (2022 n.b. original was 0,Y)
        LDU     #FIVDSP         ;table base addr
        LDA     A,U             ;load offset value
        JSR     A,U             ;dispatch
;
;  Update 5-bit Offset Counter
;
        LDA     ,Y              ;advance 5-bit offset counter (2022 n.b. original was 0,Y)
        INCA                    ;   .
        ANDA    #7              ;MOD 8
        STA     ,Y             ;   .  (2022 n.b. original was 0,Y)
;
;  Return Byte
;
        ANDB    #$1F            ;use only lower 5-bits
        PULS    A,U,PC          ;restore regs/exit



;
;  5-bit Character Extraction Routine Dispatch Table
;
FIVDSP  FCB     CHAR00-FIVDSP
        FCB     CHAR10-FIVDSP
        FCB     CHAR20-FIVDSP
        FCB     CHAR30-FIVDSP
        FCB     CHAR40-FIVDSP
        FCB     CHAR50-FIVDSP
        FCB     CHAR60-FIVDSP
        FCB     CHAR70-FIVDSP
;
;  5-bit Char Extraction Routines
;
CHAR00  LDB     ,X              ;load byte
CHAR02  LSRB                    ;shift into position
CHAR04  LSRB                    ;   .
CHAR06  LSRB                    ;   .
        RTS                     ;done
;
CHAR10  LDD     ,X+             ;load byte (across boundary)
        JMP     ASRD6           ;shift into position/exit
;
CHAR20  LDB     ,X              ;load byte
        BRA     CHAR06          ;shift into position/exit
;
CHAR30  LDD     ,X+             ;load byte (across boundary)
        JMP     ASRD4           ;shift into position/exit
;
CHAR40  LDD     ,X+             ;load byte (across boundary)
        JMP     ASRD7           ;shift into position/exit
;
CHAR50  LDB     ,X              ;load byte
        BRA     CHAR04          ;shift into position/exit
;
CHAR60  LDD     ,X+             ;load byte (across boundary)
        JMP     ASRD5           ;shift into position/exit
;
CHAR70  LDB     ,X+             ;load byte
        RTS                     ;already in position/exit
;;;;;        END
