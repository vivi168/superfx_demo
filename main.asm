;**************************************
; SUPER FX DEMO
;**************************************
.65816

.include define.inc
.include registers.inc
.include macros.inc
.include var.asm
.include assets.asm
.include superfx/main.asm

.65816

.org 808000
.base 0000

.include vectors.asm
.include clear.asm
.include dma.asm
.include joypad.asm
.include level.asm
.include object.asm

InitGSU_ROM:
    ; phb needed ?
    lda #02 ; set pbr to bank 02 (GSU ROM)
    sta PBR ; Program bank register

    lda #04
    sta VCR

    stz RAMBR
    stz ROMBR

    lda #08 ; screen base register = 70:0000 + N * 0x400
    sta SCBR    ; = 70:2000

    ; nil nil HT1 RON RAN HT0 MD1 MD0
    ; 0   0   1   1   1   0   0   1  ; (MD 0b01) => 16 colors, (HT 0b10) => y=192
    lda #39 ; w/ RON
    ; lda #29 ; w/o RON
    sta SCMR

    stz CFGR ; config, enable IRQ on STOP
    lda #01
    sta CLSR ; clock select register

    rtl
InitGSU_ROM_end:

CallGSUFunction_ROM:
    stx R15L

wait_for_gsu:
    lda SFRL
    bit #20
    bne @wait_for_gsu

    rtl
CallGSUFunction_ROM_end:


MainEntry:
    jsl !InitGSU

    ldx #@GSU_entry
    jsl !CallGSUFunction

    ldx #@GSU_clear_buffer
    jsl !CallGSUFunction
MainLoop:
    jsr @WaitNextVBlank

    jsr @HandleInput

    jmp @MainLoop

.include info.asm
