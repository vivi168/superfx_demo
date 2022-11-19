.org 818000
.base 8000

null_byte: .db 00

bg2_tiles:     .incbin assets/bg2.tiles

bg1_pal:       .incbin assets/bg1.pal
bg2_pal:       .incbin assets/bg2.pal
bg1_map:       .incbin assets/bg1.map
bg2_map:       .incbin assets/bg2.map

wh0_hdma:
.db 10
.db ff

.db 60
.db 10
.db 60
.db 10

.db 01
.db ff
.db 00

triangle:      .incbin assets/triangle.bin
