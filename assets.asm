.org 818000
.base 8000

null_byte: .db 00

bg1_tiles:     .incbin assets/bg1.tiles
bg2_tiles:     .incbin assets/bg2.tiles

bg1_pal:       .incbin assets/bg1.pal
bg2_pal:       .incbin assets/bg2.pal
bg2_map:       .incbin assets/bg2.map

.org 828000
.base 10000

gsu_prg: .incbin superfx/gsu.bin
