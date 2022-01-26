;  OBIRTX: Create an Object
;
;  Inputs:
;       A - Object type
;       B - Level number
;  Returns:
;       X - Pointer to OCB
;         - Create Object Control Block (OCB)
;
OBIRTX  EQU     *
;
;  Find the next available OCB
;
        LDU     OCBPTR          ;load current OCB ptr
        STU     6,S             ;return as parm
        LEAX    OC.LEN,U        ;advance OCB ptr
        STX     OCBPTR          ;   .
;
;  Fill in the new OCB
;
        STA     P.OCTYP,U       ;store the object type
        STB     P.OCLVL,U       ;store the level number
        SWI                     ;fill-in regular parameters
        FCB     OCBFIL          ;   .
;
;  Implement Generic Values (as necessary)
;
        LDB     P.OCCLS,U       ;use class as index into GENVAL
        LDX     #GENVAL         ;translation table base addr
        LDA     B,X             ;load translation value
        BMI     OBIR99          ;   minus means don't change
;
        LDB     P.OCREV,U       ;preserve relevation requirements
        SWI                     ;overwrite with generic values
        FCB     OCBFIL          ;   .
        STB     P.OCREV,U       ;   .
;
OBIR99  RTS                     ;bye
;
;  GENVAL: Generic/Specific Translation Table
;
GENVAL  EQU     *               ;table begins here
        FCB     -1              ;(0) K.FLAS
        FCB     -1              ;(1) K.RING
        FCB     -1              ;(2) K.SCRO
        FCB     T.SHI4          ;(3) K.SHIEE
        FCB     T.SWO3          ;(4) K.SWOR
        FCB     T.TOR4          ;(5) K.TORC



;
;  OCBFIX: Fill in OCB information
;
;  Inputs:
;       A - object type
;       U - ptr to OCB
;
OCBFIX  EQU     *               ;where everything starts
;
;  Copy Regular Parameters
;
        LSLA                    ;calculate index (times OD.LEN)
        LSLA                    ;   (OD.LEN = 4)
        LDX     #ODBTAB         ;table base addr
        LEAY    A,X             ;IY - source addr
        LEAX    P.OCCLS,U       ;IX - destination addr
        LDA     #OD.LEN         ;ACCA - byte count
        JSR     COPY            ;copy it
;
;  Process Special Parameters
;
        LDX     #XXXTAB-4       ;special parameter table
OFIL10  LEAX    4,X             ;advance ptr
        LDA     ,X              ;load special object type (2022 n.b. original was 0,X)
        BMI     OFIL99          ;   minus means we are done
        CMPA    3,S             ;match current object type?
        BNE     OFIL10          ;   nope - loop until match
;
        LDD     1,X             ;copy special parameters
        STD     P.OCXXX,U       ;   .
        LDA     3,X             ;   .
        STA     P.OCXXX+2,U     ;   .
;
OFIL99  RTS                     ;restore regs/exit
;;;;;        END
