;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  T H E   S C H E D U L E R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The scheduler utilizes the 'Round-Robin' algorithm.
;  Tasks are executed one-at-a-time, with each running
;  to completion.  Tasks should be as short as possible
;  to insure all tasks run within their time windows.
;
;  SCDQUE is a 16-bit address pointing at a linked
;  list of TCB's which make up the scheduling queue.
;
;  Upon task completion, the registers should have the
;  following values:
;
;       A - New Countdown Time (Optional)
;
;       B - Queue Pointer or Zero (destroy the TCB)
;
;
;  PIETAP: Initialize PIA's for Tape Operations
;
PIATAP  LDU     #PIA$0          ;addr of PIA #0 ($FF00)
        LDD     #$343C          ;magic PIA bit patterns
        STA     P.PICRB,U       ;SEL2=0, Disable IRQ to CPU
        STA     P.PICRB+PIA$1   ;Six Bit Sounds OFF, Disable FIRQ to CPU
        STB     P.PICRA+PIA$1   ;Cassette Motor ON, Disable FIRQ to CPU
        RTS
;
;  TAPDLY: Delay to insure motor has started
;
TAPDLY  LDX     BIGZER          ;insure motor is running
TDLY10  LEAX    -1,X            ;   .
        BNE     TDLY10          ;   .
        RTS                     ;bye



LOAD90  JSR     IRQSYN          ;enable/sync on IRQ
        CLR     ZFLAG           ;indicate tape operation complete
        SWI                     ;show what is going on
        FCB     INIVU           ;   .
        SWI                     ;prompt the human
        FCB     PROMPT          ;   .



;
;  SCHED: The "Merry-Go-Round"
;
SCHED   LDU     #SCDQUE         ;start at queue head
        CLR     RSTART          ;reset "restart" flag
SCHED0  TFR     U,Y             ;curr TCB becomes prev TCB
;
;  Check for TAPE functions
;
SCHED1  ;TST     ZFLAG           ;check for load/save (-1/1)
        ;BGT     SAVE            ;   .
        ;BMI     LOAD            ;   .
;
;  Process next entry in SCDQUE
;
        LDU     P.TCPTR,U       ;advance curr TCB ptr
        BEQ     SCHED           ;   start again if tail reached
;
;  Execute the selected task
;
        PSHS    Y,U             ;save TCB pointers
        JSR     [P.TCRTN,U]     ;dispatch to routine
        PULS    Y,U             ;restore TCB pointers
;
;  Do we need to restart?
;
        TST     RSTART          ;check restart flag?
        BNE     SCHED           ;   we need to start again
;
;  Check disposition upon execution completion
;
        CMPB    #Q.SCD          ;leave in the SCHED queue?
        BEQ     SCHED0          ;   yes - process next TCB
;
;  Remove TCB from SCHED and add to appropriate queue
;
        BSR     QUERMV          ;de-link current TCB from chain
        BSR     QUEADD          ;reschedule TCB to appropriate queue
        TFR     Y,U             ;fake previous TCB run
        BRA     SCHED1          ;process next TCB



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  Q U E U E   M A N A G E R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  All queues are composed of forward linked lists of TCB's.
;  Associated with each queue is an initial queue pointer.
;  The linked lists are terminated with a null.
;
;*****
;
;  QUEADD: Add a TCB to the end of a queue (linked list)
;
;  Inputs:
;       A - Countdown Time (Optional)
;       B - Queue Code
;       U - pointer to TCB
;
QUEADD  PSHS    CC,A,B,X        ;save some regs
        ORCC    #CC.I           ;non-interruptible code
        STA     P.TCTIM,U       ;store countdown time in TCB
        LDX     #QUEBEG         ;where the queue ptrs reside
        ABX                     ;determine addr of queue ptr
        CLRA                    ;zap link ptr
        CLRB                    ;   .
        STD     P.TCPTR,U       '   .
;
QUEAD1  CMPD    ,X              ;search for end of linked list
        BEQ     QUEAD2          ;   found it!
        LDX     P.TCPTR,X       ;advance to next TCB
        BRA     QUEAD1          ;loop until we find it
;
QUEAD2  STU     ,X              ;link last TCB to new TCB
        PULS    CC,A,B,X,PC     ;restore regs/go home
;
;  QUERMV: Remove a TCB from a Linked List
;
;  Inputs:
;       U - Ptr to TCB to be removed
;       Y - Ptr to previous TCB
;
QUERMV  PSHS    CC,X            ;save condition codes
        ORCC    #CC.I           ;non-interruptible code
        LDX     P.TCPTR,U       ;get curr TCB link
        STX     P.TCPTR,Y       ;leapfrog prev TCB past this TCB
        PULS    CC,X,PC         ;restore condition codes/go home



;
;  QUESCN: Process TCB's in the CLOCK queues
;
;  Inputs:
;       U - Queue Pointer
;
QUESCN  PSHS    B,X,Y,U         ;save some regs
        TST     SLEEP           ;is the system SLEEPing?
        BNE     QUESC9          ;   yes - don't process queues
;
;  Traverse the Linked List
;
QUESC0  TFR     U,Y             ;curr TCB becomes prev TCB
        LDU     P.TCPTR,U       ;advance curr TCB ptr
        BEQ     QUESC9          ;   null ptr means tail reached
        DEC     P.TCTIM,U       ;decrement countdown timer
        BNE     QUESC0          ;   time left - process next TCB
;
;  Reschedule the TCB into SCDQUE
;
        BSR     QUERMV          ;delink curr TCB
        LDB     #Q.SCD          ;load queue code
        BSR     QUEADD          ;add TCB to the scheduler queue
        BRA     QUESC0          ;process next TCB
;
QUESC9  PULS    B,X,Y,U,PC      ;restore regs/go home



;!!!!!!!!!!!!!!!!!!!!!!!!!
;  T C B   M A N A G E R    
;!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  GETTCB: Allocates a TCB
;
;  Returns:
;       U - address of TCB
;
GETTCB  PSHS    X               ;save regs
        LDU     TCBPTR          ;ptr to next available TCB
        LEAX    TC.LEN,U        ;advance ptr
        STX     TCBPTR          ;update RAM
        PULS    X,PC            ;restore regs/exit



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S A M   P R O G R A M M I N G   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The Motorola MC6883 Synchronous Address Multiplexer (SAM)
;  registers are mapped from $FFC0 to $FFDF.  Each register
;  consists of two consecutive bytes.  Writing (any value)
;  to the even byte will clear the register.  Writing to the
;  odd byte will set the register.
;
;  The SAM bits are defined as:
;
;       TY      Map Type (must be zero)
;       M1,M0   Map Size:
;                  00 - 4K Dynamic
;                  01 - 16K Dynamic
;                  10 - 64K Dynamic
;                  11 - 64K Static
;       R1,R0   MPU Rate:
;                  00 - 0.9MHz Only (Transparent Refresh)
;                  01 - 0.9/1.8MHz  (Transparent Refresh)
;                  10 - 1.8MHz Only
;                  11 - 1.8MHz Only
;       P1      Paging (must be zero)
;       F6-F0   Display Offset Page Number (512 bytes/page)
;       V2-V0   VDG Mode:
;                  000 - Alpha Internal/External, Semi-Graphics 4/6
;                  001 - Color/Resolution Graphics-1 (G2C/G2R)
;                  010 - Color Graphics-2 (G2C)
;                  011 - Resolution Graphics-2 (G2R)
;                  100 - Color Graphics-3 (G3C)
;                  101 - Resolution Graphics-3 (G3R)
;                  110 - Color/Resolution Graphics-6 (G6C/G6R)
;                  111 - DMA
;



;
;  SAM:  Reprogram the SAM
;
;  Inputs:
;       A - Bit:  7  6  5  4  3  2  1  0
;           SAM:  TY M1 M0 R1 R0 P1 F6 F5
;
;       B - Bit:  7  6  5  4  3  2  1  0
;           SAM:  F4 F3 F2 F1 F0 V2 V1 V0
;
SAM     PSHS    A,B,X           ;save regs
        LDX     #$FFC0          ;SAM base addr
SAM10   LSRA                    ;16-bit logical shift right
        RORB                    ;   .
        BCS     SAM12           ;   former LSBit was set
        STA     ,X              ;clear the SAM reg (2022 n.b. original was 0,X)
        FCB     SKIP2           ;   .
SAM12   STA     1,X             ;set the SAM reg
        LEAX    2,X             ;advance to next reg
        CMPX    #$FFD4          ;done yet?
        BLO     SAM10           ;   nope
        PULS    A,B,X,PC        ;restore regs/exit



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  C L O C K   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  CLOCK is the IRQ interrupt service routine.  This routine
;  provides a number of functions:
;
;       * Swaps Graphics-6 Resolution (G6R) Screens
;       * Produces 30Hz Buzzing Noise for Opening
;       * Maintains Heartbeat/flash
;       * Maintains the Time-Of-Day (TOD) Counters
;       * Maintains the CLOCK Queues
;       * Performs Keyboard Input
;
;  IRQ is a hardware generated interrupt which occurs at
;  1/60th of a second intervals, called a "JIFFY".
;
;  If location UPDATE is non-zero, CLOCK will swap the display
;  screens (by reprogramming the SAM), and will reprogram  the
;  VDG to the correct color set.  The SAM requires buffers to
;  be on page (512-bytes) boundaries.
;
;  FLIP is a byte containing the SAM page number of the buffer
;  currently being displayed.  FLOP points at the buffer being
;  updated.
;
;  The TOD timers will keep time for 256 days before rolling
;  over.
;
;  The POLCAT routine is a part of the BASIC ROM routines.
;  If a character is seen it will be added to the keyboard
;  buffer, KBDBUF.
;
;  The CLOCK queues are linked lists of TCB's.  Each TCB in a
;  list has its "countdown" timer decremented.  If a timer has
;  expired, the TCB is transferred from the CLOCK queue to the
;  SCHED queue for execution.
;
;  If location SLEEP is non-zero, CLOCK will not scan the queues.
;  Instead it will decrement SLEEP once per second and will only
;  process the queues when SLEEP becomes zero.  In this way, the
;  whole scheduling process can be suspended.



;
;  CLOCK: IRQ Interrupt Service Routine
;
CLOCK   LDX     #PIA$1          ;load ptr to PIA #1
        LDA     P.PICRB-$20,X   ;check for JIFFY interrupt
        LBPL    CLK90           ;   ignore all but jiffy interrupts
;
;  Insure Correct DP
;
        LDA     #DP.BEG/256     ;org the DP
        TFR     A,DP            ;   .
;
;  Test if loading/saving and skip processing interrupt if so
;
                tst             ZFLAG           ; are we loading/saving?
                lbne            CLK90           ; brif so - don't process interrupt
;
;  Swap the Display Screens
;
        TST     UPDATE          ;do we need to update the screen?
        BEQ     CLK20           ;   nope
        LDD     FLIP            ;exchange display pointers
        LDU     FLOP            ;   .
        STD     FLOP            ;   .
        STU     FLIP            ;   .
        LDD     P.VDSAM,U       ;SAM/VDG page number
        BSR     SAM             ;change the SAM address
        CLR     UPDATE          ;reset flag
;
;  30-Hz. Buzzing Sound (used in opening)
;
CLK20   TST     NOISEF          ;buzz flag on?
        BEQ     CLK30           ;   nope
        COM     NOISEV          ;complement noise value
        LDA     NOISEV          ;load noise value
        LSLA                    ;adjust position
        LSLA                    ;   .
        STA     P.PIIOA,X       ;output to DAC (bit7-bit2)



;
;  Heartbeat Sound
;
CLK30   TST     HBEATF          ;should we consider making a sound?
        BEQ     CLK40           ;   nope
        DEC     HEARTC          ;should we make a sound?
        BNE     CLK40           ;   nope
        LDA     HEARTR          ;reset heart beat counter
        STA     HEARTC          ;   .
;
        LDB     P.PIIOB,X       ;flip single bit sound output bit
        EORB    #BIT1           ;   .
        STB     P.PIIOB,X       ;   .
;
;  Heartbeat Status Line Flash (can be disabled)
;
        TST     HEARTF          ;process heart beat?
        BEQ     CLK40           ;   nope
;
        LDU     #TXTSTS         ;status TXB
        LDX     P.TXCUR,U       ;save current cursor
        LDD     #15             ;position for HEART
        STD     P.TXCUR,U       ;   .
;
        LDA     #I.SHL          ;small heart left
        COM     HEARTS          ;small or large heart?
        BEQ     CLK32           ;   small
        LDA     #I.LHL          ;large heart left
;
CLK32   JSR     TXTDPB          ;deposit char
        INC     P.TXCUR+1,U     ;advance cursor position
        INCA                    ;now process right side
        JSR     TXTDPB          ;deposit char
        STX     P.TXCUR,U       ;restore original cursor



;
;  Update Time-Of-Day (TOD) Counters
;
CLK40   LDU     #JIFQUE         ;always process the jiffy queue
        JSR     QUESCN          ;   .
;
        LDX     #JIFFY          ;beginning of timers
        LDY     #ROLTAB         ;table of rollover values
CLK42   INC     ,X              ;bump the timer
        CMPX    #DAY            ;are we done?
        BEQ     CLK50           ;   yes
        LDA     ,X              ;reach rollover value?
        CMPA    ,Y+             ;   .
        BLT     CLK50           ;   nope - done with timers
;
        CLR     ,X+             ;clear timer/advance to next timer
        LEAU    2,U             ;advance to next queue
        JSR     QUESCN          ;process the queue
        BRA     CLK42           ;loop
;
;  Perform Keyboard Input
;
CLK50   TST     FAINT           ;have we fainted?
        BNE     CLK90           ;   yes - don't scan keyboard
;
;  Determine Scanning Method
;
        TST     AUTFLG          ;are we in autoplay?
        BEQ     CLK60           ;   nope - use regular i/o rtn
;
;  AUTOPLAY - Abort upon key depression
;
        CLR     P.PIIOB+PIA$0   ;strobe the keyboard
        LDA     P.PIIOA+PIA$0   ;collect PIA info
        ANDA    #$7F            ;mask out MSBit
        CMPA    #$7F            ;any keys depressed?
        BEQ     CLK90           ;   nope
;
        LDX     #GAME           ;force transfer upon keystroke
        STX     10,S            ;   .
;
;  GAME - Use POLCAT Routine/Buffer Chars
;
CLK60   SWI2                    ;scan the keyboard
        FCB     POLCAT-$A000    ;   .
        TSTA                    ;check for nulls
        BEQ     CLK90           ;   ignore nulls
        BSR     KBDPUT          ;deposit char in buffer
;
CLK90   LDA     P.PIIOB+PIA$0   ;reset PIA for next interrupt
; Because we're using Basic routines, we need to let the Basic IRQ handler run too.
		clra				; restore DP to 0 for Basic
		tfr a,dp
		jmp [hook_irq]			; transfer control to the saved IRQ routine (this will do the RTI)
;
;  ROLTAB: Rollover Values for Timers
ROLTAB  FCB     6               ;jiffy
        FCB     10              ;tenth



        FCB     60              ;second
        FCB     60              ;minute
        FCB     24              ;hour



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  K E Y B O A R D   S E R V I C E   R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  The keyboard service routines use a 32-byte circular
;  buffer.  There is no check for buffer overflow/overrun.
;
;*****
;
;  KBDGET: Get a character from the buffer
;
;  Returns:
;       A - char
;
KBDGET  PSHS    B,X,CC      ;save regs/condition codes
        ORCC    #CC.I       ;non-interruptible code
        CLRA                ;default char if none found
        LDX     #KBDBUF     ;load buffer base addr
        LDB     KBDHDR      ;load GET offset
        CMPB    KBDTAL      ;empty buffer?
        BEQ     KBDGT9      ;   yes
        LDA     B,X         ;get the next char
        INCB                ;bump offset
        ANDB    #%00011111  ;wrap at 32 bytes
        STB     KBDHDR      ;update offset
KBDGT9  PULS    B,X,CC,PC   ;restore regs/condition codes/go home
;
;  KBDPUT: Add a char to the buffer
;
;  Inputs:
;       A - char
;
KBDPUT  PSHS    B,X,CC          ;save regs/condition codes
        ORCC    #CC.I           ;non-interruptible code
        LDX     #KBDBUF         ;load buffer base address
        LDB     KBDTAL          ;load PUT offset
        STA     B,X             ;deposit byte in buffer
        INCB                    ;bump offset
        ANDB    #%00011111      ;wrap at 32 chars
        STB     KBDTAL          ;update offset
        PULS    B,X,CC,PC       ;restore regs/condition codes/go home
;
;;;;;        END
