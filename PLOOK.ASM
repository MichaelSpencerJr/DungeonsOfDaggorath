;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  L O O K   C O M M A N D
;!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  PLOOK: Forward Looking View
;
INIVUX  SWI                     ;clear the status line
        FCB     CLRSTS          ;   .
        SWI                     ;clear the primary text area
        FCB     CLRPRI          ;   .
        SWI                     ;calculate the heartrate
        FCB     HUPDAT          ;   .
        INC     HEARTC          ;insure immediate flash
        DEC     HEARTF          ;turn on visual flash
        DEC     HBEATF          ;turn on audio thump
        SWI                     ;update the status line
        FCB     STATUS          ;   .
;
PLOOK   LDX     #VIEWER         ;forward looking display
        STX     DSPMOD          ;   .
        SWI                     ;update the screen
        FCB     PUPDAT          ;   .
        RTS                     ;exit
;
;;;;;        END
