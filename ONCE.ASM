;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  O N C E - O N L Y   I N I T I A L Z I A T I O N
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;
;  ONCE: Once-only Initialization
;
        ORG     $C000
ONCE    EQU     *               ;in the beginning...
;
;  DEMO/GAME Start-Up
;
DEMO    LDU     #DEMO10         ;initialize RAM
        BRA     COMINI          ;    .
;
GAME    LDU     #GAME10         ;initialize RAM/fall into COMINI



;
;  COMINI: Common Initialization Routine
;
;  Inputs:
;       U - return addr
;
COMINI  EQU     *               ;--- start of procedure COMINI
        LDS     #PDL            ;set stack pointer
;  Program PIA$0
;
        LDX     #PIA$0          ;PIA$0 addr
        LDD     #$34FA          ;bit patterns
        STA     P.PICRB,X       ;SEL2=0, Disable IRQ to CPU
        STA     P.PICRA,X       ;SEL1=0, Disable IRQ to CPU
;
;  Program PIA$1
;
        LDX     #PIA$1          ;PIA$1 addr
        STA     P.PICRA,X       ;Cassette Motor OFF, Disable FIRQ to CPU
        CLR     P.PICRB,X       ;program inputs/outputs
        STB     P.PIIOB,X       ;Outputs: VDG(b7-b3), 1-Bit Sound(b1)
        LDA     #$3C            ;Six Bit Sounds ON, Disable FIRQ to CPU
        STA     P.PICRB,X       ;   .
;
;  Set SAM and VDG modes
;
        LDD     #D0.SAM         ;magic SAM bits!
        JSR     SAM             ;turn on graphics screen
        LDA     #%11111000      ;insure VDG and SAM are in sync
        STA     P.PIIOB,X       ;   .
;
;  Zero All Of RAM
;
        LDX     #$0200          ;clear all of our RAM
CINI10  CLR     ,X+             ;zero next location
        CMPX    #$4000          ;done yet?
        BLO     CINI10          ;   nope
;
        STU     ,--S            ;stack return addr
        LDA     #2              ;org the DP @ $0200
        TFR     A,DP            ;   .
;
;  Initialize RAM Locations
;
        LDY     #RAMDAT         ;RAM initialization start addr
CINI20  LDA     ,Y+             ;load byte count
        BEQ     CINI40          ;   we are done
        LDX     ,Y++            ;load addr
        BSR     COPY            ;invoke copy function
        BRA     CINI20          ;loop



;
;   COPY: Byte Copy Routine
;
;  Inputs:
;       A - Byte Count
;       X - Destination Addr
;       Y - Source Addr
;  Returns:
;       A - Zero
;       X - Destination Addr + Byte Count
;       Y - Source Addr + Byte Count
;
COPY    LDB     ,Y+             ;load source byte
        STB     ,X+             ;store into destination
        DECA                    ;decrement byte count
        BNE     COPY            ;round and round
        RTS                     ;bye
;
;  SYSTCB: Create System TCBs
;
;  Returns:
;       Y - ptr to RAM initialization data
;
SYSTCB  PSHS    CC,A,B,X,Y,U    ;save regs
        ORCC    #CC.I           ;disable interrupts
        LDX     #QUEBEG         ;reset all queue ptrs
STCB10  CLR     ,X+             ;   .
        CMPX    #QUEEND         ;   .
        BLO     STCB10          ;   .
;
        LDX     #TCBLND         ;reinitialize TCB area
        STX     TCBPTR          ;   .
STCB20  CLR     ,X+             ;   .
        CMPX    #TCBEND         ;   .
        BLO     STCB20          ;   .
;
        LDY     #TCBDAT         ;where TCB data resides
        DEC     RSTART          ;flag SCHEDULER restart
        LDD     #Q.SCD          ;TCBs start in SCHEDuler queue
;
STCB30  LDX     ,Y++            ;load routine name
        BEQ     STCB99          ;   done
        JSR     GETTCB          ;allocate a new TCB
        STX     P.TCRTN,U       ;store in TCB
        JSR     QUEADD          ;add TCB to the correct queue
        BRA     STCB30          ;loop for next TCB
;
STCB99  PULS    CC,A,B,X,Y,U,PC ;restore regs/exit



;
;  Create All Objects
;
CINI40  BSR     SYSTCB          ;create system TCBs
        LDU     #OMXTAB         ;distribution table base addr
        CLRA                    ;reset object type
;
CINI42  LDB     ,U              ;load entry
        ANDB    #$0F            ;separate object count
        STB     OBJCNT          ;   .
;
        LDB     ,U+             ;re-load entry/advance ptr
        LSRB                    ;extract maximum object level
        LSRB                    ;   .
        LSRB                    ;   .
        LSRB                    ;   .
        STB     OBJLVL          ;   .
;
CINI44  SWI                     ;create the object
        FCB     OBIRTH          ;   .
        DEC     P.OCOWN,X       ;mark as creature owned
        INCB                    ;go down a level
        CMPB    #5              ;at bottom?
        BLE     CINI46          ;   not yet
        LDB     OBJLVL          ;at bottom - start again
;
CINI46  DEC     OBJCNT          ;one less object to create
        BNE     CINI44          ;   not done yet
;
        INCA                    ;advance to the next object
        CMPU    #OMXEND         ;done yet?
        BLO     CINI42          ;   nope



;
;  Display COPYRIGHT Notice
;
        LDU     #TXTSTS         ;string i/o to status line
        DEC     TXBFLG          ;   .
        SWI                     ;clear the status line
        FCB     CLRSTS          ;   .
;
        SWI                     ;from on the high...
        FCB     OUTSTI          ;   .
        FCB     %11111000       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %11011111       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00001100       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %11001001       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00100111       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01000101       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00000000       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00000010       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01100101       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %11000001       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00000011       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01010010       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00111001       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00111100       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00000000       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01101000       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %11011010       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %11001100       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01100011       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %00001001       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
        FCB     %01001000       ;COPYRIGHT  DYNA MICRO  MCMLXXXII
;
PSTS90  CLR     TXBFLG          ;restore standard i/o
        RTS                     ;go home



;
;  Arm the ABORT function
;
DEMO10  DEC     AUTFLG          ;indicate AUTOPLAY mode
        BSR     IRQSYN          ;enable/sync on IRQ
;
;  Coming Attractions...
;
        LDX     #WIZ1           ;use the crescent wizzard
        DEC     FADFLG          ;fade
        SWI                     ;(don't erase status line!)
        FCB     WIZIN0          ;   .
;
        SWI                     ;welcome message (part I)
        FCB     OUTSTI          ;   .
        FCB     %10011111       ;^I DARE YE ENTER...^
        FCB     %11010010       ;^I DARE YE ENTER...^
        FCB     %00000010       ;^I DARE YE ENTER...^
        FCB     %00000110       ;^I DARE YE ENTER...^
        FCB     %01000101       ;^I DARE YE ENTER...^
        FCB     %00000110       ;^I DARE YE ENTER...^
        FCB     %01001010       ;^I DARE YE ENTER...^
        FCB     %00000010       ;^I DARE YE ENTER...^
        FCB     %10111010       ;^I DARE YE ENTER...^
        FCB     %10000101       ;^I DARE YE ENTER...^
        FCB     %10010111       ;^I DARE YE ENTER...^
        FCB     %10111101       ;^I DARE YE ENTER...^
        FCB     %11101111       ;^I DARE YE ENTER...^
        FCB     %10000000       ;^I DARE YE ENTER...^
;
        SWI                     ;welcome message (part II)
        FCB     OUTSTI          ;   .
        FCB     %11110111       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %10111101       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %11101010       ;...THA DUNGEONS OF DAGGORATH!!!
        FCB     %00100000       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %10100000       ;...THE DUNGEONS OF DAGGORITH!!!
        FCB     %00100101       ;...THE DUJGEONS OF DAGGORATH!!!
        FCB     %01011100       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %01110010       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %10111101       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %11010011       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %00000011       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %11001100       ;...THE DUNGEONS OF DAGGORITH!!!
        FCB     %00000010       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %00000100       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %11100111       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %01111100       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %10000011       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %01000100       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %01101111       ;...THE DUNGEONS OF DAGGORATH!!!
        FCB     %01111011       ;...THE DUNGEONS OF DAGGORATH!!!



        SWI                     ;display message for a while
        FCB     WAIT            ;   .
        SWI                     ;   .
        FCB     WAIT            ;   .
;
        SWI                     ;now fade the wizard out
        FCB     WIZOUT          ;   .
        SWI                     ;blank the screen
        FCB     ZFLOP           ;   .
        DEC     UPDATE          ;   .
        SYNC                    ;   .
;
;  Create Autoplay Dungeon/Drop Player into it
;
        LDA     #2              ;level three
        LDU     #DEMDAT         ;use demo initialization data
        BRA     GAME20          ;   .



;
;  IRQSYN: Enable and Synchronize on IRQ
;
IRQSYN  LDD     #$343C          ;bit patterns
        STA     P.PICRA+PIA$1   ;turn off cassette motor
        STB     P.PICRB+PIA$1   ;enable Six BIT Sounds
        INCA                    ;ACCA <- $35
        STA     P.PICRB+PIA$0   ;SEL2=0, IRQ on falling edge FS
        CWAI    #~(CC.I&$00FF)  ;synchronize on first IRQ
        RTS
;
;  Game Initialization
;
GAME10  BSR     IRQSYN          ;enable/sync on IRQ
;
        LDD     #$100B          ;set initial position
        STD     PROW            ;   .
        CLR     PPOW            ;correct power settings
        CLRA                    ;start on level 0
        LDU     #GAMDAT         ;game initialization data



;
;  Common DEMO/GAME Code
;
GAME20  SWI                     ;display filler message
        FCB     PREPAR          ;   .
        SWI                     ;create the new level
        FCB     NEWLVL          ;   .
;
;  Create and Stow Objects into Bag
;
        LDY     #BAGPTR         ;load ptr to bag
GAME30  LDA     ,U+             ;load next object type
        BMI     GAME40          ;   done
        SWI                     ;create the object
        FCB     OBIRTH          ;   .
        INC     P.OCOWN,X       ;mark as player owned
        EXG     X,U             ;   .
        SWI                     ;   .
        FCB     OCBFIL          ;   .
        EXG     X,U             ;   .
        CLR     P.OCREV,X       ;reveal the object
        STX     P.OCPTR,Y       ;append to bag list
        TFR     X,Y             ;advance to next object
        BRA     GAME30          ;loop until done
;
GAME40  TST     AUTFLG          ;autoplay?
        BEQ     GAME50          ;   nope - normal startup
;
        DEC     SLEEP           ;turn off scheduler
        LDX     #MAPPER         ;throw up map display
        STX     DSPMOD          ;   .
        DEC     MAPFLG          ;show everything
        SWI                     ;   .
        FCB     PUPDAT          ;   .
        SWI                     ;   .
        FCB     WAIT            ;   .
        SWI                     ;   .
        FCB     WAIT            ;   .
        CLR     SLEEP           ;wake up
;
        SYNC                    ;delay for AUTOPLAY synchronization
        SYNC                    ;   .
;
GAME50  SWI                     ;initial view
        FCB     INIVU           ;   .
        SWI                     ;fake the prompt
        FCB     PROMPT          ;   .
        JMP     SCHED           ;fall into the scheduler
;
;;;;;        END