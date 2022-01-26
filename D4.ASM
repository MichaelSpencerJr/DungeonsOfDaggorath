;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   V E C T O R   L I S T S   ( I I )
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        NAM     D4      - Creature Vector Lists (II)
;     LIBRY  CD
;
;        XDEF    KNIGT1,KNIGT2,VIPER
;        XDEF    WIZ0,WIZ1,WIZ2
;        OPT     NOMEX,NOGEN
;        DSCT
;
; Knight Type 1 - shield entry point (orange coding)
;
KNIGT1  SVORG   34,124
        SVECT   34,132
        SVECT   36,130
        SVECT   36,126
        SVECT   34,124
        SVNEW
;
        FCB     80,142          ;left arm
        FCB     64,136
        FCB     46,146
        FCB     64,156
        FCB     82,140
        FCB     76,136
        FCB     64,146
        FCB     58,140
        FCB     V$JMP
        FDB     KNIGHT
;
; Knight Type 2 - shield entry point (red coding)
KNIGT2  SVORG   30,126
        SVECT   40,126
        SVECT   40,124
        SVECT   36,124
        SVNEW
;
        FCB     44,150
        FCB     52,166
        FCB     76,164
        FCB     92,150
        FCB     76,136
        FCB     52,134
        FCB     44,150
        FCB     V$NEW
;
;                               ;falls thru to KNIGHT
;
; * * * * * * * * *


; * * * * * * * * *
;
; Knight's Main Body
;
; Left Leg
;
KNIGHT  FCB     80,140          ;outside of left leg
        FCB     128,152         ;outside of left ankle
        FCB     132,160         ;toe of left foot
        FCB     132,144         ;heel of left foot
        FCB     126,144         ;ankle of left foot
        FCB     84,130          ;to crotch
        FCB     V$NEW           ;start new sequence
;
; Right Leg
;
        FCB     84,126          ;crotch
        FCB     126,110         ;ankle
        FCB     132,110         ;heel
        FCB     132,92          ;toe
        FCB     128,102         ;outside of ankle
        FCB     80,116          ;to hip
        FCB     V$NEW           ;start new sequence
;
; Torso
;
        SVORG   80,140
        SVECT   86,128
        SVECT   80,114
        SVECT   64,120
        SVECT   58,116
        SVECT   46,110
        SVECT   42,122
        SVECT   30,124
        SVECT   26,128
        SVECT   30,132
        SVECT   42,134
        SVECT   46,146
        SVECT   42,134
        SVECT   46,134
        SVECT   52,128
        SVECT   46,122
        SVECT   42,122
        SVNEW
;
; Plume
;
        FCB     52,128          ;chin of helm
        SVORG   20,128
        SVECT   20,124
        SVECT   24,126
        SVECT   24,130
        SVECT   20,132
        SVECT   20,128
        SVNEW



;
; Sword Handle and Lower Arm
;
        SVORG   74,102
        SVECT   70,102
        SVECT   70,106
        SVECT   64,106
        SVECT   64,90
        SVECT   70,90
        SVECT   70,94
        SVECT   74,94
        SVECT   74,96
        SVECT   80,96
        SVECT   80,100
        SVECT   74,100
        SVECT   74,102
        SVECT   58,116
        SVNEW
;
; Upper Part of Arm and Sword Blade
;
        FCB     46,110
        FCB     64,102
        FCB     64,100
        FCB     30,102
        FCB     20,98
        FCB     30,94
        FCB     64,96
        FCB     64,98
        FCB     20,98
        FCB     V$END           ;end of knight vector list
;
; End of Knight vector list
;
; * * * * * * * * *



; * * * * * * * * *
;
; Wizard 1
;
; with crescent shaped sceptre point
;
WIZ1    SVORG   46,98
        SVECT   50,100
        SVECT   54,98
        SVECT   58,92
        SVECT   56,86
        SVECT   48,82
        SVECT   40,86
        SVECT   38,90
        SVECT   40,94
        SVECT   40,92
        SVECT   42,88
        SVECT   48,86
        SVECT   52,88
        SVECT   54,92
        SVECT   50,98
        SVECT   46,98
        SVNEW
;
; Crescent on cape
;
        SVORG   104,154
        SVECT   108,156
        SVECT   112,154
        SVECT   116,148
        SVECT   114,142
        SVECT   106,138
        SVECT   98,142
        SVECT   96,146
        SVECT   98,150
        SVECT   98,148
        SVECT   100,144
        SVECT   106,142
        SVECT   110,146
        SVECT   112,150
        SVECT   108,154
        SVECT   104,154
        SVNEW
        FCB     V$JMP           ;transfer to another list
        FDB     WIZ0            ;pointer to wizard main vector list
;
; * * * * * * * * *



; * * * * * * * * *
;
; Wizard 2
;
; with Star shaped sceptre point
;
WIZ2    FCB     40,86           ;
        FCB     64,92           ;
        FCB     42,100          ;
        FCB     54,82           ;
        FCB     56,104          ;
        FCB     40,86           ;
        FCB     V$NEW           ;start new sequence
;        
; Stars on cape
;
        SVORG   66,140
        SVECT   80,140
        SVECT   68,134
        SVECT   74,144
        SVECT   76,134
        SVECT   66,140
        SVNEW
;
; Lower right start
;
        FCB     96,146          ;
        FCB     120,148         ;
        FCB     100,136         ;
        FCB     106,154         ;
        FCB     116,138         ;
        FCB     96,146          ;
        FCB     V$NEW           ;start new sequence
;
; Upper left star
;
        SVORG   80,116
        SVECT   90,122
        SVECT   86,114
        SVECT   82,122
        SVECT   90,116
        SVECT   80,116
        SVNEW
;
;                               ;fall thru to WIZ0
;
; * * * * * * * * *



; * * * * * * * * *
;
; Main Wizard vector list
;
WIZ0    SVORG   64,124
        SVECT   72,120
        SVECT   64,120
        SVECT   78,110
        SVECT   64,102
        SVECT   58,110
        SVECT   54,118
        SVECT   50,120
        SVECT   46,122
        SVECT   40,116
        SVECT   42,108
        SVECT   28,120
        SVECT   28,126
        SVNEW                   ;start new sequence
;
        SVORG   28,130
        SVECT   28,136
        SVECT   36,146
        SVECT   50,148
        SVECT   44,136
        SVECT   46,132
        SVECT   48,134
        SVECT   44,136
        SVNEW                   ;start new sequence
;
        FCB     48,134          ;
        FCB     54,142          ;
        FCB     116,164         ;down left side of cape
        FCB     132,132         ;to tip of sceptre
        FCB     130,118         ;across bottom of cape
        FCB     120,94          ;
        FCB     90,110          ;to shaft of sceptre
        FCB     132,132         ;down shaft of sceptre
        FCB     72,106          ;up inside of shaft to hand
        FCB     V$NEW           ;   .
;
        SVORG   64,102
        SVECT   66,100
        SVECT   56,94
        SVECT   54,96
        SVECT   64,102
        SVNEW                   ;start new sequence
;
        SVORG   66,102
        SVECT   68,98
        SVECT   74,102
        SVECT   76,104
        SVECT   90,110



        SVNEW                   ;start new sequence
;
        FCB     88,112          ;cape from sceptre shaft
        FCB     72,120          ;to armpit
        FCB     V$NEW           ;start new sequence
;
; Hat from left side of beard
;
        FCB     62,132
        FCB     20,128
        FCB     52,122
        FCB     64,122
        FCB     60,124
        FCB     114,128
        FCB     80,130
        FCB     68,130
        FCB     62,132
        FCB     V$NEW
;
;  Face detail
;
        SVORG   40,130
        SVECT   38,128
        SVECT   40,124
        SVECT   42,126
        SVECT   40,130
        SVECT   46,128
        SVECT   50,128
        SVECT   50,126
        SVECT   42,126
        SVECT   40,124
        SVECT   46,126
        SVEND                   ;end of wizard vector list
;
; End of Wizard vector list
;
; * * * * * * * * *



; * * * * * * * * *
;
; Viper vector list
;
; Body and neck
;
VIPER   FCB     132,130         ;right neck at ground
        FCB     112,122         ;up neck
        FCB     92,124
        FCB     94,126          ;lright chin        
        FCB     94,130          ;left chin
        FCB     92,132
        FCB     112,130
        FCB     128,140
        FCB     132,136         ;left neck at ground
        FCB     132,114         ;right body at ground
        FCB     120,108
        FCB     106,118         ;tip of tail
        FCB     120,112
        FCB     124,116
        FCB     124,126         ;meet neck
        FCB     V$NEW
;
; Head
;
        SVORG   100,120
        SVECT   96,120
        SVECT   92,124
        SVECT   88,120
        SVECT   84,120
        SVECT   82,122
        SVECT   86,126
        SVECT   82,122
        SVECT   82,134
        SVECT   86,130
        SVECT   82,134
        SVECT   84,136
        SVECT   88,136
        SVECT   92,132
        SVECT   96,136
        SVECT   100,136
        SVEND
;
; End of Viper vector list
;
; * * * * * * * * *
;;;;;        END
