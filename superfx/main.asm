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
    iwt r1,#@screen_base  ; scbr
    iwt r12,#BG1_SCBR_SIZE_HALF ; 192 * 256 // 4 ; loop counter
    cache
    move r13,r15 ; loop to here (r13 = loop to, r15 = PC)
    stw (r1)
    inc r1
    loop
    inc r1
    stop
    nop



GSU_Plot_line:
    ;; test plotting

    ; first set CMODE
    iwt r0,#01 ; 000_00001
    cmode

    ; then set COLOR (color, getc)
    ibt r0,#07
    color

    ; then set x, y (r1, r2)
    ; then plot

    iwt r1,#0
    iwt r2,#4

    iwt r12,#e0

    cache
    move r13,r15
    loop
    plot

    rpix

    stop
    nop
