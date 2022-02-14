;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The code in this area is the general file I/O handling system. It contains various bits to call into the Disk Basic ROM as
; required to handle opening and closing files, etc.
;
; These routines hook the Basic error handler to prevent crashing. The way this works is a routine that wishes to trap errors
; loads the address of its error handler in X and calls error_settrap. The error_settrap routine will record the requested handler
; and the stack pointer for the caller. NOTE: only one error handler can be active at a time.
;
; The error handler can assume the stack pointer is at the exact place where it was when the parent routine called error_settrap
; and should do whatever cleanup it needs to do then return normally (RTS or equivalent). When an error handler is triggered,
; the error trap is cleared automatically. If no error is triggered, the routine that installed the handler must remove it
; by calling error_cleartrap.
;
; The error handler can expect the error code from Basic doubled in B.
;
; The error handler can also assume the direct page has been restored as well.
;
; If the error system is triggered without a handler in place, it will trigger a cold start by jumping to the RESET vector
; address. This should work on both a coco1/2 and a coco3.
;
; This routine is called for disk routine traps if there is no recognized version of Disk Basic.
disk_error	ldb #255			; internal error code equivalent of "ENOSYS"
; fall through to error handler is intentional.
; This is the error handler.
error_hook	ldx error_handler		; is there a handler registered?
		bne error_hook000		; brif so
		clr RSTFLG			; force Basic to do a cold start
		jmp [$FFFE]			; force a reset if we got an error we weren't expecting
error_hook000	lds error_stack			; reset the stack to a known state
		bsr restore_dp			; reset the direct page
		bsr error_cleartrap		; clear the error trap on error
		jsr slowclock			; force slow clock mode
		jmp ,x				; transfer control to the handler
; This is the routine that installs a handler and the cleanup routine.
error_settrap	stx error_handler		; set the handler
		puls y				; get back caller so the stack is in the right place
		sts error_stack			; save the stack pointer for recovery
		jmp ,y				; return to caller
; This is the shim routine that clean out the error handler.
error_cleartrap	pshs cc				; save flags
		clr error_handler		; clear the hander
		clr error_handler+1
		puls cc,pc			; return to original caller
; This routine opens a file for INPUT. If the file does not exist or cannot be opened for some reason, it will return
; nonzero. Otherwise it returns zero. Enter with filename/extension in DNAMBF. On return,
; DEVNUM will be set to the correct file number.
file_openi	pshs d,x,y,u			; save registers
		ldx #file_openerr		; point to error handler for opening files
		bsr error_settrap		; set Basic error handler
		bsr set_basdp			; set direct page for Basic call
		jsr [hook_openi]		; go call the file open handler in ROM
		bsr restore_dp			; restore direct page
		jsr slowclock			; force slow down
		clra				; set Z for success
		bsr error_cleartrap		; clear the error trap
		puls d,x,y,u,pc			; restore registers and return
; This routine opens a file for OUTPUT. If the file does not exist or cannot be opened for some reason, it will return
; nonzero. Otherwise it returns zero. Enter with filename/extension in DNAMBF. On return,
; DEVNUM will be set to the correct file number. Enter with the type of file in A and the ascii flag in B.
file_openo	pshs d,x,y,u			; save registers
		std DFLTYP			; set file type and ASCII flag
		ldx #file_openerr		; point to error handler for opening files
		bsr error_settrap		; set Basic error handler
		bsr set_basdp			; set direct page for Basic call
		jsr [hook_openo]		; go call the file open handler in ROM
		bsr restore_dp			; restore direct page
		jsr slowclock			; force slow down
		clra				; set Z for success
		bsr error_cleartrap		; clear the error trap
		puls d,x,y,u,pc			; restore registers and return
; This is the error handler for opening files, both input and output.
file_openerr	bsr restore_dp			; restore direct page
		lda #1				; clear Z
		puls d,x,y,u,pc			; restore registers and return
; This routine sets the direct page properly for a Basic call
set_basdp	pshs a				; save register
		clra				; basic's DP is on page 0
		tfr a,dp			; set DP
		puls a,pc			; restore registers and return
; This routine restores the direct page properly for Daggorath
restore_dp	pshs cc,a			; save flags and temp
		lda #DP.BEG/256			; get proper DP value
		tfr a,dp			; set DP
		puls cc,a,pc			; restore registers and return
; This routine closes the currently open file. It returns Z set on success and clear on error.
; Enter with the file number in DEVNUM.
file_close	ldx #file_openerr		; use the same generic handler for failure as opening
		bsr error_settrap		; register error handler
		bsr set_basdp			; set up DP correctly
		jsr $A426			; call the "close one file" handler
		jsr slowclock			; force slow down
		clra				; set Z for success
		bsr error_cleartrap		; clear the error trap
		bra restore_dp			; restore DP and return
; This routine writes the byte in A to the currently open file.
; In the event of an error, return C set and close the file. Otherwise, return C clear.
file_write	pshs b,x,y,u			; save registers
		ldx #file_ioerror		; pointer to IO error trap
		jsr error_settrap		; set the trap
		bsr set_basdp			; set up DP properly
		jsr $A282			; write byte
		bsr restore_dp			; restore direct page
		jsr slowclock			; force slow down
		clrb				; reset C for no error
		jsr error_cleartrap		; clear the error trap
		puls b,x,y,u,pc			; restore registers and return
; This routine reads a byte from the currently open file and returns it in A.
; In the event of an error, return C set and close the file. Otherwise, return C clear.
; On EOF, CINBFL will be nonzero.
file_read	pshs d,x,y,u			; save registers
		ldx #file_ioerror		; pointer to IO error handler
		jsr error_settrap		; set error handler
		bsr set_basdp			; set up DP correctly
		jsr $A176			; go read a character
		sta ,s				; save return value
		bsr restore_dp			; reset DP
		jsr slowclock			; force slow down
		clrb				; reset C for no error
		puls d,x,y,u,pc			; restore registers and return
; This is the IO error handler for file I/O
file_ioerror	bsr restore_dp			; reset DP properly
		bsr file_close			; close the file
		comb				; flag error
		puls d,x,y,u,pc			; restore registers and return
