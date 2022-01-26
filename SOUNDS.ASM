;        TTL SOUNDS - Sound Generator
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S O U N D   G E N E R A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;  SOUNDS: Sound Generation Routine
;          Called via COMSWI.
;
;  Inputs:
;       A - sound identification code
;       B - volume level
;
;
; "Actual" sounds entry point
;
SOUNDI  LDX     12,S            ;load return addr
        LDA     ,X+             ;load SOUND parameter byte
        STX     12,S            ;update return addr
        LDB     #$FF            ;use full volume
;
SOUNDX  EQU     *
        STB     SNVOL           ;store volume parameter
        LDX     #SNDTAB         ;table base addr
        LSLA                    ;*2 for word offsets
        JSR     [A,X]           ;dispatch to correct routine
        CLR     P.PIIOA+PIA$1   ;leave DAC at zero
        RTS                     ;bye



;
;  Sound Dispatch Macros
;
SND     MACR
A$\1    EQU     FOO
FOO     SET     FOO+1
;        XDEF    A$\1
        FDB     \2
        ENDM
;
FOO     SET     0
;
;  Sound Dispatch Table
;
SNDTAB  EQU     *               ;table starts here
;
;  Creature Sounds
;
        SND     SQK0,SQUEAK     ;spider
;
        SND     RTL0,RATTLE     ;viper
;
        SND     ROR0,GROWL      ;stone giant 1
;
        SND     BEP0,BEOOP      ;blob
;
        SND     KLK0,KLANK      ;knight 1
;
        SND     ROR1,GRAWL      ;stone giant 2
;
        SND     RTL1,PSSST      ;scorpion
;
        SND     KLK1,KKLANK     ;knight 2
;
        SND     PSHT,PSSHT      ;wraith
;
        SND     ROR2,SNARL      ;balrog
;



        SND     SQK1,BDLBDL     ;wizzard 1
;
        SND     SQK2,BDLBDL     ;wizzard 2
;
;
;
;  Object Sounds
;
SNDOBJ  EQU     12
;
        SND     FLAS,GLUGLG     ;flask
;
        SND     RING,PHASER     ;ring
;
        SND     SCRO,WHOOP      ;scroll
;
        SND     SHIE,CLANG      ;shield
;
        SND     SWOR,WHOOSH     ;sword
;
        SND     TORC,CHUCK      ;torch
;
;
;
;  Miscellaneous Sounds
;
        SND     KLK2,KLINK      ;hit creature
;
        SND     KLK3,CLANK      ;hit player
;
        SND     THUD,THUD       ;hit wall
;



        SND     EXP0,BANG       ;explosion 0
;
        SND     EXP1,KABOOM     ;explosion 1
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S O U N D   G E N E R A T O R S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
; GLUGLG:
;       Flask drinking sound
; PHASER:
;       Ring attack sound
; MSQUEK:
; MSQUEQ:
; WHOOP:
; SQUEAK: Subroutine to produce a short tone sweep of
;         rising pitch.
;
; Usable for small animal squeaks or dripping water
;
; * * * * * * * * *
;
SNBAS1  EQU     *               ;sound base address 1
;
GLUGLG  LDU     #MSQUEQ         ;address of sound subroutine
        LDA     #4              ;iteration count
        BRA     PHAS2           ;
;
PHASER  LDU     #MSQUEK         ;
        LDA     #10             ;iteration count
PHAS2   STA     SNSAVA          ;scratch iteration counter
PHAS1   JSR     ,U              ;call indicated subroutine
        DEC     SNSAVA          ;iteration counter
        BNE     PHAS1           ;loop until done
        RTS
;
MSQUEK  LDX     #$0040          ;
        FCB     $10             ;skip next 3 bytes (LDY)
;
MSQUEQ  LDX     #$0080          ;
        FCB     $10             ;skip next 3 bytes (LDY)
;
WHOOP   LDX     #$0100          ;pitch and duration
        FCB     $10             ;skip next 3 bytes (LDY)
;
SQUEAK  LDX     #$0020          ;pitch and duration
SNSQK1  BSR     SNSQK2          ;
        LEAX    -1,X            ;increase frequency
        BNE     SNSQK1          ;continue
;
        RTS                     ;end of this sound
;
SNSQK2  LDA     #$FF            ;
        BSR     SNSUB2          ;
        CLRA
        BRA     SNSUB2          ;
;
BEOOP   LDX     #$0500          ;
BEOOP1  BSR     SNSQK2          ;
        LEAX    48,X            ;decrease frequency



        CMPX    #$0800          ;
        BLO     BEOOP1          ;
;
        RTS
;



; * * * * * * * * *
;
;  RATTLE: Subroutine to generate a short train of noise
;          pulses. Each pulse is separated from the next
;          by a period of silence.
;
;  Usable for rattlesnake like sounds
;
; * * * * * * * * *
;
PSSST   LDA     #2              ;
        FCB     SKIP2           ;
PSSHT   LDA     #1              ;rattle count +1
        FCB     SKIP2           ;[ sets CCR ]
RATTLE  LDA     #10             ;rattle count + 1
        STA     SNDLAY          ;use as scratch counter in this routine
SNRAT2  LDY     #$00C0          ;noise duration
SNRAT1  BSR     SNOISE          ;get a random noise value
        BSR     SNOUT
        LEAY    -1,Y
        BNE     SNRAT1
;
        BSR     SNWT1K          ;wait: X-Reg. = $1000
;
        DEC     SNDLAY          ;decrement counter
        BNE     SNRAT2
        RTS                     ;end of this sound
;
; Local subroutine for code compression
;
SNSUB3  BSR     SNOISE          ;get some noise
SNSUB2  BSR     SNOUT           ;out to the DAC
        BRA     SNWAIT          ;wait around for a while



; * * * * * * * * *
;
; KABOOM: Double explosion sounds that sounds like "kaboom".
; BANG:
; THUD:
;
; * * * * * * * * *
;
BANG    LDU     #BANGD          ;bang data
        BRA     BOOMER          ;common code
;
THUD    LDU     #THUDD          ;thud data
        BRA     BOOMER          ;common code
;
BDLBDL  LDA     #8              ;whoop count
        STA     SNSAVA          ;   .
BDLB10  BSR     SNOISE          ;make some noise
        CLRA                    ;16-bit random (0-127)
        LSRB                    ;   .
        BNE     BDLB12          ;   insure non-zero!
        INCB                    ;   .
BDLB12  TFR     D,X             ;copy random
        BSR     SNSQK1          ;squeak!
        DEC     SNSAVA          ;decrement and loop
        BNE     BDLB10          ;   fall into KABOOM when thru
;
KABOOM  LDU     #THUDD          ;point to data table
        BSR     BOOMER          ;
        BSR     SNWT1K          ;wait: X-Reg. = $1000
        LEAU    4,u             ;advance to next set of data
;
BOOMER  LDX     ,U              ;set pitch (2022 n.b. original was 0,U)
BOOM1   LDY     2,U             ;
BOOM2   BSR     SNSUB3          ;
        LEAY    -1,Y            ;
        BNE     BOOM2           ;
        LEAX    2,X             ;
        CMPX    #$0150          ;
        BNE     BOOM1           ;
;
        RTS
;



; * * * * * * * * *
;
; CHUCK:
;       Sound of torch lighting
;
; WHOOSH: Subroutine to simulate the sound of something passing
;         rapidly by. This sound is created by passing white noise
;         through an envelope generator with a short attack time
;         followed by a slower decay time.
;
; Useful for the sound of an arrow in flight or the swing of
; a sword, axe, mace, or other such device.
;
; * * * * * * * * *
;
WHOOSH  JSR     SETNVA          ;env. gen. setup routine
        FCB     $80             ;increment
SNWSH2  BSR     SNZNVA          ;get some noise
        BCS     CHUCK           ;goto decay if attack done
        BSR     SNOUT           ;out to DAC
        BRA     SNWSH2          ;continue
CHUCK   JSR     SETNVD          ;envelope generator setup
        FCB     $A0             ;decrement
SNWSH1  BSR     SNENVN          ;decompression subroutine
        BRA     SNWSH1          ;continue
;



;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  S O U N D   G E N E R A T O R   S U P P O R T   S U B R O U T I N E S
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
; * * * * * * * * *
;
; Short period programmable timer subroutine
;
SNWT1K  LDX     #$1000          ;default period entry point
SNWAIT  PSHS    X
SNWAT1  LEAX    -1,X            ;decrement counter
        BNE     SNWAT1          ;done?
SNCLK4  PULS    X,PC            ;
;
; * * * * * * * * *
;
; Sounds - output routine
;
SNOUT   LDB     SNVOL           ;load desired volume level
        MUL
        ANDA    #$FC
        STA     $FF20           ;output to DAC
        RTS
;
;
; * * * * * * * * *
;
; Noise generator
;
SNOISE  LDD     SNDRND
        LSLB                    ;multiply by five
        ROLA
        LSLB
        ROLA
        ADDD    SNDRND
        INCB
        STD     SNDRND          ;save new value
        RTS
;



; * * * * * * * * *
;
; CLANK:
; KLANK:
;
;       Subroutines to generate the sounds of objects striking
;       other objects. This sound is created by playing
;       two tones of a slightly de-tuned 6th harmonic
;       relationship.
;
; Useful for impacts with metal objects, falling objects, etc.
;
; * * * * * * * * *
;
CLANG   BSR     CSETUP          ;
        FCB     $64             ;
        FCB     $24             ;
;
KKLANK  BSR     CSETUP          ;"kklank" setup
        FCB     $32             ;
        FCB     $12             ;
;
KLANK   BSR     CSETUP          ;"klank" setup routine
        FCB     $AF             ;frequency 1
        FCB     $36             ;frequency 2
;
CLANK   BSR     CSETUP          ;"clank" setup routine
        FCB     $19             ;frequency 1
        FCB     $09             ;frequency 2
;
SNCLK5  BSR     SETNVD          ;common env. gen. set-up
        FCB     $60             ;decrement constant
        LDX     FREQ1           ;load frequency 1
        LDY     FREQ2           ;load frequency 2
        CLRA                    ;clear sound sample value
SNCLK2  LEAX    -1,X
        BNE     SNCLK1
        LDX     FREQ1           ;load frequency 1
        EORA    #$7F            ;flip low order 7 bits of sound sample
        BSR     SNCLK3          ;call local subroutine
SNCLK1  LEAY    -1,Y
        BNE     SNCLK2
        LDY     FREQ2           ;load frequency 2
        EORA    #$80            ;flip hi order bit
        BSR     SNCLK3
        BRA     SNCLK2
;
; Local Subroutine
;
SNCLK3  STA     SNSAV           ;save sound sample
        BSR     SNENV           ;
        BLS     SNCLK4          ;
        BSR     SNOUT           ;
        LDA     SNSAV           ;restore sound sample
        RTS



; Local subroutine
;
CSETUP  LDX     ,S++            ;load the stacked PC
        LDB     ,X+             ;load frequency 1
        CLRA                    ;16-bit value
        STD     FREQ1           ;save it
        LDB     ,X+             ;load frequency 2
        STD     FREQ2           ;save it
;
        BRA     SNCLK5          ;force a branch
;
; Compression subroutine
;
SNZNVA  BSR     SNOISE          ;
        BRA     SNENVA          ;
;
; Compression subroutine
;
SNENVN  BSR     SNOISE          ;
SNENVT  BSR     SNENV           ;
        BLS     SNCLK4          ;
        BRA     SNOUT           ;
;
; Local subroutine
;
SETNVD  LDX     NEGONE          ;decay mode setup
        FCB     $10             ;skip next 3 bytes (LDY)
SETNVA  LDX     BIGZER          ;attack mode setup
        STX     SNENVS          ;store starting volume
        LDX     ,S              ;get the PC
        LDB     ,X+             ;load the increment/decrement
        CLRA                    ;16-bit value
        STD     SNENVD          ;store it
        STX     ,S              ;pointer becomes new PC
;
SNLXT1  RTS                     ;return to caller
;



; * * * * * * * * *
;
; KLINK: Subroutine to simulate the metal/metal impact sound
;        of swordplay. This sound is generated by mixing a high
;        pitched tone with white noise. The resultant signal
;        is passed through an envelope generator with an
;        instantaneous rise time, and a short decay time.
;
; Useful for swordplay, knife combat sounds, or the sound of
; light metal objects striking one another such as the opening
; of a door lock.
;
; * * * * * * * * *
;
KLINK   BSR     SETNVD          ;common env. gen. set-up
        FCB     $60             ;decrement constant
SNKLK1  JSR     SNOISE          ;get some noise
        LSRA                    ;(some noise)
        BSR     SNENVT          ;compression subroutine
        JSR     SNOISE          ;get some noise
        ORA     #$80            ;add tone component to sample
        BSR     SNENVT          ;compression subroutine
        BRA     SNKLK1          ;continue
;



; * * * * * * * * *
;
; Snarl/Growl Sound
;
; * * * * * * * * *
;
GROWL   LDX     #$0300          ;parameter
        FCB     $10             ;   skip next 3 bytes (LDY)
;
GRAWL   LDX     #$0200          ;parameter
        FCB     $10             ;   skip next 3 bytes (LDY)
;
SNARL   LDX     #$0100          ;parameter
SNARL1  STX     SNENVD          ;
        CLRA
        CLRB
        STD     SNENVS          ;
SNGRL1  BSR     SNZNVA
        BCS     SNGRL2
        JSR     SNOUT
        LDX     #$00F0
        JSR     SNWAIT
        BRA     SNGRL1
;
SNGRL2  BSR     SETNVD          ;env. gen. setup
        FCB     $40             ;decay rate
;
SNGRL3  BSR     SNENVN          ;compression subroutine
        LDX     #$0060
        JSR     SNWAIT
        BRA     SNGRL3
;



; * * * * * * * * *
;
; Decay envelope generator.
; BLS after return tests if done
;
SNENV   PSHS    A               ;save sound sample
        LDD     SNENVS
        SUBD    SNENVD
SNENV1  PSHS    CC
        STD     SNENVS          ;new volume level
        LDB     1,S             ;restore sound sample
        MUL                     ;times volume level
        PULS    CC,B,PC         ;restore condition codes, etc. return
;
; * * * * * * * * *
;
; Attack Envelope Generator
; BCS after return tests if done
;
SNENVA  PSHS    A
        LDD     SNENVS
        ADDD    SNENVD
        BRA     SNENV1
;



;
;
;  SWITAB: Define SWI Offsets
;
;
FOO     SET     SWIBEG          ;offset initialization
SWITAB  EQU     *
;
;
;
;define offset table
;
;
        FCB     (SETFAX-FOO) AND $FF    ;set amount of fade based on RANGE
FOO     SET     SETFAX          ;
;
        FCB     (VCTLSX-FOO) AND $FF    ;vector list processor
FOO     SET     VCTLSX
;
        FCB     (TXTSTI-FOO) AND $FF    ;string output (string follows)
FOO     SET     TXTSTI
;
        FCB     (TXTSTR-FOO) AND $FF    ;string output
FOO     SET     TXTSTR
;
        FCB     (TXTCHR-FOO) AND $FF    ;character output
FOO     SET     TXTCHR
;
        FCB     (EXPANX-FOO) AND $FF    ;string decompression routine
FOO     SET     EXPANX
;
        FCB     (EXPA00-FOO) AND $FF    ;   secondary entry point
FOO     SET     EXPA00
;
        FCB     (RANDOX-FOO) AND $FF    ;random number generator
FOO     SET     RANDOX
;
        FCB     (ZFLIPX-FOO) AND $FF    ;current screen clear
FOO     SET     ZFLIPX
;
        FCB     (ZFLOPX-FOO) AND $FF    ;alternate screen clear
FOO     SET     ZFLOPX
;
        FCB     (CLRSTX-FOO) AND $FF    ;status line clear
FOO     SET     CLRSTX
;
        FCB     (CLRPRX-FOO) AND $FF    ;primary text area clear
FOO     SET     CLRPRX
;
        FCB     (HUPDAX-FOO) AND $FF    ;update the heartrate
FOO     SET     HUPDAX
;
        FCB     (STATUX-FOO) AND $FF    ;update the status line
FOO     SET     STATUX
;
        FCB     (PUPDAX-FOO) AND $FF    ;update the main screen



FOO     SET     PUPDAX
;
        FCB     (PROMPX-FOO) AND $FF    ;prompt the human for input
FOO     SET     PROMPX
;
        FCB     (WAITX-FOO) AND $FF     ;wait for a number of jiffies
FOO     SET     WAITX
;
        FCB     (ZEROX-FOO) AND $FF     ;clear RAM
FOO     SET     ZEROX
;
        FCB     (NEGRAX-FOO) AND $FF    ;set RAM to negative one
FOO     SET     NEGRAX
;
        FCB     (WIZIX-FOO) AND $FF     ;fade-in
FOO     SET     WIZIX
;
        FCB     (WIZIX0-FOO) AND $FF    ;   secondary entry point
FOO     SET     WIZIX0
;
        FCB     (WIZOX-FOO) AND $FF    ;fade-out
FOO     SET     WIZOX
;
        FCB     (PREPAX-FOO) AND $FF    ;"PREPARE!" msg on EXAMINE screen
FOO     SET     PREPAX
;
        FCB     (OBIRTX-FOO) AND $FF    ;object creation routine
FOO     SET     OBIRTX
;
        FCB     (OCBFIX-FOO) AND $FF    ;OCB filling routine
FOO     SET     OCBFIX
;
        FCB     (INIVUX-FOO) AND $FF    ;create initial view
FOO     SET     INIVUX
;
        FCB     (NEWLVX-FOO) AND $FF    ;create a new level
FOO     SET     NEWLVX
;
        FCB     (SOUNDI-FOO) AND $FF    ;   secondary entry point
FOO     SET     SOUNDI
;
        FCB     (SOUNDX-FOO) AND $FF    ;sound routines
FOO     SET     SOUNDX
;
;;;;;        END
