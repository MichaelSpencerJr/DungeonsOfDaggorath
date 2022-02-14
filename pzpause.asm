;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is the "pause mode". Pause mode has a completely different list of commands available to it.
PZPAUS	        inc ZFLAG       		; freeze the game
		SWI                             ;clear the status line
                FCB     CLRSTS          	; clear the status bar
		ldu #TXTSTS			; point to status area parameters
		dec TXBFLG			; set to nonstandard rendering
		ldd #11				; offset to centre "**PAUSED**"
		std 4,u				; set offset into area
		jsr putstrimm			; display the pause notice
		fcn '**PAUSED**'
		clr TXBFLG			; reset display parameters
PZPA00  	bra *
