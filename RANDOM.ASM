;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  R A N D O M   N U M B E R   G E N E R A T O R
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
; General Purpose Random Number Generator
; by the Polynomial Method.
;
;      Returns an 8-bit random number in ACCA.
;
RANDOX  LDX     #$0008          ;initialize shift counter
RND1    CLRB                    ;clear feedback byte
        LDY     #$0008
        LDA     SEED+2          ;load byte containing feedback bits
        ANDA    #$E1            ;mask all except feedback bits
RND2    LSLA                    ;shift feedback bits into carry
        BCC     RND3
        INCB                    ;count numnber of ones
RND3    LEAY    -1,Y            ;loop eight times
        BNE     RND2
        LSRB                    ;shift LSB of feedback into carry
        ROL     SEED            ;24-bit shift
        ROL     SEED+1
        ROL     SEED+2
        LEAX    -1,X            ;shift eight times
        BNE     RND1
        LDA     SEED            ;grab output value
        STA     3,S             ;modify A on the way out...
        RTS                     ;exit
;;;;;        END
