;#resource "jmp-glitch.cfg"
;#define CFGFILE jmp-glitch.cfg

.macpack apple2

.macro PrintStr_ str
.scope
        lda #<@String
        sta $6
        lda #>@String
        sta $7
        ldy #0
@Loop:	lda ($6),y
	beq @Skip
        jsr $FDED
        iny
        jmp @Loop
@String:
	scrcode str
        .byte $8D
        .byte $00
@Skip:
.endscope
.endmacro

.org $803
Start:
	; We store this byte at $800, because
        ; the glitch is that jmp ($8FF) will
        ; read the final destination, not from
        ; $8FF and $900, but from $8FF and $800!
	lda #>Glitched
        sta $800
	PrintStr_ ""
        PrintStr_ ""
	PrintStr_ "HELLO, WORLD"
        ; Our build environment (8bitworkshop) barfs at
        ; jmp ($8FF), because it knows that's broken;
        ; so instead we write the instruction as
        ; jmp ($8F0), and then overwrite the relevant
        ; byte so it becomes jmp ($8FF).
	lda #$FF
        sta JmpInstr+1
JmpInstr:
        jmp ($8F0)	; really ($8FF)!
        jmp InfLoop
InfLoop:
	jmp InfLoop
Boring:
	PrintStr_ "THIS IS WHERE A DEV WOULD EXPECT TO BE."
        jmp InfLoop
        
; ".org $8FF"
.res $8FF - *
	.word Boring

; ".org $A00"
.res $A00 - * + <Boring
Glitched:
	PrintStr_ "HAHA! WE -GLITCHED- HERE!"
        jmp InfLoop
