addi x3, x0, 10
lui x9, 0x10000 
lui x13, 0x10001 
lui x14, 0x10002 
lui x15, 0x10002
lui x17 0x10004
lui x18 0x10005
lui  x19 0x10004
lui x20 0x10005
addi x11, x0, 0

bge x11 x3 end3
main:
	jal x1, random
    sw x4, 0(x13)
    sw x4, 0(x14)
    addi x14, x14, 4
    addi x13, x13, 4
    addi x11, x11, 1
    blt x11, x3, main
    bge x11 x3 loop
    
random:
	ADD x5, x0, x9
    slli x5, x5, 21
    xor x5, x5, x9
    add x7 , x0, x5
    addi x6, x0, 35
    srl x5, x5, x6
    xor x5, x5, x7
    add x7, x0, x5
    slli x5, x5, 4
    xor x5, x5, x7
    add x9, x0, x5
    add x4, x0 ,x5
    ret 
    
merge_sort:
    sub a6 x12 x11
    srli a6 a6 1
    add a6 a6 x11
    addi sp sp -16
    sw ra 0(sp)
    sw x11 4(sp)
    sw x12 8(sp)
    sw a6 12(sp)
    
    bge x11, x12 end
    lw x11 4(sp)
    lw x12 12(sp)
    jal ra merge_sort
    lw x11 12(sp) 
    lw x12 8(sp)
    addi x11 x11 1
    jal ra merge_sort
    lw x11 4(sp)
    lw a6 12(sp)
    lw x12 8(sp)
    jal ra merge

end:
    lw	ra, 0(sp)
    addi sp, sp, 16 
	jalr x0, ra, 0

merge:
#     lw x26 12(sp)
    addi sp sp -4
    sw ra 0(sp)
    addi x5, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0
    
    blt x12 x11 return
    add x26 x0 a6
    sub x27 x12 x26
    sub x26 x26 x11
    addi x26 x26 1
    
    bge x5 x26 loop5
    loop1:
        add x28 x11 x5
        slli x28 x28 2
        add x14 x14 x28
        lw x28 0(x14)
        sw x28 0(x17)  
        add x14 x0 x15
        addi x17 x17 4
        addi x5 x5 1
        blt x5 x26 loop1
        
    loop5: 
        bge x6 x27 loop3
    loop2:
        addi x29 a6 1
        add x29 x29 x6
        slli x29 x29 2
        add x14 x14 x29
        lw x29 0(x14)
        sw x29 0(x18)
        add x14 x0 x15
        addi x18 x18 4
        addi x6 x6 1
        blt x6 x27 loop2
        
    loop3:
        add x28 x0 x0
        add x29 x0 x0
        add x30 x0 x0
        add x5 x0 x0
        add x6 x0 x0
        add x7 x0 x11
        add x17 x0 x19
        add x18 x0 x20
    loop4:
        bge x5 x26 loop7
        bge x6 x27 loop7
    loop6:
        lw x28 0(x17)
        lw x29 0(x18)
        bge x29 x28 swap1
        blt x29 x28 swap2
    swap1:
        slli x30 x7 2
        add x14 x15 x30
        sw x28 0(x14)
        add x14 x0 x15
        addi x17 x17 4
        addi x7 x7 1
        addi x5 x5 1
        blt x5 x26 loop4
        bge x5 x26 loop7
    swap2:
        slli x30 x7 2
        add x14 x15 x30
        sw x29 0(x14)
        add x14 x0 x15
        addi x18 x18 4
        addi x6 x6 1
        addi x7 x7 1
        blt x6 x27 loop4
        
    loop7:
        add x30 x0 x0
        add x28 x0 x0 
        add x29 x0 x0
        
        bge x5 x26 loop10
    loop8:
        lw x28 0(x17)
        slli x30 x7 2
        add x14 x15 x30
        sw x28 0(x14)
        add x14 x0 x15
        addi x17 x17 4
        addi x5 x5 1
        addi x7 x7 1
        blt x5 x26 loop8
        
    loop10: bge x6 x27 loop11
    loop9:
        lw x29 0(x18)
        slli x30 x7 2
        add x14 x15 x30
        sw x29 0(x14)
        add x14 x0 x15
        addi x18 x18 4
        addi x7 x7 1
        addi x6 x6 1
        blt x6 x27 loop9
    loop11:
        
return:
#     add x26 x0 x0
#     add x27 x0 x0
    add x14, x0, x15
    add x17 x0 x19
    add x18 x0 x20
    lw ra 0(sp)
    addi sp sp 4
    ret

loop:
    add x14 x0 x15	
    addi x5, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0
    addi x12, x3, -1
    addi x11, x0, 0
    addi a6 x0 0
    jal ra merge_sort
end3: