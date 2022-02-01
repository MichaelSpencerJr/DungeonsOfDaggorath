;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C O M M O N   D E F I N I T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  'CMPX' opcode
;
SKIP2   EQU     $8C
;
;  Bit Position Mnemonics
;
BIT0    EQU     %00000001
BIT1    EQU     %00000010
BIT2    EQU     %00000100
BIT3    EQU     %00001000
BIT4    EQU     %00010000
BIT5    EQU     %00100000
BIT6    EQU     %01000000
BIT7    EQU     %10000000
;
;
DEBFLG  EQU     0               ;debug flag.



;
; ASCII Character Mnemonics
;
C.NUL   EQU     $00
C.SOH   EQU     $01
C.STX   EQU     $02
C.ETX   EQU     $03
C.EOT   EQU     $04
C.ENQ   EQU     $05
C.ACK   EQU     $06
C.BEL   EQU     $07
C.BS    EQU     $08
C.HT    EQU     $09
C.LF    EQU     $0A
C.VT    EQU     $0B
C.FF    EQU     $0C
C.CR    EQU     $0D
C.SO    EQU     $0E
C.SI    EQU     $0F
C.DLE   EQU     $10
C.DC1   EQU     $11
C.DC2   EQU     $12
C.DC3   EQU     $13
C.DC4   EQU     $14
C.NAK   EQU     $15
C.SYN   EQU     $16
C.ETB   EQU     $17
C.CAN   EQU     $18
C.EM    EQU     $19
C.SUB   EQU     $1A
C.ESC   EQU     $1B
C.FS    EQU     $1C
C.GS    EQU     $1D
C.RS    EQU     $1E
C.US    EQU     $1F
C.SP    EQU     $20
C.DEL   EQU     $7F



;
;  Internal Character Codes
;
I.SP    EQU     $00             ;<SP> space
I.EXCL  EQU     $1B             ;exclamation point
I.BAR   EQU     $1C             ;underline
I.QUES  EQU     $1D             ;question mark
I.DOT   EQU     $1E             ;period
I.CR    EQU     $1F             ;carriage return
I.SHL   EQU     $20             ;small heart (left)
I.SHR   EQU     $21             ;small heart (right)
I.LHL   EQU     $22             ;large heart (left)
I.LHR   EQU     $23             ;large heart (right)
I.BS    EQU     $24             ;<BS> backspace
;
;  Main Entry Point and Direct-Page Locations
;
PROGLOAD        equ             $0E00
VARSTART        equ             $4100        
;
;  Display Area RAM Definitions
;
G6.LEN  EQU     $1800           ;length of Graphics-6 display buffers
;
D0$BAS  EQU     $5000           ;Resolution Graphics-6 Display #0
D0.LEN  EQU     32*19*8         ;32 bytes * 19 lines * 8 scan lines
D0$END  EQU     D0$BAS+D0.LEN   ;ending addr
D0.SAM  EQU     (D0$BAS/64)|6   ;SAM register for screen 0, pmode 4
;
D1$BAS  EQU     D0$BAS+G6.LEN   ;Resolution Graphics-6 display buffer
D1.LEN  EQU     32*19*8         ;32 bytes * 19 lines * 8 scan lines
D1$END  EQU     D1$BAS+D1.LEN   ;ending addr
D1.SAM  EQU     (D1$BAS/64)|6   ;SAM register for screen 1, pmode 4

TOPRAM  equ     D1$BAS+G6.LEN   ;start of RAM

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  V E C T O R   L I S T   C O M M A N D S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  These are special command codes to the vector list driver:
;
V$NEW   EQU     $FF             ;start new sequence
V$END   EQU     $FE             ;end sequence
V$JMP   EQU     $FD             ;chain to addr specified by next word
V$REL   EQU     $FC             ;enter short vector mode
V$JSR   EQU     $FB             ;jump to vector list subroutine
V$RTS   EQU     $FA             ;return from vector list subroutine
V$ABS   EQU     $00             ;return to absolute mode



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C O L O R   C O M P U T E R   D E F I N I T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;
; Condition Code Mnemonics

CC.E    EQU     BIT7
CC.F    EQU     BIT6
CC.H    EQU     BIT5
CC.I    EQU     BIT4
CC.N    EQU     BIT3
CC.Z    EQU     BIT2
CC.V    EQU     BIT1
CC.C    EQU     BIT0
;
; Interrupt Vector Addresses
;
V$SWI3  EQU     $0100
V$SWI2  EQU     $0103
V$SWI   EQU     $0106
V$NMI   EQU     $0109
V$IRQ   EQU     $010C
V$FIRQ  EQU     $010F
;
; BASIC ROM Routines
;
POLCAT  EQU     $A000
CHROUT  EQU     $A002
CSRDON  EQU     $A004
BLKIN   EQU     $A006
BLKOUT  EQU     $A008
JOYIN   EQU     $A00A
WRTLDR  EQU     $A00C
;
; DISK BASIC constants
;
RSTFLG		equ $71
DFLTYP		equ $957
DASCFL		equ $958
DEFDRV		equ $959
DNAMBF		equ $94c
;
; PIA Definitions
;
PIA$0   EQU     $FF00
PIA$1   EQU     $FF20
P.PIIOA EQU     0
P.PICRA EQU     1
P.PIIOB EQU     2
P.PICRB EQU     3



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D U N G E O N   D E F I N I T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  Horizontal Maze Features
;
HF.PAS  EQU     0               ;open passage
HF.DOR  EQU     1               ;regular door
HF.SDR  EQU     2               ;secret door
HF.WAL  EQU     3               ;solid wall
;
;  Vertical Maze Features
;
VF.HUP  EQU     0               ;hole up
VF.LUP  EQU     1               ;ladder up
VF.HDN  EQU     2               ;hole down
VF.LDN  EQU     3               ;ladder down
;
;  Object Classes
;
K.FLAS  EQU     0               ;flask
K.RING  EQU     1               ;ring
K.SCRO  EQU     2               ;scroll
K.SHIE  EQU     3               ;shield
K.SWOR  EQU     4               ;sword
K.TORC  EQU     5               ;torch



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T A S K   C O N T R O L   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.TCPTR EQU     OFF             ;linked list pointer
P.TCTIM EQU     OFF+2           ;countdown timer
P.TCRTN EQU     OFF+3           ;task address
P.TCDTA EQU     OFF+5           ;data block pointer
TC.LEN  EQU     OFF+7           ;length of TCB
;
;  Queue Disposition Codes
;
Q.NUL   EQU     0               ;null queue
Q.JIF   EQU     2               ;jiffy queue
Q.TEN   EQU     4               ;tenth queue
Q.SEC   EQU     6               ;second queue
Q.MIN   EQU     8               ;minute queue
Q.HOU   EQU     10              ;hour queue
Q.SCD   EQU     12              ;scheduler queue



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T E X T   D I S P L A Y   C O N T R O L   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.TXBAS EQU     OFF             ;
P.TXCNT EQU     OFF+2           ;
P.TXCUR EQU     OFF+4           ;
P.TXINV EQU     OFF+6           ;
P.TXSGL EQU     OFF+7           ;
TX.LEN  EQU     OFF+8           ;length of TXB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  V E C T O R   D I S P L A Y   C O N T R O L   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.VDBAS EQU     OFF             ;base address
P.VDEND EQU     OFF+2           ;end address
P.VDSAM EQU     OFF+4           ;magic SAM bits
VD.LEN  EQU     OFF+6           ;length of VDB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  A T T A C K   P A R A M E T E R   B L O C K
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.ATPOW EQU     OFF             ;power
P.ATMGO EQU     OFF+2           ;magic offense
P.ATMGD EQU     OFF+3           ;magic defense
P.ATPHO EQU     OFF+4           ;physical offense
P.ATPHD EQU     OFF+5           ;physical defense
P.ATXXX EQU     OFF+6           ;filler
P.ATDAM EQU     OFF+10          ;damage
AT.LEN  EQU     OFF+12          ;length of ATB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   C O N T R O L   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
CTYPES  EQU     12              ;number of creature types
;
OFF     SET     0
P.CCPOW EQU     OFF             ;power
P.CCMGO EQU     OFF+2           ;magic offense
P.CCMGD EQU     OFF+3           ;magic defense
P.CCPHO EQU     OFF+4           ;physical offense
P.CCPHD EQU     OFF+5           ;physical defense
P.CCTMV EQU     OFF+6           ;movement delay time
P.CCTAT EQU     OFF+7           ;attack delay time
P.CCOBJ EQU     OFF+8           ;object list pointer
P.CCDAM EQU     OFF+10          ;damage
P.CCUSE EQU     OFF+12          ;"in-use" flag
P.CCTYP EQU     OFF+13          ;creature type
P.CCDIR EQU     OFF+14          ;direction of travel
P.CCROW EQU     OFF+15          ;row
P.CCCOL EQU     OFF+16          ;column
CC.LEN  EQU     OFF+17          ;length of CCB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C R E A T U R E   D E F I N I T I O N   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.CDPOW EQU     OFF             ;power
P.CDMGO EQU     OFF+2           ;magic offense
P.CDMGD EQU     OFF+3           ;magic defense
P.CDPHO EQU     OFF+4           ;physical offense
P.CDPHD EQU     OFF+5           ;physical defense
P.CDTMV EQU     OFF+6           ;movement delay time
P.CDTAT EQU     OFF+7           ;attack delay time
CD.LEN  EQU     OFF+8           ;length of CDB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  O B J E C T   C O N T R O L   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.OCPTR EQU     OFF             ;linked list pointer
P.OCROW EQU     OFF+2           ;row
P.OCCOL EQU     OFF+3           ;column
P.OCLVL EQU     OFF+4           ;level
P.OCOWN EQU     OFF+5           ;ownership byte
P.OCXXX EQU     OFF+6           ;type bytes
P.OCTYP EQU     OFF+9           ;object type
P.OCCLS EQU     OFF+10          ;object class
P.OCREV EQU     OFF+11          ;revelation power requirement
P.OCMGO EQU     OFF+12          ;magic offense
P.OCPHO EQU     OFF+13          ;physical offense
OC.LEN  EQU     OFF+14          ;length of OCB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  O B J E C T   D E F I N I T I O N   B L O C K S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
OFF     SET     0
P.ODCLS EQU     OFF             ;object class
P.ODREV EQU     OFF+1           ;revelation power requirement
P.ODMGO EQU     OFF+2           ;magic offense
P.ODPHO EQU     OFF+3           ;physical offense
OD.LEN  EQU     OFF+4           ;length of ODB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  D I R E C T   P A G E   D E F I N I T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
        ORG     VARSTART

hook_openi	rmb 2				; the address of the "open for input" routine in Disk ROM
hook_openo	rmb 2				; the address of the "open for output" routine in the Disk ROM
error_handler	rmb 2				; the installed error trap
error_stack	rmb 2				; the stack address to use when transferring control to the error trap
; These variables are additional ones used by extensions to the original ROM
		rmb 256-(*&255)			; align the next bit on a page boundary
; These are the original variables used by the system, including the direct page.

DP.BEG  EQU     *               ;first location in DP
;
;  RAM Initialized by ONCE
;
BIGZER  RMB     1               ;overlapped 16-bit zero
BIGONE  RMB     2               ;overlapped 16-bit one
NEGONE  RMB     2               ;16-bit negative one
VCNTRX  RMB     2               ;X-coordinate of centroid
VCNTRY  RMB     2               ;Y-coordinate of centroid
;
FLIP    RMB     2               ;pointer to VDB on display
FLOP    RMB     2               ;pointer to VDB being updated
;
AUTPTR  RMB     2               ;index into AUTTAB
OCBPTR  RMB     2               ;index into OCBLND
LINPTR  RMB     2               ;index into LINBUF
;
PROW    RMB     1               ;player position
PCOL    RMB     1               ;   .
POBJWT  RMB     2               ;weight of all objects
PLRBLK  EQU     *               ;player ATB base addr
PPOW    RMB     2               ;power
;
PMGO    RMB     1               ;magic offense
PMGD    RMB     1               ;magic defense
PPHO    RMB     1               ;physical offense
PPHD    RMB     1               ;physical defense
PLHAND  RMB     2               ;left hand
PRHAND  RMB     2               ;right hand
PDAM    RMB     2               ;damage
;
PDIR    RMB     1               ;player facing direction
PTORCH  RMB     2               ;torch in use
PRLITE  RMB     1               ;regular light
PMLITE  RMB     1               ;magic light
FAINT   RMB     1               ;non-zero means we have fainted
BAGPTR  RMB     2               ;what we are carrying
FRZFLG  RMB     1               ;"freeze" all creatures flag



;
;  VDG (MC6847) Control RAM
;
VDGINV  RMB     1               ;Inverse Video Mode
;                               ;   0 = Light on Dark
;                               ;  -1 = Dark on Light
;
;  VECTOR Generator RAM
;
VCTFAD  RMB     1               ;amount of fade ($FF - invisible)
FADCNT  RMB     1               ;fade count (used by VECTOR)
;
Y0      RMB     2               ;starting Y
X0      RMB     2               ;starting X
Y1      RMB     2               ;ending Y
X1      RMB     2               ;ending X
;
XX      RMB     3               ;running-X coordinate
YY      RMB     3               ;running-Y coordinate
DX      RMB     3               ;running-X increment
DY      RMB     3               ;running-Y increment
;
LENGTH  RMB     2               ;dot count
DELTAX  RMB     1               ;display-X address change
DELTAY  RMB     1               ;display-Y address change
VDBAS   RMB     2               ;display base addr
VDEND   RMB     2               ;display end addr
;
;  VCTLST (Vector List Processor) RAM
;
VXOFF   RMB     2               ;X-offset value
VYOFF   RMB     2               ;Y-offset value
VXSCAL  RMB     1               ;multiplicative scale factor in X
VYSCAL  RMB     1               ;multiplicative scale factor in Y
;
DRWFLG  RMB     1               ;flag indicates if starting (Y,X) set
TX      RMB     2               ;true X
TY      RMB     2               ;true Y
;
;  Sound Generator RAM
;
SNDRAM  EQU     *               ;where sound RAM starts
SNDRND  RMB     3               ;sound random number generator
SNSAV   RMB     2               ;scratch area
SNENVS  RMB     2               ;envelope generator start
SNENVD  RMB     2               ;envelope generator delta
SNSAVA  RMB     2               ;alternate save location
SNVOL   RMB     1               ;volume level
SNDLAY  RMB     1               ;RC circuit delay
FREQ1   RMB     2               ;storage
FREQ2   RMB     2               ;storage
SNOTE1  RMB     2               ;music note 1
SNOTE2  RMB     2               ;music note 2
;
; Random Number Generator RAM
;
SEED    RMB     3               ;General Purpose Random Number



;
; Dungeon Viewer RAM definitions
;
RLIGHT  RMB     1               ;regular light
MLIGHT  RMB     1               ;magic light
OLIGHT  RMB     1               ;old lighting value (fainting)
OROW    RMB     1               ;row
OCOL    RMB     1               ;column
HLFSTP  RMB     1               ;half-step forward flag
BAKSTP  RMB     1               ;half-step backward flag
MAGFLG  RMB     1               ;magic light flag
PASFLG  RMB     1               ;passage flag used for peek-a-boo
AUTFLG  RMB     1               ;auto-play flag
;
; Parser Ram
;
PARFLG  RMB     1               ;successful match flag
PARCNT  RMB     1               ;loop counter
VERIFY  RMB     1               ;verify on/off flag
FULFLG  RMB     1               ;full word match
;
; Dungeon Generator RAM definitions
;
DROW    RMB     1               ;row
DCOL    RMB     1               ;column
DST     RMB     1               ;distance to travel
CELCNT  RMB     2               ;number of cells created
LEVEL   RMB     1               ;maze level value
CMXPTR  RMB     2               ;index into CMXLND
LVLPTR  RMB     2               ;index into LVLVDG
VFTPTR  RMB     2               ;index into VFTTAB
;
;  Dungeon Subroutine Parameters
ROW     RMB     1               ;row position
COL     RMB     1               ;column position
DIR     RMB     1               ;temp dir holder
RANGE   RMB     1               ;temp sight range holder
;
;  Object Subroutine Parameters
;
OBJCNT  RMB     1               ;used by ONCE (object distribution)
OBJLVL  RMB     1               ;used by ONCE (object distribution)
OBJTYP  RMB     1               ;object type
OBJCLS  RMB     1               ;object class
SPEFLG  RMB     1               ;specific object flag
OFINDF  RMB     1               ;OCB table ptr "rewind" flag
OFINDP  RMB     2               ;OCB table ptr
MAPFLG  RMB     1               ;used by scrolls



;
;  CLOCK RAM
;
TIMBEG  EQU     *               ;where the timers live
JIFFY   RMB     1               ;JIFFY counter
TENTH   RMB     1               ;TENTH counter
SECOND  RMB     1               ;SECOND counter
MINUTE  RMB     1               ;MINUTE counter
HOUR    RMB     1               ;HOUR counter
DAY     RMB     1               ;DAY counter
TIMEND  EQU     *               ;end of timers
;
SLEEP   RMB     1               ;system SLEEP counter
NOISEF  RMB     1               ;noise flag
NOISEV  RMB     1               ;noise value
FADFLG  RMB     1               ;wizard fade-in flag
;
;  Queue Pointers
;
QUEBEG  EQU     *               ;where the queue ptrs live
NULQUE  RMB     2               ;NULL queue
JIFQUE  RMB     2               ;JIFFY queue
TENQUE  RMB     2               ;TENth of a second queue
SECQUE  RMB     2               ;SECOND queue
MINQUE  RMB     2               ;MINUTE queue
HOUQUE  RMB     2               ;HOUR queue
SCDQUE  RMB     2               ;scheduler queue
QUEEND  EQU     *               ;end of queue ptrs
;
;  Heart Ram
;
HEARTF  RMB     1               ;heart beat (on/off)
HEARTC  RMB     1               ;visual heartbeat countdown counter
HEARTR  RMB     1               ;current heart rate
HEARTS  RMB     1               ;heart size flag
HBEATF  RMB     1               ;audio heartbeat flag
;
;  Display Mode RAM
;
DSPMOD  RMB     2               ;display routine in use
UPDATE  RMB     1               ;"need to update" flag
NEWLUK  RMB     1               ;delayed update flag
NEWLIN  RMB     1               ;used by EXAMINE function
TXBFLG  RMB     1               ;standard/non-standard i/o flag
;
;  LOAD/SAVE Cassette Function Flags
;
ZFLAG   RMB     1               ;load/save (-1/1) flag
;
;  SCHEDuler RAM
;
TCBPTR  RMB     2               ;next available TCB
RSTART  RMB     1               ;scheduler restart flag
KBDHDR  RMB     1               ;"put" pointer
KBDTAL  RMB     1               ;"get" pointer



;
;  Line Buffer Routine RAM
;
BUFFLG  RMB     1               ;line buffering flag
;
;  COMSWI RAM
;
SWIJMP  RMB     2               ;dispatch addr
;
;  Temporary Storage
;
T0      RMB     1
T1      RMB     1
T2      RMB     1
T3      RMB     1
T4      RMB     1
T5      RMB     1
T6      RMB     1
T7      RMB     1
;
;  Debugging Storage
;
D0      RMB     1
D1      RMB     1
D2      RMB     1
D3      RMB     1
D4      RMB     1
D5      RMB     1
D6      RMB     1
D7      RMB     1
;
;  Insure Base Page RAM Size
;
DP.END  EQU     *               ;last location of direct page
DP.LEN  EQU     DP.END-DP.BEG   ;length of DP definitions



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C O M M O N   R A M   L O C A T I O N S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
MM.BEG  EQU     *               ;where memory begins
;
;  ASCII Character Buffers
;
KBDBUF  RMB     32              ;keyboard circular buffer
LINBUF  RMB     32              ;line input buffer
LINEND  RMB     2               ;line buffer end
TOKEN   RMB     32              ;token buffer
TOKEND  RMB     1               ;token buffer end
STRING  RMB     34              ;ASCII string buffer
SWCHAR  RMB     10              ;S/W character expansion buffer
OBJSTR  RMB     32              ;object string names
;
;  Text Control Blocks (TXB)
;
TXTEXA  RMB     TX.LEN          ;EXAMINE command text screen
TXTSTS  RMB     TX.LEN          ;Status Line
TXTPRI  RMB     TX.LEN          ;Primary Text Screen
;
;  Creature Matrix/Control Block (CCB) Storage
;
CMXLND  RMB     CTYPES*5        ;creature matrix
CMXEND  EQU     *               ;   .
;
CCBLND  RMB     CC.LEN*32       ;Land of the Creatures
CCBEND  EQU     *               ;   .
;
;  Dungeon Maze RAM
;
MAZLND  RMB     32*32           ;The "Maze"
MAZEND  EQU     *               ;   .
;
NEIBOR  RMB     9               ;map of surrounding cells
;
;  Task Control Block Storage
;
TCBLND  RMB     TC.LEN*38       ;Land of the TCBs
TCBEND  EQU     *               ;   .
;
;  Object Control Block  (OCB) Storage
;
EMPHND  RMB     OC.LEN          ;empty hand holder
;
OCBLND  RMB     OC.LEN*72       ;Land of the OCBs
OCBEND  EQU     *               ;   .
;
MM.END  EQU     *               ;last location of memory



;
;  Stack Area
;
PDL     EQU     D0$BAS          ;where the push-down-list starts
PD.LEN  EQU     D0$BAS-MM.END   ;length of push-down list
;
;;;;;        END
