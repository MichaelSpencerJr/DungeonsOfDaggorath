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
                rts
; This is the puase mode command handler
pausemodecmd	ldx #kwlist_pcmd		; point to command list
		jsr PARSER			; look up word in command list
		beq pausemode000		; brif nothing to match
		bpl pausemode001		; brif found
		jsr CMDERR			; show bad command string
pausemode000	jmp HMAN70			; go on with new command
pausemode001	lsla				; two bytes per jump table entry
		ldx #pausecmd_jump		; point to command jump table
		jsr [a,x]			; go handle command
		jmp HMAN70			; go handle new command
; Pause mode command list
kwlist_pcmd	fcb 1
		fcb 0				; RESUME
		fcn 'RESUME'
; Pause mode command jump table
pausecmd_jump	fdb pcmd_resume			; RESUME command
; This is the resume command
pcmd_resume	SWI                             ;update the screen
                FCB     STATUS                  ; update the status line
		dec HBEATF			; enable heartbeat
		clr SLEEP			; re-enable scheduler
		clr PAUSED			; turn off pause mode
		rts
