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
                fdb 6				; type 6
		fdb CMXEND			; save as offset into creature table
; This one is for handling broken save game data from a previous buggy version.
		fdb CMOVE			; creature movement handler
		fdb CMXEND-3			; bad type value
		fdb CCBLND+$9B			; offset into creature table
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
