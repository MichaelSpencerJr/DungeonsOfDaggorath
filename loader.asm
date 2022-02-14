; This is an autostart loader. Theoretically, when LOADM completes, control should come here. It works by intercepting the
; RAM vector used by the Basic line input routine. Once Daggorath starts, that routine is never used for anything. Also, under
; both versions of Disk Basic, even though it is hooked by them it does nothing (just RTS). By setting the execution address
; also to LOADER, it means that even if, for some reason, control doesn't transfer here, EXEC will still do so.
LOADER		clr $FF40			; turn off drive motors
		lda #$7e			; opcode for JMP extended
		ldx #error_hook			; point to the error handler
		sta $191			; set up handler for the error routine at AC46
		stx $192
		ldx $C004			; get DSKCON address pointer
		ldy #$8955			; point to IRQ handler
		cmpx #$D75F			; is it disk basic 1.1?
		beq load_disk11			; brif so
		cmpx #$d66c			; is it disk basic 1.0?
		beq load_disk10			; brif so
		ldx #disk_error			; point to the routine for no disk system
		ldu #disk_error
		bra load_001			; go finish initializing
load_disk10	ldx #$C956			; address of "open system file for output" routine
		ldu #$C959			; address of "open system file for input" routine
		ldy #$d7c4			; point to Disk IRQ handler
		bra load_000			; go set vectors
load_disk11	ldx #$CA04			; address of "open system file for output" routine
		ldu #$CA07			; address of "Open system file for input" routine
		ldy #$d8b7			; point to Disk IRQ handler
load_000	stx hook_openo			; save address of "open for output"
		stu hook_openi			; save address of "open for input"
		sty hook_irq			; save IRQ hook for Basic
load_001	clr error_handler		; mark the error handler as disabled
		clr error_handler+1
		jmp ONCE			; transfer control to the main stream code
