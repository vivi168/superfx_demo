.superfx

; void draw_hline(int x1, int x2, int y);
; r0=color
; r1=x0
; r3=x2
; r2=y
GSU_draw_hline:
    color ; color in r0

    ; sub => Rd = Rs - Rn
    to r12
    from r3
    sub r1
    inc r12

    cache
    move r13,r15
    loop
    plot

    rpix

    stop
    nop

Draw_hline:
    .call PUSH r0
    .call PUSH r1

    iwt r0,#abcd
    iwt r1,#cdef

    .call PULL r1
    .call PULL r0

    .call RET


; void draw_line(int x0, int y0, int x1, int y1);
; r0=color
; r1=x0
; r3=x1
; r2=y0
; r4=y1
GSU_draw_line:
    .call PUSH r0 ; save color to spare a register

    ; if y0(r2) == y1(r4) -> draw_hline
    from r2
    cmp r4
    bne @continue_draw_line
    nop

    ; should branch to a function that returns
    iwt r15,#@GSU_draw_hline
    nop

continue_draw_line:
    ; steep = 0
    iwt r7,#0

    ; r5 = x0(r1) - x1(r3)
    move r5,r1
    with r5
    sub r3
    .call ABS r5

    ; r9 = y0(r2) - y1(r4)
    move r9,r2
    with r9
    sub r4
    .call ABS r9

    from r5
    cmp r9
    bge @continue_draw_line2 ; skip if r5(abs(x0 - x1)) > r9(abs(y0 - y1))
    nop

    ; if (abs(x0 - x1) < abs(y0 - y1))
    .call SWAP r1,r2 ; -> swap(x0, y0)
    .call SWAP r3,r4 ; -> swap(x1, y1)

    ; steep = 1
    iwt r7,#1

continue_draw_line2:

     ; if r1(x0) > r3(x1)
    from r1
    cmp r3
    beq @continue_draw_line3 ; skip if r1(x0) == r3(x1)
    nop
    blt @continue_draw_line3 ; skip if r1(x0) < r3(x1)
    nop

    .call SWAP r1,r3 ; -> swap(x0, x1)
    .call SWAP r2,r4 ; -> swap(y0, y1)

continue_draw_line3:

    ; dx = x1(r3) - x0(r1);
    move r9,r3
    with r9
    sub r1

    ; dy = y1(r4) - y0(r2);
    move r5,r4
    with r5
    sub r2
    ; derror = abs(dy) * 2;
    .call ABS r5
    with r5
    add r5

    ; error = 0;
    iwt r6,#0

    ; loop counter  r12 = (r3 - r1) + 1;
    move r12,r3
    with r12
    sub r1
    inc r12

    ; yincr = (y1 > y0 ? 1 : -1);
    from r4
    cmp r2
    blt @yincr_neg
    nop
    iwt r8,#1
    bra @yincr_pos
    nop
yincr_neg:
    iwt r8,#ffff ; -1
yincr_pos:

    iwt r0,#0

    from r7
    cmp r0
    beq @L8
    nop

    from r8
    cmp r0
    blt @L9
    nop

    .call SWAP r1, r2
    bra @L10
    nop

L9:
    move r1,r4
    move r2,r3
L10:

    .call PULL r0
    .call CALL @LOOP_1
    bra @L1
    nop
L8:
    .call PULL r0
    .call CALL @LOOP_2
L1:
    stop
    nop


LOOP_1:
    ; TODO
    color

    cache
    move r13,r15

    plot

    with r2
    add r8

    with r6
    add r5

    from r6
    cmp r9
    blt @decr1
    nop
    beq @decr1
    nop

    with r6
    sub r9
    with r6
    sub r9
    bra @continueloop1
    nop

decr1:
    dec r1

continueloop1:

    loop
    nop


    .call RET

LOOP_2:
    color

    cache
    move r13,r15

    plot

    with r6
    add r5

    from r6
    cmp r9
    blt @continueloop2
    nop
    beq @continueloop2
    nop

    with r2
    add r8

    with r6
    sub r9
    with r6
    sub r9

continueloop2:

    loop
    nop

    ; TODO
    .call RET
