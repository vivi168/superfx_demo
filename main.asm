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

    lda #04 ; gsu/2
    sta VCR

    stz RAMBR
    stz ROMBR

    lda #08 ; screen base register = 70:0000 + N * 0x400
    ; can use double buffering by switching scbr on two successive frame ?
    ; double buffering in VRAM seems to be the norm when looking at starfox
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

    ldx #@GSU_Plot_line
    jsl !CallGSUFunction

    ; ---- Release Forced Blank
    .call VRAM_DMA_TRANSFER 0000, screen_base, BG1_SCBR_SIZE
    lda #0f             ; release forced blanking, set screen to full brightness
    sta INIDISP

    lda #81             ; enable NMI, turn on automatic joypad polling
    sta NMITIMEN
    cli
MainLoop:
    jsr @WaitNextVBlank

    jsr @HandleInput

    jmp @MainLoop

.include info.asm
