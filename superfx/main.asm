.superfx

entry:
    iwt r0,#1234
    iwt r1,#4567
    add r1
    nop

    ibt r1,#01
    from r1
    romb
    iwt r14,#0000
    to r2
    ; getb ; movb Rd,[romb:r14]    ;hi=zero-expanded ; need ROM access


    stop
