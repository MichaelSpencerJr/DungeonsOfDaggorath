;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S O F T W A R E   C H A R A C T E R   T A B L E
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  Entries in the software character tables are 5 bits
;  wide and 7 bytes long:
;
;  Byte 0  ...XXXXX
;  Byte 1  ...XXXXX
;  Byte 2  ...XXXXX
;  Byte 3  ...XXXXX
;  Byte 4  ...XXXXX
;  Byte 5  ...XXXXX
;  Byte 6  ...XXXXX
;



SWCTAB  EQU     *               ;where the tables begin
;
        FCB     %00110000       ;* Space         = $00
        FCB     %00000000       ;* Space         = $00
        FCB     %00000000       ;* Space         = $00
        FCB     %00000000       ;* Space         = $00
        FCB     %00000000       ;* Space         = $00
;
        FCB     %00110001       ;* Letter A      = $01
        FCB     %00010101       ;* Letter A      = $01
        FCB     %00011000       ;* Letter A      = $01
        FCB     %11111110       ;* Letter A      = $01
        FCB     %00110001       ;* Letter A      = $01
;                 
        FCB     %00110111       ;* Letter B      = $02
        FCB     %10100011       ;* Letter B      = $02
        FCB     %00011111       ;* Letter B      = $02
        FCB     %01000110       ;* Letter B      = $02
        FCB     %00111110       ;* Letter B      = $02
;                 
        FCB     %00110011       ;* Letter C      = $03
        FCB     %10100011       ;* Letter C      = $03
        FCB     %00001000       ;* Letter C      = $03
        FCB     %01000010       ;* Letter C      = $03
        FCB     %00101110       ;* Letter C      = $03
;                 
        FCB     %00110111       ;* Letter D      = $04
        FCB     %10100011       ;* Letter D      = $04
        FCB     %00011000       ;* Letter D      = $04
        FCB     %11000110       ;* Letter D      = $04
        FCB     %00111110       ;* Letter D      = $04
;                 
        FCB     %00110111       ;* Letter E      = $05
        FCB     %11100001       ;* Letter E      = $05
        FCB     %00001111       ;* Letter E      = $05
        FCB     %01000010       ;* Letter E      = $05
        FCB     %00011111       ;* Letter E      = $05
;                 
        FCB     %00110111       ;* Letter F      = $06
        FCB     %11100001       ;* Letter F      = $06
        FCB     %00001111       ;* Letter F      = $06
        FCB     %01000010       ;* Letter F      = $06
        FCB     %00010000       ;* Letter F      = $06
;                 
        FCB     %00110011       ;* Letter G      = $07
        FCB     %11100011       ;* Letter G      = $07
        FCB     %00001000       ;* Letter G      = $07
        FCB     %01001110       ;* Letter G      = $07
        FCB     %00101111       ;* Letter G      = $07
;                 
        FCB     %00110100       ;* Letter H      = $08
        FCB     %01100011       ;* Letter H      = $08
        FCB     %00011111       ;* Letter H      = $08
        FCB     %11000110       ;* Letter H      = $08
        FCB     %00110001       ;* Letter H      = $08
;                 



        FCB     %00110011       ;* Letter I      = $09
        FCB     %10001000       ;* Letter I      = $09
        FCB     %01000010       ;* Letter I      = $09
        FCB     %00010000       ;* Letter I      = $09
        FCB     %10001110       ;* Letter I      = $09
;                 
        FCB     %00110000       ;* Letter J      = $0A
        FCB     %01000010       ;* Letter J      = $0A
        FCB     %00010000       ;* Letter J      = $0A
        FCB     %10000110       ;* Letter J      = $0A
        FCB     %00101110       ;* Letter J      = $0A
;                 
        FCB     %00110100       ;* Letter K      = $0B
        FCB     %01100101       ;* Letter K      = $0B
        FCB     %01001100       ;* Letter K      = $0B
        FCB     %01010010       ;* Letter K      = $0B
        FCB     %01010001       ;* Letter K      = $0B
;                 
        FCB     %00110100       ;* Letter L      = $0C
        FCB     %00100001       ;* Letter L      = $0C
        FCB     %00001000       ;* Letter L      = $0C
        FCB     %01000010       ;* Letter L      = $0C
        FCB     %00011111       ;* Letter L      = $0C
;                 
        FCB     %00110100       ;* Letter M      = $0D
        FCB     %01110111       ;* Letter M      = $0D
        FCB     %01011010       ;* Letter M      = $0D
        FCB     %11010110       ;* Letter M      = $0D
        FCB     %00110001       ;* Letter M      = $0D
;                 
        FCB     %00110100       ;* Letter N      = $0E
        FCB     %01100011       ;* Letter N      = $0E
        FCB     %10011010       ;* Letter N      = $0E
        FCB     %11001110       ;* Letter N      = $0E
        FCB     %00110001       ;* Letter N      = $0E
;                 
        FCB     %00110011       ;* Letter O      = $0F
        FCB     %10100011       ;* Letter O      = $0F
        FCB     %00011000       ;* Letter O      = $0F
        FCB     %11000110       ;* Letter O      = $0F
        FCB     %00101110       ;* Letter O      = $0F
;                 
        FCB     %00110111       ;* Letter P      = $10
        FCB     %10100011       ;* Letter P      = $10
        FCB     %00011111       ;* Letter P      = $10
        FCB     %01000010       ;* Letter P      = $10
        FCB     %00010000       ;* Letter P      = $10
;                 
        FCB     %00110011       ;* Letter Q      = $11
        FCB     %10100011       ;* Letter Q      = $11
        FCB     %00011000       ;* Letter Q      = $11
        FCB     %11010110       ;* Letter Q      = $11
        FCB     %01001101       ;* Letter Q      = $11
;                 
        FCB     %00110111       ;* Letter R      = $12
        FCB     %10100011       ;* Letter R      = $12



        FCB     %00011111       ;* Letter R      = $12
        FCB     %01010010       ;* Letter R      = $12
        FCB     %01010001       ;* Letter R      = $12
;                 
        FCB     %00110011       ;* Letter S      = $13
        FCB     %10100011       ;* Letter S      = $13
        FCB     %00000111       ;* Letter S      = $13
        FCB     %00000110       ;* Letter S      = $13
        FCB     %00101110       ;* Letter S      = $13
;                 
        FCB     %00110111       ;* Letter T      = $14
        FCB     %11101010       ;* Letter T      = $14
        FCB     %01000010       ;* Letter T      = $14
        FCB     %00010000       ;* Letter T      = $14
        FCB     %10000100       ;* Letter T      = $14
;                 
        FCB     %00110100       ;* Letter U      = $15
        FCB     %01100011       ;* Letter U      = $15
        FCB     %00011000       ;* Letter U      = $15
        FCB     %11000110       ;* Letter U      = $15
        FCB     %00101110       ;* Letter U      = $15
;                 
        FCB     %00110100       ;* Letter V      = $16
        FCB     %01100011       ;* Letter V      = $16
        FCB     %00010101       ;* Letter V      = $16
        FCB     %00101000       ;* Letter V      = $16
        FCB     %10000100       ;* Letter V      = $16
;                 
        FCB     %00110100       ;* Letter W      = $17
        FCB     %01100011       ;* Letter W      = $17
        FCB     %00011010       ;* Letter W      = $17
        FCB     %11010111       ;* Letter W      = $17
        FCB     %01110001       ;* Letter W      = $17
;                 
        FCB     %00110100       ;* Letter X      = $18
        FCB     %01100010       ;* Letter X      = $18
        FCB     %10100010       ;* Letter X      = $18
        FCB     %00101010       ;* Letter X      = $18
        FCB     %00110001       ;* Letter X      = $18
;                 
        FCB     %00110100       ;* Letter Y      = $19
        FCB     %01100010       ;* Letter Y      = $19
        FCB     %10100010       ;* Letter Y      = $19
        FCB     %00010000       ;* Letter Y      = $19
        FCB     %10000100       ;* Letter Y      = $19
;                 
        FCB     %00110111       ;* Letter Z      = $1A
        FCB     %11000010       ;* Letter Z      = $1A
        FCB     %00100010       ;* Letter Z      = $1A
        FCB     %00100010       ;* Letter Z      = $1A
        FCB     %00011111       ;* Letter Z      = $1A
;                 
        FCB     %00110001       ;* Exclamation point       Code = $1B
        FCB     %00001000       ;* Exclamation point       Code = $1B
        FCB     %01000010       ;* Exclamation point       Code = $1B
        FCB     %00010000       ;* Exclamation point       Code = $1B



        FCB     %00000100       ;* Exclamation point       Code = $1B
;                 
        FCB     %00110000       ;* Underline     = $1C
        FCB     %00000000       ;* Underline     = $1C
        FCB     %00000000       ;* Underline     = $1C
        FCB     %00000000       ;* Underline     = $1C
        FCB     %00011111       ;* Underline     = $1C
;                 
        FCB     %00110011       ;* Question Mark = $1D
        FCB     %10100010       ;* Question Mark = $1D
        FCB     %00010011       ;* Question Mark = $1D
        FCB     %00010000       ;* Question Mark = $1D
        FCB     %00000100       ;* Question Mark = $1D
;                 
        FCB     %00110000       ;* Period        = $1E
        FCB     %00000000       ;* Period        = $1E
        FCB     %00000000       ;* Period        = $1E
        FCB     %00000000       ;* Period        = $1E
        FCB     %00000100       ;* Period        = $1E
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S P E C I A L   C H A R A C T E R   T A B L E
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The following table entries contain bit patterns
;  used in making up special figures.
;
SPCTAB  EQU     *
;
;  Small Heart Left    Code = $20
;
        FCB     %00000000
        FCB     %00000000
        FCB     %00000001
        FCB     %00000001
        FCB     %00000000
        FCB     %00000000
        FCB     %00000000
;
;  Small Heart Right    Code = $21
;
        FCB     %00000000
        FCB     %10100000
        FCB     %11110000
        FCB     %11110000
        FCB     %11100000
        FCB     %01000000
        FCB     %00000000
;
;  Large Heart Left    Code = $22
;
        FCB     %00000000
        FCB     %00000001
        FCB     %00000011
        FCB     %00000011
        FCB     %00000001
        FCB     %00000000
        FCB     %00000000
;
;  Large Heart Right    Code = $23
;
        FCB     %00000000
        FCB     %10110000
        FCB     %11111000
        FCB     %11111000
        FCB     %11110000
        FCB     %11100000
        FCB     %01000000
;
;;;;;        END
;
;
;
THUDD   FDB     $0080           ;
        FDB     $0001           ;
;



        FDB     $0050           ;
        FDB     $0004           ;
;
BANGD   FDB     $0050           ;
        FDB     $0005           ;
;
FLATAB  EQU     *               ;beginning of table
;
        FCB     3               ;left
        FDB     LPASAG          ;passage
        FDB     LDOOR           ;door
        FDB     LSDOOR          ;secret door
        FDB     LWALL           ;wall
;
        FCB     0               ;forward
        FDB     FPASAG          ;passage
        FDB     FDOOR           ;door
        FDB     FSDOOR          ;secret door
        FDB     FWALL           ;wall
;
        FCB     1               ;right
        FDB     RPASAG          ;passage
        FDB     RDOOR           ;door
        FDB     RSDOOR          ;secret door
        FDB     RWALL           ;wall
;
        FCB     -1              ;end of table
;
;
;