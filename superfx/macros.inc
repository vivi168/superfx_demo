.macro SWAP reg1, reg2
    with %reg1
    xor %reg2

    with %reg2
    xor %reg1

    with %reg1
    xor %reg2
.endm

.macro ABS reg1
    with %reg1
    not
    inc %reg1
    bpl @positive_%MACRO_ID
    nop
    dec %reg1
    with %reg1
    not
positive_%MACRO_ID:
.endm

.macro PUSH reg
    from %reg
    stw (r10)
    dec r10
    dec r10
.endm

.macro PULL reg
    inc r10
    inc r10
    to %reg
    ldw (r10)
.endm

.macro CALL func
    link #4
    iwt r15,#%func
    nop
.endm

.macro RET
    jmp r11
    nop
.endm

