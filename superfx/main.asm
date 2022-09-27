.org 020000
.base 10000


.superfx

GSU_entry:
    ; iwt r0,#1234
    ; iwt r1,#4567
    ; add r1
    ; nop

    ;; test ROM reading
    ibt r1,#00
    from r1
    romb
    iwt r14,#0000
    to r2
    getb ; movb Rd,[romb:r14]    ;hi=zero-expanded ; need ROM access
    ;;

    ;; test RAM writing
    iwt r1,#1234
    iwt r0,#0000
    from r1
    stw (r0)
    stop
    nop

GSU_clear_buffer:
    iwt r0,#0
    cmode
    iwt r1,#2000  ; scbr
    iwt r12,#1800 ; 192 * 256 // 8
    cache
    move r13,r15
    stw (r1)
    inc r1
    loop
    inc r1
    stop
    nop

    ;; test plotting
    ; first set CMODE
    ; then set COLOR (color, getc)
    ; then set x, y (r1, r2)
    ; then plot

            ;     iwt r0,#0001 ; 000_00001
            ;     cmode

            ;     ibt r0,#07
            ;     color


            ;     iwt r1,#0000
            ;     iwt r2,#0000
            ;     plot
            ;     plot
            ;     plot
            ;     plot

            ;     plot
            ;     plot
            ;     plot
            ;     plot

            ;     ibt r0,#02
            ;     color


            ;     iwt r12,#80
            ;     iwt r1,#0000
            ;     iwt r2,#0001

            ; issourire:
            ;     plot
            ;     plot
            ;     plot
            ;     plot

            ;     plot
            ;     plot
            ;     plot

            ;     plot
            ;     inc r2
            ;     iwt r1,#0000
            ;     iwt r13,#{issourire}
            ;     loop
            ;     nop
