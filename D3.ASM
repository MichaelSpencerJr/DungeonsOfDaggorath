;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   V E C T O R   L I S T S   ( I )
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     D3      - Creature Vector Lists (I)
;     LIBRY  CD
;
;        XDEF    SGINT1,SGINT2,BALROG,BLOB
;        XDEF    WRAITH,SPIDER,SCORP
;        OPT     NOMEX,NOGEN
;        DSCT
;
; Stone Giant 1 - Club
;
SGINT1  SVORG   104,98          ;top of club handle at hand
        SVECT   98,112
        SVECT   92,120
        SVECT   94,128
        SVECT   96,132
        SVECT   102,132         ;meet leg
        SVECT   104,126
        SVECT   104,120
        SVECT   102,114
        SVECT   106,100         ;bottom of club handle at hand
        SVNEW
        FCB     V$JMP           ;chain to sgiant
        FDB     SGIANT          ;remainder of Stone Giant
;
; Stone Giant 2 - Axe
;
SGINT2  FCB     104,98          ;top upper axe handle at hand
        FCB     94,124
        FCB     96,126
        FCB     106,100         ;lower upper axe handle
        FCB     V$NEW
;
        FCB     102,132         ;top of axe blade
        FCB     92,114          ;back tip
        FCB     102,118         ;lower bend
        FCB     110,114         ;bottom of blade
;
;                               ;SGINT2 falls thru to SGIANT
;
SGIANT  SVORG   102,132         ;left leg (at club or axe)
        SVECT   102,136
        SVECT   112,148
        SVECT   122,160         ;left heel
        SVECT   124,174
        SVECT   120,170
        SVECT   120,174



        SVECT   116,162         ;left upper ankle
        SVECT   106,152
        SVECT   96,142          ;left knee
        SVECT   92,130
        SVECT   88,118          ;left thigh at arm
        SVNEW
;
; face
;
        SVORG   78,92
        SVECT   70,96
        SVECT   80,98
        SVECT   86,94
        SVECT   78,92
        SVECT   76,84
        SVECT   84,88
        SVECT   86,94
        SVNEW
;
; bottom of club/axe handle and right leg
;
        SVORG   106,90
        SVECT   108,86
        SVECT   110,88
        SVECT   108,94
;
        SVECT   120,98
        SVECT   126,84
        SVECT   122,88
        SVECT   122,80
        SVECT   118,88
        SVECT   102,76
        SVECT   98,80
        SVNEW
;
; arm and head
;
        SVORG   86,84
        SVECT   96,92
        SVECT   108,102
        SVECT   112,98



        SVECT   104,86
        SVECT   94,74
        SVECT   82,76
        SVECT   76,84
        SVECT   72,80
        SVECT   74,84
        SVECT   68,88
        SVECT   70,94
        SVECT   66,96
        SVECT   70,96
        SVECT   68,108
        SVECT   72,116
        SVECT   86,120
        SVECT   96,104
        SVECT   92,100
        SVECT   84,110
        SVECT   74,106
        SVEND
;
; End of Stone-Giant vector list
;
; * * * * * * * * *



;
; Balrog vector list
;
; Outside legs, wings, underside of arms,
;    and bottom "V" of torso
;
BALROG  FCB     80,124          ;top of right leg at body
        FCB     94,114          ;right knee
        FCB     110,120         ;right ankle
        FCB     132,112         ;right toe
        FCB     104,78          ;right wing
        FCB     132,48
        FCB     68,72
        FCB     84,32
        FCB     22,88           ;bottom tip of right hand
        FCB     52,114          ;right armpit
        FCB     92,128          ;crotch
        FCB     52,142          ;left armpit
        FCB     22,168          ;bottom tip of left hand
        FCB     88,224          ;left wing
        FCB     68,184
        FCB     132,208
        FCB     112,178
        FCB     132,144         ;left toe
        FCB     110,136
        FCB     94,142
        FCB     80,132          ;top of left leg at body
        FCB     V$NEW
;
; Inside of legs
;
        SVORG   132,112
        SVECT   124,122
        SVECT   110,126
        SVECT   100,122
        SVECT   92,128
        SVECT   100,134
        SVECT   110,130
        SVECT   124,134
        SVECT   132,144
        SVNEW
;
; Tail
;
        SVORG   82,122
        SVECT   96,106
        SVECT   92,92
        SVECT   76,86
        SVECT   72,78
        SVECT   78,84
        SVECT   78,76
        SVECT   82,84
        SVECT   96,88
        SVECT   104,102
        SVECT   100,116



        SVNEW
;
; Arms and head
;
        SVORG   22,168
        SVECT   26,162
        SVECT   18,166
        SVECT   24,160
        SVECT   30,160
        SVECT   38,150
        SVECT   46,140
        SVECT   42,134
        SVECT   32,138
        SVECT   18,132
        SVECT   32,134
        SVECT   38,128
        SVECT   32,122
        SVECT   18,124
        SVECT   32,118
        SVECT   42,122
        SVECT   54,128
        SVECT   42,134
        SVECT   46,128
        SVECT   42,122
        SVECT   46,116
        SVECT   38,106
        SVECT   30,96
        SVECT   24,96
        SVECT   18,90
        SVECT   26,94
        SVECT   22,88
        SVEND
;
; End of Balrog vector list
;
; * * * * * * * * *



;
; Wraith vector list
;
; Eyebrows
;
WRAITH  FCB     62,68
        FCB     68,88
        FCB     56,100
        FCB     V$NEW
;
;  Eyes
;
        FCB     74,90           ;bridge of nose
        SVORG   70,74
        SVECT   76,80
        SVECT   74,90
        SVECT   72,100
        SVECT   64,102
        SVECT   74,90
        SVECT   86,94
        SVECT   86,90
        SVNEW
;
; Mouth
;
        SVORG   100,80
        SVECT   90,86
        SVECT   92,100
        SVECT   98,108
        SVECT   94,98
        SVECT   94,86
        SVECT   100,80
        SVEND
;
; End of Wraith vector list
;
; * * * * * * * * *



;
; Spider vector list
;
; Outside legs and body
;
SPIDER  SVORG   124,160
        SVECT   116,164
        SVECT   120,168
        SVECT   116,176
        SVECT   120,184
        SVECT   124,176
        SVECT   120,168
        SVECT   120,176
        SVECT   120,184
        SVECT   116,188
        SVECT   124,192
        SVNEW
;
; Inner legs and mouth
;
        SVORG   124,168
        SVECT   116,170
        SVECT   120,172
        SVECT   122,176
        SVECT   120,180
        SVECT   116,182
        SVECT   124,184
        SVEND
;
; End of Spider vector list
;
; * * * * * * * * *



;
; Scorpion vector list
;
; Tail, body, and back leg
;
SCORP   SVORG   112,74
        SVECT   108,74
        SVECT   104,70
        SVECT   108,62
        SVECT   116,66
        SVECT   118,74
        SVECT   120,82
        SVECT   124,82
        SVECT   124,74
        SVECT   116,66
        SVECT   120,70
        SVECT   120,62
        SVECT   124,66
        SVNEW
;
; Front legs
;
        SVORG   124,90
        SVECT   120,90
        SVECT   120,82
        SVECT   124,74
        SVECT   128,74
        SVECT   128,82
        SVEND
;
; End of Scorpion vector list
;
; * * * * * * * * *
;
; Blob vector list
;
BLOB    SVORG   82,130
        SVECT   86,114
        SVECT   100,108
        SVECT   110,106
        SVECT   120,106
        SVECT   130,96
        SVECT   128,106
        SVECT   132,104
        SVECT   126,114
        SVECT   128,128
        SVECT   130,142
        SVECT   128,148
        SVECT   132,152
        SVECT   128,154
        SVECT   130,162
        SVECT   124,156



        SVECT   108,154
        SVECT   92,148
        SVECT   86,138
        SVECT   82,130
        SVNEW
;
; Eyes
;
        SVORG   86,130
        SVECT   92,136
        SVECT   98,138
        SVECT   100,128
        SVECT   86,130
        SVECT   92,120
        SVECT   102,118
        SVECT   100,128
        SVNEW
;
; Mouth
;
        FCB     108,116
        FCB     114,118
        FCB     120,144
        FCB     V$END
;
; End of Blob vector list
;
; * * * * * * * * *
;;;;;        END
