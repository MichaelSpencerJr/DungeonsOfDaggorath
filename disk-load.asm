;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load a game from disk, in the same format as save_game above.
;
; Enter with the file name at U. The game will be saved to the default drive as understood by Disk Basic.
;
; Exit with C clear if no error and C set if error.
load_game	clrb				; mark current game still valid
		pshs d,x,y,u			; save registers
		bsr loadsave_setfn		; set up the file name correctly
		jsr PIATAP      		; set up PIA for Basic I/O
		jsr file_openi			; open file for output
		beq load_game004		; brif no error opening file
		bra load_gameerrx		; throw error if open failed
load_gameerr	jsr file_close			; close the file if it's open
load_gameerrx	jsr IRQSYN      		; restore PIAs to daggorath mode
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
		jsr IRQSYN      		; restore PIAs to daggorath mode
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
