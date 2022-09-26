.superfx

entry:
    ; iwt r0,#1234
    ; iwt r1,#4567
    ; add r1
    ; nop

    ; ibt r1,#01
    ; from r1
    ; romb
    ; iwt r14,#0000
    ; to r2
    ; getb ; movb Rd,[romb:r14]    ;hi=zero-expanded ; need ROM access

    ibt r0,#00 ; 000_00001
    cmode

    ibt r0,#07
    color

    ibt r1,#80
    ibt r2,#40
    plot
    plot
    plot

    ibt r0,#08
    plot
    plot
    plot
    plot
    plot

    rpix

    stop
