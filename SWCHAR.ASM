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
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
        FCB     %00000000       ; space
;
        FCB     %00010000       ; !
        FCB     %00010000       ; !
        FCB     %00010000       ; !
        FCB     %00010000       ; !
        FCB     %00010000       ; !
        FCB     %00000000       ; !
        FCB     %00010000       ; !
        FCB     %00000000       ; !
;
        FCB     %00101000       ; "
        FCB     %00101000       ; "
        FCB     %00101000       ; "
        FCB     %00000000       ; "
        FCB     %00000000       ; "
        FCB     %00000000       ; "
        FCB     %00000000       ; "
        FCB     %00000000       ; "
;
        FCB     %00101000       ; #
        FCB     %00101000       ; #
        FCB     %01111100       ; #
        FCB     %00101000       ; #
        FCB     %01111100       ; #
        FCB     %00101000       ; #
        FCB     %00101000       ; #
        FCB     %00000000       ; #
;
        FCB     %00010000       ; $
        FCB     %00111100       ; $
        FCB     %01010000       ; $
        FCB     %00111000       ; $
        FCB     %00010100       ; $
        FCB     %01111011       ; $  FIXME last two 1s should be 0s
        FCB     %00010000       ; $
        FCB     %00000000       ; $
;
        FCB     %01100000       ; %
        FCB     %01100100       ; %
        FCB     %00001000       ; %
        FCB     %00010000       ; %
        FCB     %00100000       ; %
        FCB     %01001100       ; %
        FCB     %00001100       ; %
        FCB     %00000000       ; %
;
        FCB     %00100000       ; &
        FCB     %01010000       ; &
        FCB     %01010000       ; &
        FCB     %00100000       ; &
        FCB     %01010100       ; &
        FCB     %01001000       ; &
        FCB     %00110100       ; &
        FCB     %00000000       ; &
;
        FCB     %00010000       ; '
        FCB     %00010000       ; '
        FCB     %00010000       ; '
        FCB     %00000000       ; '
        FCB     %00000000       ; '
        FCB     %00000000       ; '
        FCB     %00000000       ; '
        FCB     %00000000       ; '
;
        FCB     %00001000       ; (
        FCB     %00010000       ; (
        FCB     %00100000       ; (
        FCB     %00100000       ; (
        FCB     %00100000       ; (
        FCB     %00010000       ; (
        FCB     %00001000       ; (
        FCB     %00000000       ; (
;
        FCB     %00100000       ; )
        FCB     %00010000       ; )
        FCB     %00001000       ; )
        FCB     %00001000       ; )
        FCB     %00001000       ; )
        FCB     %00010000       ; )
        FCB     %00100000       ; )
        FCB     %00000000       ; )
;
        FCB     %00000000       ; *
        FCB     %00010000       ; *
        FCB     %01010100       ; *
        FCB     %00111000       ; *
        FCB     %00111000       ; *
        FCB     %01010100       ; *
        FCB     %00010000       ; *
        FCB     %00000000       ; *
;
        FCB     %00000000       ; +
        FCB     %00010000       ; +
        FCB     %00010000       ; +
        FCB     %01111100       ; +
        FCB     %00010000       ; +
        FCB     %00010000       ; +
        FCB     %00000000       ; +
        FCB     %00000000       ; +
;
        FCB     %00000000       ; ,
        FCB     %00000000       ; ,
        FCB     %00000000       ; ,
        FCB     %00000000       ; ,
        FCB     %00000000       ; ,
        FCB     %00010000       ; ,
        FCB     %00010000       ; ,
        FCB     %00100000       ; ,
;
        FCB     %00000000       ; -
        FCB     %00000000       ; -
        FCB     %00000000       ; -
        FCB     %01111100       ; -
        FCB     %00000000       ; -
        FCB     %00000000       ; -
        FCB     %00000000       ; -
        FCB     %00000000       ; -
;
        FCB     %00000000       ; .
        FCB     %00000000       ; .
        FCB     %00000000       ; .
        FCB     %00000000       ; .
        FCB     %00000000       ; .
        FCB     %00000000       ; .
        FCB     %00010000       ; .
        FCB     %00000000       ; .
;
        FCB     %00000000       ; /
        FCB     %00000100       ; /
        FCB     %00001000       ; /
        FCB     %00010000       ; /
        FCB     %00100000       ; /
        FCB     %01000000       ; /
        FCB     %00000000       ; /
        FCB     %00000000       ; /
;
        FCB     %00111000       ; 0
        FCB     %01000100       ; 0
        FCB     %01001100       ; 0
        FCB     %01010100       ; 0
        FCB     %01100100       ; 0
        FCB     %01000100       ; 0
        FCB     %00111000       ; 0
        FCB     %00000000       ; 0
;
        FCB     %00010000       ; 1
        FCB     %00110000       ; 1
        FCB     %00010000       ; 1
        FCB     %00010000       ; 1
        FCB     %00010000       ; 1
        FCB     %00010000       ; 1
        FCB     %00111000       ; 1
        FCB     %00000000       ; 1
;
        FCB     %00111000       ; 2
        FCB     %01000100       ; 2
        FCB     %00000100       ; 2
        FCB     %00111000       ; 2
        FCB     %01000000       ; 2
        FCB     %01000000       ; 2
        FCB     %01111100       ; 2
        FCB     %00000000       ; 2
;
        FCB     %00111000       ; 3
        FCB     %01000100       ; 3
        FCB     %00000100       ; 3
        FCB     %00001000       ; 3
        FCB     %00000100       ; 3
        FCB     %01000100       ; 3
        FCB     %00111000       ; 3
        FCB     %00000000       ; 3
;
        FCB     %00001000       ; 4
        FCB     %00011000       ; 4
        FCB     %00101000       ; 4
        FCB     %01001000       ; 4
        FCB     %01111100       ; 4
        FCB     %00001000       ; 4
        FCB     %00001000       ; 4
        FCB     %10010000       ; 4  FIXME should be all zeroes
;
        FCB     %01111100       ; 5
        FCB     %01000000       ; 5
        FCB     %01111000       ; 5
        FCB     %00000100       ; 5
        FCB     %00000100       ; 5
        FCB     %01000100       ; 5
        FCB     %00111000       ; 5
        FCB     %00000000       ; 5
;
        FCB     %00111000       ; 6
        FCB     %01000000       ; 6
        FCB     %01000000       ; 6
        FCB     %01111000       ; 6
        FCB     %01000100       ; 6
        FCB     %01000100       ; 6
        FCB     %00111000       ; 6
        FCB     %00000000       ; 6
;
        FCB     %01111100       ; 7
        FCB     %00000100       ; 7
        FCB     %00001000       ; 7
        FCB     %00010000       ; 7
        FCB     %00100000       ; 7
        FCB     %01000000       ; 7
        FCB     %01000000       ; 7
        FCB     %00000000       ; 7
;
        FCB     %00111000       ; 8
        FCB     %01000100       ; 8
        FCB     %01000100       ; 8
        FCB     %00111000       ; 8
        FCB     %01000100       ; 8
        FCB     %01000100       ; 8
        FCB     %00111000       ; 8
        FCB     %00000000       ; 8
;
        FCB     %00111000       ; 9
        FCB     %01000100       ; 9
        FCB     %01000100       ; 9
        FCB     %00111000       ; 9
        FCB     %00000100       ; 9
        FCB     %00000100       ; 9
        FCB     %00111000       ; 9
        FCB     %00000000       ; 9
;
        FCB     %00000000       ; :
        FCB     %00000000       ; :
        FCB     %00010000       ; :
        FCB     %00000000       ; :
        FCB     %00000000       ; :
        FCB     %00010000       ; :
        FCB     %00000000       ; :
        FCB     %00000000       ; :
;
        FCB     %00000000       ; ;
        FCB     %00000000       ; ;
        FCB     %00010000       ; ;
        FCB     %00000000       ; ;
        FCB     %00000000       ; ;
        FCB     %00010000       ; ;
        FCB     %00010000       ; ;
        FCB     %00100000       ; ;
;
        FCB     %00001000       ; <
        FCB     %00010000       ; <
        FCB     %00100000       ; <
        FCB     %01000000       ; <
        FCB     %00100000       ; <
        FCB     %00010000       ; <
        FCB     %00001000       ; <
        FCB     %00000000       ; <
;
        FCB     %00000000       ; =
        FCB     %00000000       ; =
        FCB     %01111100       ; =
        FCB     %00000000       ; =
        FCB     %01111100       ; =
        FCB     %00000000       ; =
        FCB     %00000000       ; =
        FCB     %00000000       ; =
;
        FCB     %00100000       ; >
        FCB     %00010000       ; >
        FCB     %00001000       ; >
        FCB     %00000100       ; >
        FCB     %00001000       ; >
        FCB     %00010000       ; >
        FCB     %00100000       ; >
        FCB     %00000000       ; >
;
        FCB     %00111000       ; ?
        FCB     %01000100       ; ?
        FCB     %00000100       ; ?
        FCB     %00011000       ; ?
        FCB     %00010000       ; ?
        FCB     %00000000       ; ?
        FCB     %00010000       ; ?
        FCB     %00000000       ; ?
;
        FCB     %00111000       ; @
        FCB     %01000100       ; @
        FCB     %00000100       ; @
        FCB     %00110100       ; @
        FCB     %01001100       ; @
        FCB     %01001100       ; @
        FCB     %00111000       ; @
        FCB     %00000000       ; @
;
        FCB     %00010000       ; A
        FCB     %00101000       ; A
        FCB     %01000100       ; A
        FCB     %01000100       ; A
        FCB     %01111100       ; A
        FCB     %01000100       ; A
        FCB     %01000100       ; A
        FCB     %00000000       ; A
;
        FCB     %01111000       ; B
        FCB     %01000100       ; B
        FCB     %01000100       ; B
        FCB     %01111000       ; B
        FCB     %01000100       ; B
        FCB     %01000100       ; B
        FCB     %01111000       ; B
        FCB     %00000000       ; B
;
        FCB     %00111000       ; C
        FCB     %01000100       ; C
        FCB     %01000000       ; C
        FCB     %01000000       ; C
        FCB     %01000000       ; C
        FCB     %01000100       ; C
        FCB     %00111000       ; C
        FCB     %00000000       ; C
;
        FCB     %01111000       ; D
        FCB     %01000100       ; D
        FCB     %01000100       ; D
        FCB     %01000100       ; D
        FCB     %01000100       ; D
        FCB     %01000100       ; D
        FCB     %01111000       ; D
        FCB     %00000000       ; D
;
        FCB     %01111100       ; E
        FCB     %01000000       ; E
        FCB     %01000000       ; E
        FCB     %01111000       ; E
        FCB     %01000000       ; E
        FCB     %01000000       ; E
        FCB     %01111100       ; E
        FCB     %00000000       ; E
;
        FCB     %01111100       ; F
        FCB     %01000000       ; F
        FCB     %01000000       ; F
        FCB     %01111000       ; F
        FCB     %01000000       ; F
        FCB     %01000000       ; F
        FCB     %01000000       ; F
        FCB     %00000000       ; F
;
        FCB     %00111100       ; G
        FCB     %01000100       ; G
        FCB     %01000000       ; G
        FCB     %01000000       ; G
        FCB     %01001100       ; G
        FCB     %01000100       ; G
        FCB     %00111100       ; G
        FCB     %00000000       ; G
;
        FCB     %01000100       ; H
        FCB     %01000100       ; H
        FCB     %01000100       ; H
        FCB     %01111100       ; H
        FCB     %01000100       ; H
        FCB     %01000100       ; H
        FCB     %01000100       ; H
        FCB     %00000000       ; H
;
        FCB     %00111000       ; I
        FCB     %00010000       ; I
        FCB     %00010000       ; I
        FCB     %00010000       ; I
        FCB     %00010000       ; I
        FCB     %00010000       ; I
        FCB     %00111000       ; I
        FCB     %00000000       ; I
;
        FCB     %00000100       ; J
        FCB     %00000100       ; J
        FCB     %00000100       ; J
        FCB     %00000100       ; J
        FCB     %00000100       ; J
        FCB     %01000100       ; J
        FCB     %00111000       ; J
        FCB     %00000000       ; J
;
        FCB     %01000100       ; K
        FCB     %01001000       ; K
        FCB     %01010000       ; K
        FCB     %01100000       ; K
        FCB     %01010000       ; K
        FCB     %01001000       ; K
        FCB     %01000100       ; K
        FCB     %00000000       ; K
;
        FCB     %01000000       ; L
        FCB     %01000000       ; L
        FCB     %01000000       ; L
        FCB     %01000000       ; L
        FCB     %01000000       ; L
        FCB     %01000000       ; L
        FCB     %01111100       ; L
        FCB     %00000000       ; L
;
        FCB     %01000100       ; M
        FCB     %01101100       ; M
        FCB     %01010100       ; M
        FCB     %01010100       ; M
        FCB     %01010100       ; M
        FCB     %01000100       ; M
        FCB     %01000100       ; M
        FCB     %00000000       ; M
;
        FCB     %01000100       ; N
        FCB     %01000100       ; N
        FCB     %01100100       ; N
        FCB     %01010100       ; N
        FCB     %01001100       ; N
        FCB     %01000100       ; N
        FCB     %01000100       ; N
        FCB     %00000000       ; N
;
        FCB     %00111000       ; O
        FCB     %01000100       ; O
        FCB     %01000100       ; O
        FCB     %01000100       ; O
        FCB     %01000100       ; O
        FCB     %01000100       ; O
        FCB     %00111000       ; O
        FCB     %00000000       ; O
;
        FCB     %01111000       ; P
        FCB     %01000100       ; P
        FCB     %01000100       ; P
        FCB     %01111000       ; P
        FCB     %01000000       ; P
        FCB     %01000000       ; P
        FCB     %01000000       ; P
        FCB     %00000000       ; P
;
        FCB     %00111000       ; Q
        FCB     %01000100       ; Q
        FCB     %01000100       ; Q
        FCB     %01000100       ; Q
        FCB     %01010100       ; Q
        FCB     %01001000       ; Q
        FCB     %00110100       ; Q
        FCB     %00000000       ; Q
;
        FCB     %01111000       ; R
        FCB     %01000100       ; R
        FCB     %01000100       ; R
        FCB     %01111000       ; R
        FCB     %01010000       ; R
        FCB     %01001000       ; R
        FCB     %01000100       ; R
        FCB     %00000000       ; R
;
        FCB     %00111000       ; S
        FCB     %01000100       ; S
        FCB     %01000000       ; S
        FCB     %00111000       ; S
        FCB     %00000100       ; S
        FCB     %01000100       ; S
        FCB     %00111000       ; S
        FCB     %00000000       ; S
;
        FCB     %01111100       ; T
        FCB     %01010100       ; T
        FCB     %00010000       ; T
        FCB     %00010000       ; T
        FCB     %00010000       ; T
        FCB     %00010000       ; T
        FCB     %00010000       ; T
        FCB     %00000000       ; T
;
        FCB     %01000100       ; U
        FCB     %01000100       ; U
        FCB     %01000100       ; U
        FCB     %01000100       ; U
        FCB     %01000100       ; U
        FCB     %01000100       ; U
        FCB     %00111000       ; U
        FCB     %00000000       ; U
;
        FCB     %01000100       ; V
        FCB     %01000100       ; V
        FCB     %01000100       ; V
        FCB     %00101000       ; V
        FCB     %00101000       ; V
        FCB     %00010000       ; V
        FCB     %00010000       ; V
        FCB     %00000000       ; V
;
        FCB     %01000100       ; W
        FCB     %01000100       ; W
        FCB     %01000100       ; W
        FCB     %01010100       ; W
        FCB     %01010100       ; W
        FCB     %01101100       ; W
        FCB     %01000100       ; W
        FCB     %00000000       ; W
;
        FCB     %01000100       ; X
        FCB     %01000100       ; X
        FCB     %00101000       ; X
        FCB     %00010000       ; X
        FCB     %00101000       ; X
        FCB     %01000100       ; X
        FCB     %01000100       ; X
        FCB     %00000000       ; X
;
        FCB     %01000100       ; Y
        FCB     %01000100       ; Y
        FCB     %00101000       ; Y
        FCB     %00010000       ; Y
        FCB     %00010000       ; Y
        FCB     %00010000       ; Y
        FCB     %00010000       ; Y
        FCB     %00000000       ; Y
;
        FCB     %01111100       ; Z
        FCB     %00000100       ; Z
        FCB     %00001000       ; Z
        FCB     %00010000       ; Z
        FCB     %00100000       ; Z
        FCB     %01000000       ; Z
        FCB     %01111100       ; Z
        FCB     %00000000       ; Z
;
        FCB     %00111000       ; [
        FCB     %00100000       ; [
        FCB     %00100000       ; [
        FCB     %00100000       ; [
        FCB     %00100000       ; [
        FCB     %00100000       ; [
        FCB     %00111000       ; [
        FCB     %00000000       ; [
;
        FCB     %00000000       ; \
        FCB     %01000000       ; \
        FCB     %00100000       ; \
        FCB     %00010000       ; \
        FCB     %00001000       ; \
        FCB     %00000100       ; \
        FCB     %00000000       ; \
        FCB     %00000000       ; \
;
        FCB     %00111000       ; ]
        FCB     %00001000       ; ]
        FCB     %00001000       ; ]
        FCB     %00001000       ; ]
        FCB     %00001000       ; ]
        FCB     %00001000       ; ]
        FCB     %00111000       ; ]
        FCB     %00000000       ; ]
;
        FCB     %00010000       ; ^
        FCB     %00111000       ; ^
        FCB     %01010100       ; ^
        FCB     %00000000       ; ^
        FCB     %00000000       ; ^
        FCB     %00000000       ; ^
        FCB     %00000000       ; ^
        FCB     %00000000       ; ^
;
        FCB     %00000000       ; _
        FCB     %00000000       ; _
        FCB     %00000000       ; _
        FCB     %00000000       ; _
        FCB     %00000000       ; _
        FCB     %00000000       ; _
        FCB     %01111100       ; _
        FCB     %00000000       ; _
;
        FCB     %00010000       ; `
        FCB     %00010000       ; `
        FCB     %00001000       ; `
        FCB     %00000000       ; `
        FCB     %00000000       ; `
        FCB     %00000000       ; `
        FCB     %00000000       ; `
        FCB     %00000000       ; `
;
        FCB     %00000000       ; a
        FCB     %00000000       ; a
        FCB     %00111000       ; a
        FCB     %00000100       ; a
        FCB     %00111100       ; a
        FCB     %01000100       ; a
        FCB     %00111100       ; a
        FCB     %00000000       ; a
;
        FCB     %01000000       ; b
        FCB     %01000000       ; b
        FCB     %01011000       ; b
        FCB     %01100100       ; b
        FCB     %01000100       ; b
        FCB     %01100100       ; b
        FCB     %01011000       ; b
        FCB     %00000000       ; b
;
        FCB     %00000000       ; c
        FCB     %00000000       ; c
        FCB     %00111000       ; c
        FCB     %01000100       ; c
        FCB     %01000000       ; c
        FCB     %01000100       ; c
        FCB     %00111000       ; c
        FCB     %00000000       ; c
;
        FCB     %00000100       ; d
        FCB     %00000100       ; d
        FCB     %00110100       ; d
        FCB     %01001100       ; d
        FCB     %01000100       ; d
        FCB     %01001100       ; d
        FCB     %00110100       ; d
        FCB     %00000000       ; d
;
        FCB     %00000000       ; e
        FCB     %00000000       ; e
        FCB     %00111000       ; e
        FCB     %01000100       ; e
        FCB     %01111100       ; e
        FCB     %01000000       ; e
        FCB     %00111000       ; e
        FCB     %00000000       ; e
;
        FCB     %00001000       ; f
        FCB     %00010100       ; f
        FCB     %00010000       ; f
        FCB     %00111000       ; f
        FCB     %00010000       ; f
        FCB     %00010000       ; f
        FCB     %00010000       ; f
        FCB     %00000000       ; f
;
        FCB     %00000000       ; g
        FCB     %00000000       ; g
        FCB     %00110100       ; g
        FCB     %01001100       ; g
        FCB     %01001100       ; g
        FCB     %00110100       ; g
        FCB     %00000100       ; g
        FCB     %00111000       ; g
;
        FCB     %01000000       ; h
        FCB     %01000000       ; h
        FCB     %01011000       ; h
        FCB     %01100100       ; h
        FCB     %01000100       ; h
        FCB     %01000100       ; h
        FCB     %01000100       ; h
        FCB     %00000000       ; h
;
        FCB     %00000000       ; i
        FCB     %00010000       ; i
        FCB     %00000000       ; i
        FCB     %00010000       ; i
        FCB     %00010000       ; i
        FCB     %00010000       ; i
        FCB     %00111000       ; i
        FCB     %00000000       ; i
;
        FCB     %00000000       ; j
        FCB     %00000100       ; j
        FCB     %00000000       ; j
        FCB     %00000100       ; j
        FCB     %00000100       ; j
        FCB     %00000100       ; j
        FCB     %01000100       ; j
        FCB     %00111000       ; j
;
        FCB     %01000000       ; k
        FCB     %01000000       ; k
        FCB     %01001000       ; k
        FCB     %01010000       ; k
        FCB     %01100000       ; k
        FCB     %01010000       ; k
        FCB     %01001000       ; k
        FCB     %00000000       ; k
;
        FCB     %00110000       ; l
        FCB     %00010000       ; l
        FCB     %00010000       ; l
        FCB     %00010000       ; l
        FCB     %00010000       ; l
        FCB     %00010000       ; l
        FCB     %00111000       ; l
        FCB     %00000000       ; l
;
        FCB     %00000000       ; m
        FCB     %00000000       ; m
        FCB     %01101000       ; m
        FCB     %01010100       ; m
        FCB     %01010100       ; m
        FCB     %01010100       ; m
        FCB     %01010100       ; m
        FCB     %00000000       ; m
;
        FCB     %00000000       ; n
        FCB     %00000000       ; n
        FCB     %01011000       ; n
        FCB     %01100100       ; n
        FCB     %01000100       ; n
        FCB     %01000100       ; n
        FCB     %01000100       ; n
        FCB     %00000000       ; n
;
        FCB     %00000000       ; o
        FCB     %00000000       ; o
        FCB     %00111000       ; o
        FCB     %01000100       ; o
        FCB     %01000100       ; o
        FCB     %01000100       ; o
        FCB     %00111000       ; o
        FCB     %00000000       ; o
;
        FCB     %00000000       ; p
        FCB     %00000000       ; p
        FCB     %01111000       ; p
        FCB     %01000100       ; p
        FCB     %01000100       ; p
        FCB     %01111000       ; p
        FCB     %01000000       ; p
        FCB     %01000000       ; p
;
        FCB     %00000000       ; q
        FCB     %00000000       ; q
        FCB     %00111100       ; q
        FCB     %01000100       ; q
        FCB     %01000100       ; q
        FCB     %00111100       ; q
        FCB     %00000100       ; q
        FCB     %00000100       ; q
;
        FCB     %00000000       ; r
        FCB     %00000000       ; r
        FCB     %01011000       ; r
        FCB     %01100100       ; r
        FCB     %01000000       ; r
        FCB     %01000000       ; r
        FCB     %01000000       ; r
        FCB     %00000000       ; r
;
        FCB     %00000000       ; s
        FCB     %00000000       ; s
        FCB     %00111100       ; s
        FCB     %01000000       ; s
        FCB     %00111000       ; s
        FCB     %00000100       ; s
        FCB     %01111000       ; s
        FCB     %00000000       ; s
;
        FCB     %00100000       ; t
        FCB     %00100000       ; t
        FCB     %01110000       ; t
        FCB     %01110000       ; t
        FCB     %01110000       ; t
        FCB     %00100100       ; t
        FCB     %00011000       ; t
        FCB     %00000000       ; t
;
        FCB     %00000000       ; u
        FCB     %00000000       ; u
        FCB     %01000100       ; u
        FCB     %01000100       ; u
        FCB     %01000100       ; u
        FCB     %01001100       ; u
        FCB     %00110100       ; u
        FCB     %00000000       ; u
;
        FCB     %00000000       ; v
        FCB     %00000000       ; v
        FCB     %01000100       ; v
        FCB     %01000100       ; v
        FCB     %01000100       ; v
        FCB     %00101000       ; v
        FCB     %00010000       ; v
        FCB     %00000000       ; v
;
        FCB     %00000000       ; w
        FCB     %00000000       ; w
        FCB     %01000100       ; w
        FCB     %01010100       ; w
        FCB     %01010100       ; w
        FCB     %00101000       ; w
        FCB     %00101000       ; w
        FCB     %00000000       ; w
;
        FCB     %00000000       ; x
        FCB     %00000000       ; x
        FCB     %01000100       ; x
        FCB     %00101000       ; x
        FCB     %00010000       ; x
        FCB     %00101000       ; x
        FCB     %01000100       ; x
        FCB     %00000000       ; x
;
        FCB     %00000000       ; y
        FCB     %00000000       ; y
        FCB     %01000100       ; y
        FCB     %01000100       ; y
        FCB     %01000100       ; y
        FCB     %00111100       ; y
        FCB     %00000100       ; y
        FCB     %00111000       ; y
;
        FCB     %00000000       ; z
        FCB     %00000000       ; z
        FCB     %01111100       ; z
        FCB     %00001000       ; z
        FCB     %00010000       ; z
        FCB     %00100000       ; z
        FCB     %01111100       ; z
        FCB     %00000000       ; z
;
        FCB     %00001000       ; {
        FCB     %00010000       ; {
        FCB     %00010000       ; {
        FCB     %00100000       ; {
        FCB     %00010000       ; {
        FCB     %00010000       ; {
        FCB     %00001000       ; {
        FCB     %00000000       ; {
;
        FCB     %00010000       ; |
        FCB     %00010000       ; |
        FCB     %00010000       ; |
        FCB     %00000000       ; |
        FCB     %00010000       ; |
        FCB     %00010000       ; |
        FCB     %00010000       ; |
        FCB     %00000000       ; |
;
        FCB     %00100000       ; }
        FCB     %00010000       ; }
        FCB     %00010000       ; }
        FCB     %00001000       ; }
        FCB     %00010000       ; }
        FCB     %00010000       ; }
        FCB     %00100000       ; }
        FCB     %00000000       ; }
;
        FCB     %00100000       ; ~
        FCB     %01010100       ; ~
        FCB     %00001000       ; ~
        FCB     %00000000       ; ~
        FCB     %00000000       ; ~
        FCB     %00000000       ; ~
        FCB     %00000000       ; ~
        FCB     %00000000       ; ~
;
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>
        FCB     %00000000       ; <no character code here - control character>



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S P E C I A L   C H A R A C T E R   T A B L E
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The following table entries contain bit patterns
;  used in making up special figures.
;
SPCTAB  EQU     *
;
        FCB     %00000000       ; char code 128 - left part of contracted heart
        FCB     %00000000       ; char code 128 - left part of contracted heart
        FCB     %00000001       ; char code 128 - left part of contracted heart
        FCB     %00000001       ; char code 128 - left part of contracted heart
        FCB     %00000000       ; char code 128 - left part of contracted heart
        FCB     %00000000       ; char code 128 - left part of contracted heart
        FCB     %00000000       ; char code 128 - left part of contracted heart
        FCB     %00000000       ; char code 128 - left part of contracted heart
;
        FCB     %00000000       ; char code 129 - right part of contracted heart
        FCB     %10100000       ; char code 129 - right part of contracted heart
        FCB     %11110000       ; char code 129 - right part of contracted heart
        FCB     %11110000       ; char code 129 - right part of contracted heart
        FCB     %11100000       ; char code 129 - right part of contracted heart
        FCB     %01000000       ; char code 129 - right part of contracted heart
        FCB     %00000000       ; char code 129 - right part of contracted heart
        FCB     %00000000       ; char code 129 - right part of contracted heart
;
        FCB     %00000000       ; char code 130 - left half of expanded heart
        FCB     %00000001       ; char code 130 - left half of expanded heart
        FCB     %00000011       ; char code 130 - left half of expanded heart
        FCB     %00000011       ; char code 130 - left half of expanded heart
        FCB     %00000001       ; char code 130 - left half of expanded heart
        FCB     %00000000       ; char code 130 - left half of expanded heart
        FCB     %00000000       ; char code 130 - left half of expanded heart
        FCB     %00000000       ; char code 130 - left half of expanded heart
;
        FCB     %00000000       ; char code 131 - right part of expanded heart
        FCB     %10110000       ; char code 131 - right part of expanded heart
        FCB     %11111000       ; char code 131 - right part of expanded heart
        FCB     %11111000       ; char code 131 - right part of expanded heart
        FCB     %11110000       ; char code 131 - right part of expanded heart
        FCB     %11100000       ; char code 131 - right part of expanded heart
        FCB     %01000000       ; char code 131 - right part of expanded heart
        FCB     %00000000       ; char code 131 - right part of expanded heart
;
        FCB     %01111000       ; char code 132 - copyright symbol
        FCB     %10000100       ; char code 132 - copyright symbol
        FCB     %10110100       ; char code 132 - copyright symbol
        FCB     %10100100       ; char code 132 - copyright symbol
        FCB     %10110100       ; char code 132 - copyright symbol
        FCB     %10000100       ; char code 132 - copyright symbol
        FCB     %01111000       ; char code 132 - copyright symbol
        FCB     %00000000       ; char code 132 - copyright symbol
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