ResetVector:
    sei                 ; disable interrupts
    clc
    xce
    cld
    jmp !FastReset
FastReset:
    .call M8
    .call X16

    ldx #STACK_TOP
    txs                 ; set stack pointer to 1fff

    lda #01
    sta MEMSEL

; ---- Forced Blank
    lda #80
    sta INIDISP
    jsr @ClearRegisters

; ---- BG settings
    lda #09             ; bg 3 high prio, mode 1
    sta BGMODE

    .call RESET_OFFSET BG1HOFS, BG1VOFS
    .call RESET_OFFSET BG2HOFS, BG2VOFS
    .call RESET_OFFSET BG3HOFS, BG3VOFS

    lda #10
    sta BG12NBA         ; BG1 tiles @ VRAM[0000], BG2 tiles @ VRAM[2000]

    lda #02
    sta BG34NBA         ; BG3 tiles @ VRAM[4000]

    lda #28
    sta BG1SC           ; BG1 MAP @ VRAM[5000]

    lda #30
    sta BG2SC           ; BG2 MAP @ VRAM[6000]

    lda #34
    sta BG3SC           ; BG3 MAP @ VRAM[6800]

    lda #13             ; enable BG12 + sprites (0b10011)
    sta TM

;  ---- OBJ settings
    lda #62             ; sprite 16x16 small, 32x32 big
    sta OBJSEL          ; oam start @VRAM[8000]

;  ---- Some initialization
    .call WRAM_DMA_TRANSFER 01, @FastNmi, FastNmi_ROM, {FastIRQ_end-FastNmi}w
    jsr @ClearBG1Buffer
    jsr @InitOamBuffer

;  ---- DMA Transfers

    .call VRAM_DMA_TRANSFER 0000, bg1_tiles, BG1_TILES_SIZE
    .call VRAM_DMA_TRANSFER 1000, bg2_tiles, BG2_TILES_SIZE           ; VRAM[0x2000] (word step)

    .call VRAM_DMA_TRANSFER 2800, bg1_buffer, BG1_BUFFER_SIZE         ; VRAM[0x5000] (word step)
    .call VRAM_DMA_TRANSFER 3000, bg2_map, BG2_MAP_SIZE               ; VRAM[0x6000] (word step)

    .call CGRAM_DMA_TRANSFER 00, bg1_pal, 80

    jsr @TransferOamBuffer

; ---- Release Forced Blank
    lda #0f             ; release forced blanking, set screen to full brightness
    sta INIDISP

    lda #81             ; enable NMI, turn on automatic joypad polling
    sta NMITIMEN
    cli

    jmp @MainEntry

BreakVector:
    rti

WaitNextVBlank:
    stz @vblank_disable
wait_next_vblank:
    lda @vblank_disable
    beq @wait_next_vblank
    stz @vblank_disable
    rts

NmiVector:
    jmp !FastNmi
FastNmi_ROM:
    php
    .call MX16
    pha
    phx
    phy

    .call M8
    .call X16

    lda RDNMI

    inc @frame_counter

    lda @horizontal_offset
    sta BG1HOFS
    lda @horizontal_offset+1
    sta BG1HOFS

    .call VRAM_DMA_TRANSFER 2800, bg1_buffer, BG1_BUFFER_SIZE
    ; jsr @TransferOamBuffer ; should relocate this to RAM as well

    ; jsr @ReadJoyPad1 ; should relocate this to RAM as well

    inc @vblank_disable

    .call MX16
    ply
    plx
    pla
    plp
    rti
FastNmi_ROM_end:

IRQVector:
    jmp !FastIRQ
FastIRQ_ROM:
    ; read GSU status register bit 15
    ; if 1 -> irq was from GSU

    lda SFRH
    bit #80
    bne @return_from_gsu

    bra @exit_irq

return_from_gsu:
    ; specific code here

exit_irq:
    rti
FastIRQ_ROM_end:
