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
		sta ,s				; save return value
		bsr restore_dp			; reset DP
		clrb				; reset C for no error
		puls d,x,y,u,pc			; restore registers and return
; This is the IO error handler for file I/O
file_ioerror	bsr restore_dp			; reset DP properly
		bsr file_close			; close the file
		comb				; flag error
		puls d,x,y,u,pc			; restore registers and return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Save a game to disk. This is different to the tape save scheme in the original ROM. Instead of simply doing a raw dump
; of the game state, this routine uses a more structured approach and only saves what is required.
;
; Enter with the file name at U. The game will be saved to the default drive as understood by Disk Basic.
;
; Exit with C clear if no error and C set if error.
save_game	pshs d,x,y,u			; save registers
		jsr loadsave_setfn		; set up file name
		jsr PIATAP      		; turn off IRQs etc
		ldd #$0100			; set to "binary data" format
		jsr file_openo			; open file for output
		beq save_game004		; brif no error opening file
save_gameerr	jsr IRQSYN      		; turn IRQs back on
		coma				; flag error on save
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
		ldy #OCBLND-OC.LEN		; point to object table
save_game007	leay OC.LEN,y			; move to next object
		cmpy OCBPTR			; are we at the  end of the object table?
		bhs save_game008		; brif so
		ldd ,y				; get "next object" pointer
		jsr save_writeobj		; write object identifier
		ldb #12				; 12 bytes remaining in object data
		leax 2,y			; point to rest of object data
		bsr file_writen			; write that data out
		bra save_game007		; go handle another object
save_game008	ldy #CCBLND-CC.LEN		; point to creature table
save_game009	leay CC.LEN,y			; move to next creature entry
		cmpy #CCBLND+(CC.LEN*32)	; at the end of the creature table?
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
save_game010	ldx #QUEBEG			; point to scheduling lists
save_game011	ldd ,x++			; fetch list head
		bsr save_writesched		; write a scheduling pointer
		cmpx #QUEEND	        	; done all lists?
		blo save_game011		; brif not
		ldd TCBPTR	        	; get top of scheduling table
		bsr save_writesched		; write it too
		ldy #TCBLND-TC.LEN		; point to start of scheduling table
save_game012	leay TC.LEN,y			; move to next entry
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
		cmpx #MAZEND    		; end of map?
		blo save_game018		; brif not
		jsr file_close			; close the disk file
		lbne save_gameerr		; brif error closing (writing buffer failed)
		jsr IRQSYN      		; turn IRQs back on
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
loadsave_setfn	ldb #8				; 8 characters max for file name
		ldx #DNAMBF			; point to file name location
loadsave_setfn0	lda ,u+				; fetch character from file name
		bmi loadsave_setfn1		; brif end of specified name
		adda #$40			; adjust back to ASCII range
		sta ,x+				; put character in buffer
		decb				; have we reached the end of the buffer?
		bne loadsave_setfn0		; brif not
		bra loadsave_setfn3		; go set extension
loadsave_setfn1	lda #32				; set up to fill remainder with spaces
loadsave_setfn2	sta ,x+				; put a space
		decb				; buffer full yet?
		bne loadsave_setfn2		; brif not
loadsave_setfn3	ldd #'D*256+'O			; set up to place extension
		std ,x++			; set first two characters of the extension
		sta ,x				; set last character of the extension
		rts				; return to caller
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load a game from disk, in the same format as save_game above.
;
; Enter with the file name at U. The game will be saved to the default drive as understood by Disk Basic.
;
; Exit with C clear if no error and C set if error.
load_game	clrb				; mark current game still valid
		pshs d,x,y,u			; save registers
		bsr loadsave_setfn		; set up the file name correctly
		jsr PIATAP      		; disable IRQs, etc.
		jsr file_openi			; open file for output
		beq load_game004		; brif no error opening file
		bra load_gameerrx		; throw error if open failed
load_gameerr	jsr file_close			; close the file if it's open
load_gameerrx	jsr IRQSYN      		; turn IRQs back on
		coma				; flag error on save
		puls d,x,y,u,pc			; return to caller
file_readn	jsr file_read			; read byte
		bcs file_readn001		; brif error
		tst CINBFL			; was there anything to read?
		bne file_readn000		; brif not
		sta ,x+				; save byte in buffer
		decb				; done reading?
		bne file_readn			; brif not
		rts				; return success
file_readn000	coma				; set carry for failed read
file_readn001	rts				; return failure
load_game004	ldu #save_vartab		; point to static variable list
		ldb ,u				; get number of bytes in magic number
		negb				; make a hole on the stack
		leas b,s
		leax ,s				; point to hole on stack
		ldb ,u				; get length back
		bsr file_readn			; read the magic number
		bcs load_gameerr		; brif error
		ldb ,u+				; get the actual number of bytes again
		ldy ,u++			; point to actual magic number
		leax ,s				; point back to read buffer
load_game004a	lda ,x+				; get character read
		cmpa ,y+			; does it match?
		beq load_game004b		; brif not - not a valid save game
		ldb -3,u			; get size of string
		leas b,s			; clean up stack
		bra load_gameerr		; go propagate error
load_game004b	decb				; compared all?
		bne load_game004a		; brif not
		ldb -3,u			; get back length
		leas b,s			; restore stack
		inc 1,s				; mark game no longer recoverable
load_game005	ldb ,u+				; get number of bytes to save
		beq load_game006		; brif end of table
		ldx ,u++			; get address of variables
		bsr file_readn			; read bytes from file
		bcs load_gameerr		; brif error writing
		bra load_game005		; go handle another entry
load_game006	jsr load_readobj		; read an object pointer
		std PLHAND			; set left hand object
		jsr load_readobj		; read an object pointer
		std PRHAND			; set right hand object
		jsr load_readobj		; read an object pointer
		std PTORCH			; set the current torch
		jsr load_readobj		; read an object pointer
		std BAGPTR			; set first item in backpack
		jsr load_readobj		; read object pointer
		std OCBPTR			; set top of object table
		ldy #OCBLND-14		; point to object table
load_game007	leay 14,y			; move to next object
		cmpy OCBPTR			; are we at the end of the object table?
		bhs load_game008		; brif so
		jsr load_readobj		; read object pointer
		std ,y				; save "next object" pointer
		ldb #12				; 12 bytes remaining in object data
		leax 2,y			; point to rest of object data
		bsr file_readn			; read rest of object data
		lbcs load_gameerr		; brif read error
		bra load_game007		; go handle another object
load_game008	ldy #CCBLND-CC.LEN		; point to creature table
load_game009	leay CC.LEN,y			; move to next creature entry
		cmpy #CCBLND+(CC.LEN*32)	; at the end of the creature table?
		bhs load_game010		; brif so
		leax ,y				; point to start of creature data
		ldb #8				; first 8 bytes need no adjusting
		jsr file_readn			; save first 8 bytes
		lbcs load_gameerr		; brif read error
		jsr load_readobj		; read object pointer
		std 8,y				; save creature inventory pointer
		leax 10,y			; point to remainder of object data
		ldb #7				; there are 7 more bytes
		jsr file_readn			; load the remainder
		lbcs load_gameerr		; brif read error
		bra load_game009		; go handle another creature
load_game010	ldx #QUEBEG			; point to scheduling lists
load_game011	jsr load_readsched		; read a scheduling pointer
		std ,x++			; set scheduling list
		cmpx #QUEEND	        	; done all lists?
		blo load_game011		; brif not
		bsr load_readsched		; read scheduling pointer
		std TCBPTR	        	; set top of scheduling table
		ldy #TCBLND-TC.LEN			; point to start of scheduling table
load_game012	leay TC.LEN,y			; move to next entry
		cmpy TCBPTR     		; end of table?
		bhs load_game017		; brif so
		bsr load_readsched		; read scheduling pointer
		std ,y				; set pointer to next entry
		jsr load_read			; read tick count value
		lbcs load_gameerr		; brif read error
		sta 2,y				; save ticks count
		jsr load_readw			; read a word from file
		lbcs load_gameerr		; brif error
		ldu #save_schedtab		; point to handler fixups
load_game013	cmpd 2,u			; does the handler pointer match?
		beq load_game014		; brif so
		leau 6,u			; move to next entry
		cmpu #save_schedtabe		; end of table?
		lbhs load_gameerr		; brif not found - corrupted file
		bra load_game013		; go see if it matches now
load_game014	ldd ,u				; fetch actual routine address
		std 3,y				; save it in the scheduling entry
		bsr load_readw			; read the private data
		lbcs load_gameerr		; brif error reading data
		addd 4,u			; add in private data bias
		std 5,y				; save in scheduler entry
		bra load_game012		; go save the next scheduling entry
load_game017	ldx #MAZLND			; point to map data
load_game018	bsr load_read			; read a byte
		lbcs load_gameerr		; brif error reading
		sta ,x+				; save maze data
		cmpx #MAZEND    		; end of map?
		blo load_game018		; brif not
		jsr file_close			; close the disk file
		lbne load_gameerr		; brif error closing (writing buffer failed)
		jsr NLVL50			; set up backgrounds correctly
		lda LEVEL	        	; get current level
		ldb #CTYPES			; number of entries in creature count table
		mul				; calculate offset to creature counts for this level
		addd #CMXLND    		; point to correct creature count table for this level
		std CMXPTR      		; save pointer to creature count table for the correct level
		ldx #VFTTAB			; point to hole/ladder table
		ldb LEVEL	        	; fetch current level
load_game019	stx VFTPTR			; save hole/ladder data pointer
load_game020	lda ,x+				; fetch flag
		bpl load_game020		; brif we didn't consume a flag
		decb				; are we at the right set of data for the level?
		bpl load_game019		; brif not - save new pointer and search again
		jsr IRQSYN      		; turn IRQs back on
		clra				; clear carry for success
		puls d,x,y,u,pc			; restore registers and return
load_readsched	ldd #TCBLND			; set the bias for the read
		bra load_readsched0		; go read the adjusted word
load_readobj	ldd #OCBLND			; set the bias for the read
load_readsched0	pshs d				; save bias
		bsr load_readw			; read a word from the file
		bcs load_gameerr0		; brif error reading
		cmpd #$ffff			; is it a NULL?
		bne load_readobj1		; brif not
		clra				; set result to NULL
		clrb
		leas 2,s			; remove bias
		rts				; return result to caller
load_readobj1	addd ,s++			; add the bias in
		rts				; return result to caller
load_gameerr0	leas 4,s			; lose caller and saved bias
		jmp load_gameerr		; go return the error
load_readw	bsr load_read			; read the first byte
		bcs load_readw000		; brif error
		tfr a,b				; save first byte
		bsr load_read			; read second byte
		exg a,b				; put bytes in right order
load_readw000	rts				; return to caller
load_read	jsr file_read			; read a byte
		bcs load_read000		; brif error
		tst CINBFL			; was there something to read?
		beq load_read000		; brif so
		coma				; set carry for nothing to read
load_read000	rts				; return to caller
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
save_schedtabe	equ *				; end of table marker
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
