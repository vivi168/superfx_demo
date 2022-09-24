;**************************************
; SUPER FX DEMO
;**************************************
.65816

.include define.inc
.include registers.inc
.include macros.inc
.include var.asm
.include assets.asm

.org 808000
.base 0000

.include vectors.asm
.include clear.asm
.include dma.asm
.include joypad.asm
.include level.asm
.include object.asm

InitGSU:
    jsr @CopyGSUProg

    lda #70 ; set pbr to bank 70 (GSU RAM)
    sta PBR ; Program bank register

    lda #08 ; screen base register = 70:0000 + N * 0x400
    sta SCBR    ; = 70:2000

    ; nil nil HT1 RON RAN HT0 MD1 MD0
    ; 0   0   1   1   1   0   0   1  ; (0b01) => 16 colors, (0b10) => y=192
    ; lda #39 ; w/ RON
    lda #29 ; w/o RON
    sta SCMR

    stz CFGR ; config, enable IRQ on STOP
    lda #01
    sta CLSR ; clock select register

    ldx #1000
    stx R15L

    rts

CopyGSUProg:
    .call M16

    ldx #0000

copy_gsu_prog_loop:
    lda !gsu_prg,x
    sta !gsu_base_prg,x
    inx
    inx
    cpx #GSU_ROM_SIZE
    bne @copy_gsu_prog_loop

    .call M8
    rts

MainLoop:
    jsr @WaitNextVBlank

    jsr @HandleInput

    jmp @MainLoop


.include info.asm
