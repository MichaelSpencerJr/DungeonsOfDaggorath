; The code in this area is the general file I/O handling system. It contains various bits to call into the Disk Basic ROM as
; required to handle opening and closing files, etc.
;
; These routines hook the Basic error handler to prevent crashing. The way this works is a routine that wishes to trap errors
; loads the address of its error handler in X and calls error_settrap. The error_settrap routine will record the requested handler
; and install an extra routine that gets called when the caller returns. NOTE: only one error handler can be in play at a time.
; The error handler can assume the stack pointer is at the exact place where it was when the parent routine called error_settrap
; and should do whatever cleanup it needs to do then return normally (RTS or equivalent). In both the normal return case and
; the error handler returning, the extra shim routine will be called to remove the installed error handler.
;
; The error handler can expect the error code from Basic doubled in B.
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
		jmp ,x				; transfer control to the handler
; This is the routine that installs a handler and the cleanup routine.
error_settrap	stx error_handler		; set the handler
		puls y				; get the return address back
		ldx #error_return		; point to the trap cleanup routine
		pshs x				; set so we return there
		sts error_stack			; save the stack pointer for recovery
		jmp ,y				; return to caller
; This is the shim routine that clean out the error handler.
error_return	pshs cc				; save flags
		clr error_handler		; clear the hander
		clr error_handler+1
		puls cc,pc			; return to original caller
; This routine opens a file for INPUT. If the file does not exist or cannot be opened for some reason, it will return
; nonzero. Otherwise it returns zero. Enter with U pointing to the filename/extension (11 characters). On return,
; DEVNUM will be set to the correct file number.
file_openi	pshs d,x,y,u			; save registers
		ldb #11				; copy 11 bytes
		ldx #DNAMBF			; point to requested file name
file_openi000	lda ,u+				; copy a byte
		sta ,x+
		decb				; done?
		bne file_openi000		; brif not
		ldx #file_openerr		; point to error handler for opening files
		bsr error_settrap		; set Basic error handler
		bsr set_basdp			; set direct page for Basic call
		jsr [hook_openi]		; go call the file open handler in ROM
		bsr restore_dp			; restore direct page
		clra				; set Z for success
		puls d,x,y,u,pc			; restore registers and return
; This routine opens a file for OUTPUT. If the file does not exist or cannot be opened for some reason, it will return
; nonzero. Otherwise it returns zero. Enter with U pointing to the filename/extension (11 characters). On return,
; DEVNUM will be set to the correct file number. Enter with the type of file in A and the ascii flag in B.
file_openo	pshs d,x,y,u			; save registers
		std DFLTYP			; set file type and ASCII flag
		ldb #11				; copy 11 bytes
		ldx #DNAMBF			; point to requested file name
file_openo000	lda ,u+				; copy a byte
		sta ,x+
		decb				; done?
		bne file_openo000		; brif not
		ldx #file_openerr		; point to error handler for opening files
		bsr error_settrap		; set Basic error handler
		bsr set_basdp			; set direct page for Basic call
		jsr [hook_openo]		; go call the file open handler in ROM
		bsr restore_dp			; restore direct page
		clra				; set Z for success
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
		clra				; set Z for success
		bra restore_dp			; restore DP and return
; This routine writes the byte in A to the currently open file.
; In the event of an error, return C set and close the file. Otherwise, return C clear.
file_write	pshs b,x			; save registers
		ldx #file_ioerror		; pointer to IO error trap
		jsr error_settrap		; set the trap
		bsr set_basdp			; set up DP properly
		jsr $A282			; write byte
		bsr restore_dp			; restore direct page
		clrb				; reset C for no error
		puls b,x,pc			; restore registers and return
; This routine reads a byte from the currently open file and returns it in A.
; In the event of an error, return C set and close the file. Otherwise, return C clear.
; On EOF, CINBFL will be nonzero.
file_read	pshs d,x,y,u			; save registers
		ldx #file_ioerror		; pointer to IO error handler
		jsr error_settrap		; set error handler
		bsr set_basdp			; set up DP correctly
		jsr $A176			; go read a character
		bsr restore_dp			; reset DP
		clrb				; reset C for no error
		puls b,x,pc			; restore registers and return
; This is the IO error handler for file I/O
file_ioerror	bsr restore_dp			; reset DP properly
		bsr file_close			; close the file
		comb				; flag error
		puls d,x,y,u,pc			; restore registers and return
