;**************************************
; ROM registration data
;**************************************
.org ffb0
.base 7fb0

; zero bytes
    .db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
; chipset subtype
    .db 00
; game title "SUPER FX DEMO        "
    .db 53,55,50,45,52,20,46,58,20,44,45,4d,4f,20,20,20,20,20,20,20,20
; 0xffd5: map mode
    .db 20
; 0xffd6: cartridge type
    .db 14 ; starfox is 13 ?
; 0xffd7: ROM size
    .db 0a
; 0xffd8: RAM size
    .db 05
; 0xffd9: destination code
    .db 00
; 0xffda: fixed value
    .db 33
; 0xffdb: mask ROM version
    .db 00
; 0xffdc: checksum complement
    .db 00,00
; 0xffde: checksum
    .db 00,00

;**************************************
; Vectors
;**************************************
.org ffe0
.base 7fe0

; zero bytes
    .db 00,00,00,00
; 65816 mode
    .db 00,00           ; COP ffe4
    .db @BreakVector    ; BRK ffe6
    .db 00,00
    ; .db @NmiVector      ; NMI ffea -> 0108
    .db @nmi_dummy_jump      ; NMI ffea -> 0108
    .db 00,00
    ; .db @IRQVector      ; IRQ ffee -> 010c
    .db @irq_dummy_jump      ; NMI ffea -> 0108

; zero bytes
    .db 00,00,00,00
; 6502 mode
    .db 00,00           ; COP
    .db 00,00
    .db 00,00
    .db 00,00           ; NMI
    .db @ResetVector    ; RESET
    .db 00,00           ; IRQ/BRK
