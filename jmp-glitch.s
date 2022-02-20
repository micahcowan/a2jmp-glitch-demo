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
	lda #$0A
        sta $08
	PrintStr_ ""
        PrintStr_ ""
	PrintStr_ "HELLO, WORLD"
        jmp TestJmp
InfLoop:
	jmp InfLoop
Glitched:
	PrintStr_ "HAHA! WE -GLITCHED- HERE!"
        jmp InfLoop
Boring:
	PrintStr_ "THIS IS WHERE A DEV WOULD EXPECT TO BE."
        PrintStr_ "BUT MAYBE TRY A GLITCH"
        PrintStr_ " IN THE TARGET WORD..."
	lda #$FF
        sta JmpInstr+1
JmpInstr:
        jmp ($CF0)
        jmp InfLoop
Boring2:
	PrintStr_ "NOPE, THAT WAS BORING TOO."
        jmp InfLoop
	

.res $9FE - *
TestJmp:
	jmp ($0B40)

.res $A40 - *
	.word Glitched

.res $B40 - *
	.word Boring

.res $C00 - *
	.byte >Glitched2
        
.res $CFF - *
	.word Boring2

.res $E00 - * + <Boring2
Glitched2:
	PrintStr_ "HAHA! WE GLITCHED SECOND ONE!"
        jmp InfLoop