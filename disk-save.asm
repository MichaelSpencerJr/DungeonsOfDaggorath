;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Save a game to disk. This is different to the tape save scheme in the original ROM. Instead of simply doing a raw dump
; of the game state, this routine uses a more structured approach and only saves what is required.
;
; Enter with the file name at U. The game will be saved to the default drive as understood by Disk Basic.
;
; Exit with C clear if no error and C set if error.
save_game	pshs d,x,y,u			; save registers
		jsr loadsave_setfn		; set up file name
		jsr PIATAP      		; reset PIAs to Basic mode
		ldd #$0100			; set to "binary data" format
		jsr file_openo			; open file for output
		beq save_game004		; brif no error opening file
save_gameerr	jsr IRQSYN      		; restore PIAs to daggorath mode
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
		jsr IRQSYN      		; restore PIAs to daggorath mode
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
		beq loadsave_setfn1		; brif end of specified name
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
