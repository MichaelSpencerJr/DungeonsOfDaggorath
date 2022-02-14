;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is the "pause mode". Pause mode has a completely different list of commands available to it.
PZPAUS	        dec SLEEP       		; freeze the scheduler
                clr HBEATF                      ; stop the heart
		SWI                             ;clear the status line
                FCB     CLRSTS          	; clear the status bar
		ldu #TXTSTS			; point to status area parameters
		dec TXBFLG			; set to nonstandard rendering
		ldd #11				; offset to centre "**PAUSED**"
		std 4,u				; set offset into area
		jsr putstrimm			; display the pause notice
		fcn '**PAUSED**'
		clr TXBFLG			; reset display parameters
                dec PAUSED
		ldx DSPMOD			; fetch current display routine
		stx PDSPMD			; save it for later restoration
		ldx #pausedisplay		; set dungeon display update to NOP
		stx DSPMOD
		jsr EXAMIO			; set up graphics area for text rendering
		clr 4,u				; reset to start of display
		clr 5,u
		jsr PCREDITS			; display credits
		ldx #resumemess			; advertise resuming
		jsr prendertext
		dec UPDATE			; swap live
pausedisplay	rts
; This is the puase mode command handler
pausemodecmd	ldx #PAUTAB			; point to command list
		jsr PARSER			; look up word in command list
		beq pausemode000		; brif nothing to match
		bpl pausemode001		; brif found
		jsr CMDERR			; show bad command string
pausemode000	jmp HMAN70			; go on with new command
pausemode001	lsla				; two bytes per jump table entry
		ldx #pause_DISPATCH		; point to command jump table
		jsr [a,x]			; go handle command
		jmp HMAN70			; go handle new command
; Pause mode command list
PAUTAB		fcb PAUNUM
FOO     SET     0
        XDEF    T.RSUM,M$RSUM,RESUME,T.GRAM
        XDEF    T.CRED,M$CRED,CREDITS,T.GRAM

PAUNUM  EQU     FOO
; Pause mode command jump table
pause_DISPATCH	fdb PRESUME			; RESUME command
		fdb PCREDITS			; CREDITS command
; Resume message
resumemess	fcn 'Use the RESUME command to\rreturn to your game.\r\r'
; The credits display12345678901234567890123456789012
credits		fcc 'Dungeons of Daggorath\r\r'
		fcc 'Original game copyright 1982 by\r'
		fcc 'Dyna Micro. Modifications made\r'
		fcc 'by Lost Wizard Enterprises\r'
		fcc 'Incorporated copyright 2015.\r'
		fcn '\r' 
                
; This is the resume command
PRESUME		ldx PDSPMD		; restore the dungeon display routine
		stx DSPMOD
		SWI                     ;initial view
		FCB     INIVU			; redisplay dungeon
		dec HBEATF			; enable heartbeat
		clr SLEEP			; re-enable scheduler
		clr PAUSED			; turn off pause mode
		rts

PCREDITS        ldx #credits			; point to credits text
; This renders text to the dungeon area
prendertext	ldu #TXTEXA			; point to info area
		dec TXBFLG			; set to nonstandard text rendering
		jsr putstr			; display the string
		clr TXBFLG			; restore text rendering
		rts