;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is an autostart loader. Theoretically, when LOADM completes, control should come here. It works by intercepting the
; RAM vector used by the Basic line input routine. Once Daggorath starts, that routine is never used for anything. Also, under
; both versions of Disk Basic, even though it is hooked by them it does nothing (just RTS). By setting the execution address
; also to LOADER, it means that even if, for some reason, control doesn't transfer here, EXEC will still do so.
LOADER		clr $FF40			; turn off drive motors
		jmp ONCE			; transfer control to the main stream code
		org $182			; address of RVEC12
		jmp LOADER			; transfer control to our loader
		end LOADER
