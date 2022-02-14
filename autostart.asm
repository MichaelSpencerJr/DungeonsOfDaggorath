; This is the bit that intercepts RVEC12. It requires at least Extended Basic to work because it relies on multi-origin binaries.
; That will always be the case for Disk Basic. Theoretically, with just this, a loader will work from tape in Extended Basic
; or higher, too.
		org $182			; address of RVEC12
		jmp LOADER			; transfer control to our loader
; In case RVEC12 doesn't trigger for some reason, this allows EXEC to also start the loader.
		end LOADER
