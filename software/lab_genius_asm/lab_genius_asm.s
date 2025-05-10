.section .text

.global sum

sum:
    lw t1, 0(a0)  
    lw t2, 0(a1)

    add t0, t1, t2

    sw t0, 0(a2)

    ret    
    