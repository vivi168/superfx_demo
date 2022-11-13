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
    nop
    nop
    nop

    .call CALL @Draw_hline


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
    iwt r5,#0
    sm (@steep),r5

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
    iwt r5,#1
    sm (@steep),r5

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
    move r5,r3
    with r5
    sub r1
    .call PUSH r5 ; sp

    ; dy = y1(r4) - y0(r2);
    move r5,r4
    with r5
    sub r2

    ; derror = abs(dy) * 2;
    .call ABS r5
    with r5
    add r5
    .call PUSH r5 ; sp + 2

    ; error = 0;
    iwt r5,#0
    .call PUSH r5 ; sp + 4

    ; y = y0;
    .call PUSH r2 ; sp + 6

    ; yincr = (y1 > y0 ? 1 : -1);
    from r4
    cmp r2
    blt @yincr_neg
    iwt r5,#1
    bra @yincr_pos
yincr_neg:
    iwt r5,#ffff ; -1
yincr_pos:
    .call PUSH r5 ; sp + 8



    stop
    nop
