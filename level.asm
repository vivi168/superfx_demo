ClearBG1Buffer:
    .call M16

    ldx #0000
    lda #0000
clear_buffer_loop:
    sta !bg1_buffer,x
    inx
    inx
    cpx #0800
    bne @clear_buffer_loop

    .call M8
    rts


; Xorshift algorithm
Random:
	lda @next_rand+1
	lsr
	lda @next_rand
	ror
	eor @next_rand+1
	sta @next_rand+1 ; high part of x ^= x << 7 done
	ror              ; A has now x >> 9 and high bit comes from low byte
	eor @next_rand   ; x ^= x >> 9 and the low part of x ^= x << 7 done
	sta @next_rand
	eor @next_rand+1
	sta @next_rand+1 ; x ^= x << 8 done
	rts
