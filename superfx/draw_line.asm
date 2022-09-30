.superfx

; void draw_hline(int x1, int x2, int y);
; r1=x0 r3=x2 r2=y
GSU_draw_hline:
    ; TODO standalone function to set Color
    ; iwt r0,#01 ; 000_00001
    ; cmode

    ; TODO standalone function to set Color
    ibt r0,#0b
    color

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

; void draw_line(int x0, int y0, int x1, int y1);
; x0=r1, x2=r3, y=r2
GSU_draw_line:
    stop
    nop
