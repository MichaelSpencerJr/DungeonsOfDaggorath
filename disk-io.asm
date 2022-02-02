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
		clrb				; reset C for no error
		bsr error_cleartrap		; clear the error trap
		puls b,x,y,u,pc			; restore registers and return
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Save a game to disk. This is different to the tape save scheme in the original ROM. Instead of simply doing a raw dump
; of the game state, this routine uses a more structured approach and only saves what is required.
;
; The initial process is to freeze the game (by stopping the IRQ). Then it saves the various variables as required according to
; the specified list. Once those are done, the more complex structures are saved with adjustments as required.
;
; Enter with the file name at U. The game will be saved to the default drive as understood by Disk Basic.
;
; Exit with C clear if no error and C set if error.
save_game	pshs d,x,y,u			; save registers
		ldb #8				; copy 8 bytes for the file name
		ldx #DNAMBF			; point to file name buffer
save_game000	lda ,u+				; get character from file name
		bmi save_game001		; brif end of name
		adda #$40			; restore to upper case ASCII
		sta ,x+				; save filename character
		decb				; max name size?
		bne save_game000		; brif not
		bra save_game003		; get on with saving
save_game001	lda #32				; code for space
save_game002	sta ,x+				; put a space in the file name
		decb				; end of file name?
		bne save_game002		; brif not
save_game003	ldd #'D*256+'O			; set extension to "DOD"
		std ,x++
		sta ,x
		ldd #$0100			; set to "binary data" format
		jsr file_openo			; open file for output
		beq save_game004		; brif no error opening file
save_gameerr	coma				; flag error on save
		puls d,x,y,u,pc			; return to caller
file_writen	lda ,x+				; get byte to write
		bsr file_write			; write byte to file
		bcs file_writen000		; brif error
		decb				; done yet?
		bne file_writen			; brif not
file_writen000	rts				; return (C is already set correctly)
save_game004	ldu #save_vartab		; point to static variable list
save_game005	ldb ,u+				; get number of bytes to save
		beq save_game006		; brif end of table
		ldx ,u++			; get address of variables
		bsr file_writen			; write the bytes to the file
		bcs save_gameerr		; brif error writing
		bra save_game005		; go handle another entry
save_game006	ldd PLHAND			; fetch object in left hand
		jsr save_writeobj		; write object identifier
		ldd PRHAND			; fetch object in right hand
		jsr save_writeobj		; write object identifier
		ldd PTORCH			; fetch current torch
		jsr save_writeobj		; write object identifier
		ldd BAGPTR			; fetch first item in backpack
		jsr save_writeobj		; write object identifier
		ldd OCBPTR			; get object table
		jsr save_writeobj		; write object identifier
		ldy #OCBLND-14	        	; point to object table
save_game007	leay 14,y			; move to next object
		cmpy OCBPTR			; are we at the  end of the object table?
		bhs save_game008		; brif so
		ldd ,y				; get "next object" pointer
		jsr save_writeobj		; write object identifier
		ldb #12				; 12 bytes remaining in object data
		leax 2,y			; point to rest of object data
		bsr file_writen			; write that data out
		bra save_game007		; go handle another object
save_game008	ldy #CMXEND-17	        	; point to creature table
save_game009	leay 17,y			; move to next creature entry
		cmpy #CMXEND+(17*32)	        ; at the end of the creature table?
		bhs save_game010		; brif so
		leax ,y				; point to start of creature data
		ldb #8				; first 8 bytes need no adjusting
		bsr file_writen			; save first 8 bytes
		ldd 8,y				; get inventory pointer
		bsr save_writeobj		; write an object pointer
		leax 10,y			; point to remainder of object data
		ldb #7				; there are 7 more bytes
		bsr file_writen			; save the remainder
		bra save_game009		; go handle another creature
save_game010	ldx #NULQUE			; point to scheduling lists
save_game011	ldd ,x++			; fetch list head
		bsr save_writesched		; write a scheduling pointer
		cmpx #NULQUE+14	        	; done all lists?
		blo save_game011		; brif not
		ldd TCBPTR	        	; get top of scheduling table
		bsr save_writesched		; write it too
		ldy #TCBLND-7			; point to start of scheduling table
save_game012	leay 7,y			; move to next entry
		cmpy TCBPTR	        	; end of table?
		bhs save_game017		; brif so
		ldd ,y				; get pointer to next entry
		bsr save_writesched		; write adjusted pointer
		lda 2,y				; save the ticks count to wait
		jsr file_write
		lbcs save_gameerr		; brif write failed
		ldx 3,y				; get handler address
		ldu #save_schedtab		; point to handler fixups
save_game013	cmpx ,u				; does the handler pointer match?
		beq save_game014		; brif so
		leau 6,u			; move to next entry
		bra save_game013		; go see if it matches now
save_game014	ldd 2,u				; fetch marker
		bsr file_writew			; write word to file
		lbcs save_gameerr		; brif write failed
		ldd 5,y				; fetch the private data
		subd 4,u			; add correction factor to turn into offset
		bsr file_writew			; write the last word out
		bra save_game012		; go save the next scheduling entry
save_game017	ldx #MAZLND			; point to map data
save_game018	lda ,x+				; fetch byte
		jsr file_write			; send to file
		lbcs save_gameerr		; brif write failed
		cmpx #MAZLND+1024		; end of map?
		blo save_game018		; brif not
		jsr file_close			; close the disk file
		lbne save_gameerr		; brif error closing (writing buffer failed)
		clra				; clear carry for success
		puls d,x,y,u,pc			; restore registers and return
save_writesched	subd #TCBLND			; adjust to offset in scheduling table
		bra save_writeschd0		; go finish writing the word
save_writeobj	subd #OCBLND			; convert to offset in object table
save_writeschd0	bcc save_writeobj0		; brif no wrap - write it out
		ldd #$ffff			; flag the "NULL"
save_writeobj0	bsr file_writew			; write word
		bcs save_gameerr0		; brif failed
		rts				; return to caller
save_gameerr0	leas 2,s			; lose caller
		jmp save_gameerr		; go return the error
file_writew	jsr file_write			; write the first byte
		bcs file_writew000		; brif error
		tfr b,a				; get second byte
		jsr file_write			; write it
file_writew000	rts				; return to caller
save_schedtab	fdb PLAYER			; keyboard processor
		fdb 1				; type 1
		fdb 0				; save remainder as is
		fdb LUKNEW			; dungeon display update
		fdb 2				; type 2
		fdb 0				; save remainder as is
		fdb HSLOW			; damage healing tick
		fdb 3				; type 3
		fdb 0				; save remainder as is
		fdb BURNER			; active torch handler
		fdb 4				; type 4
		fdb 0				; save remainder as is
		fdb CREGEN			; revenge monster creator
		fdb 5				; type 5
		fdb 0				; save remainder as is
		fdb CMOVE			; creature movement hanlder
		fdb CMXEND			; save as offset into creature table
save_magic	fcc 'DoDL'			; magic number
		fcb 1				; save game version
; This is the table of variables to save "as is". Each entry is an 8 bit length followed by a 16 bit address. A length of 0
; indicates the end of the table.
save_vartab	fcb 5				; length of magic number and file version
		fdb save_magic
		fcb 6				; this is for playerloc, carryweight, and powerlevel
		fdb PROW
		fcb 3				; damage level and direction facing
		fdb PDAM
		fcb 2				; baselight
		fdb PRLITE
		fcb 1				; creaturefreeze
		fdb FRZFLG
		fcb 2				; soundseqseed
		fdb SNDRND
		fcb 3				; randomseed
		fdb SEED
		fcb 1				; currentlevel
		fdb LEVEL
		fcb 6				; clock counters
		fdb TIMBEG
		fcb 3				; heartctr, heartticks, heartstate
		fdb HEARTC
		fcb 60				; creaturecounts
		fdb CMXLND
		fcb 0				; end of table
