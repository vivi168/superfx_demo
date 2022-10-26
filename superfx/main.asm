.org 020000
.base 10000

.superfx

.macro SWAP reg1, reg2
    with %reg1
    xor %reg2

    with %reg2
    xor %reg1

    with %reg1
    xor %reg2
.endm

.macro ABS reg1
    from %reg1
    not
    bge @positive_%MACRO_ID
    move %reg1,r0
positive_%MACRO_ID:
.endm

GSU_entry:
    ;; test MACROS
    iwt r1,#1234
    iwt r2,#4567
    .call SWAP r1, r2

    iwt r1,#0123
    .call ABS r1
    iwt r1,#f123
    .call ABS r1

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


.include draw_line.asm
; .include draw_triangle.asm
