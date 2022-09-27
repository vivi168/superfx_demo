.org 700000

issou: .rb 1

.org 702000

screen_base: .rb 1

.org 7e0000

joy1_raw:                 .rb 2
joy1_press:               .rb 2
joy1_held:                .rb 2

frame_counter:            .rb 1
vblank_disable:           .rb 1

horizontal_offset:        .rb 2

next_rand:                .rb 2

.org 7e0108

nmi_dummy_jump:           .rb 4
irq_dummy_jump:           .rb 4

.org 7e2000

bg_buffers:
bg1_buffer:               .rb 800
oam_buffer:               .rb 200
oam_buffer_hi:            .rb 20

.org 7f0000

FastNmi: .rb {FastNmi_ROM_end-FastNmi_ROM}
FastNmi_end:
FastIRQ: .rb {FastIRQ_ROM_end-FastIRQ_ROM}
FastIRQ_end:
InitGSU: .rb {InitGSU_ROM_end-InitGSU_ROM}
InitGSU_end:
CallGSUFunction: .rb {CallGSUFunction_ROM_end-CallGSUFunction_ROM}
CallGSUFunction_end:
