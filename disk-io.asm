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
