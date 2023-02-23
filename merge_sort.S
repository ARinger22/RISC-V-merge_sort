addi x3, x0, 10 # size of the Array
lui x9, 0x10000 #seed value to generate the random value 
lui x13, 0x10001 #address of the unsorted arrray or real array
lui x14, 0x10002 # address of the sorted arrray
lui x15, 0x10002 # store address of the sorted array to take the 
                # sorted array again on the first index  

lui x17 0x10004 #address of the first temporari array used in the merge function
lui  x19 0x10004 #store address of first temporary array 
                 #to take the temporary array again on first addres after every execution of the 
                 #merge function

lui x18 0x10005 #address of the second temporari array used in the merge function 
lui x20 0x10005 # store address of the second temporari array
                # to take the temporari array again on the first
                #index after every execution of the merge function.

addi x11, x0, 0 #intially counter for the random function

bge x11 x3 end3 #if size is 0 or array is empty then program end

main:
	jal x1, random #callin random function
    sw x4, 0(x13) #store random value in the unsorted or real array
    sw x4, 0(x14) #store random value in the sorted array intially 
                #it is same as unsorted before MergeSort

    addi x14, x14, 4 #increse the index of the arrays 
    addi x13, x13, 4

    addi x11, x11, 1#incresing value of the counter
    blt x11, x3, main #checking the condition till we have taken random values equal to size of not
    bge x11 x3 main2 # here we have taken random value equal to size so no need to take more go in main2 funciton
    
random:     #random functioi
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
    add x4, x0 ,x5 #final random value
    ret #return to caller
    
merge_sort:
    sub a6 x12 x11 # m = r-l
    srli a6 a6 1   # m = m/2
    add a6 a6 x11 #m = l+ m = l+ (r-l)/2

    addi sp sp -16 #stack pointer to store the value during recursion
    sw ra 0(sp) #store previous address from where merge_sort is called
    sw x11 4(sp) #store l
    sw x12 8(sp) #store r
    sw a6 12(sp) #store mid
    
    bge x11, x12 end # if l < r then end

    # now to calling the merge_sort again give the argument l and r = m
    # using this sorting first half of the array 
    lw x11 4(sp) # l = l
    lw x12 12(sp) # r = mid
    jal ra merge_sort #recursive call

    #passing arguments l = m+1 ans r = ra
    #sorting the second half of the array
    lw x11 12(sp) #l = mid
    addi x11 x11 1 # l = mid +1
    lw x12 8(sp) # r= r
    jal ra merge_sort #recursive call

    #now for merge pass arguments l, m , r
    lw x11 4(sp) #l 
    lw a6 12(sp) # m 
    lw x12 8(sp) # r
    jal ra merge #call merge

end:
    lw	ra, 0(sp) #load the previous array to reach the previous function from where it is called
    addi sp, sp, 16 # stack closed
	jalr x0, ra, 0 # return

merge:
    addi sp sp -4 #stack pointer to store the address 
    sw ra 0(sp)
    addi x5, x0, 0 #int i, j, k for merge
    addi x6, x0, 0
    addi x7, x0, 0
    
    blt x12 x11 return # return if r < l return
    add x26 x0 a6 #
    sub x27 x12 x26 # n2 = r-m
    sub x26 x26 x11
    addi x26 x26 1 # n1 = m-l+1
    
    bge x5 x26 loop5 # i >= n1
    # else 
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
        bge x6 x27 loop3  # j >= n2
        # else
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
        add x5 x0 x0 # i =0
        add x6 x0 x0 # j =0
        add x7 x0 x11 #k = l
        add x17 x0 x19 #addressing to first index of temporary arrays
        add x18 x0 x20

    loop4: # while loop when i < n1 and j < n2
        bge x5 x26 loop7 # i i >= n1
        bge x6 x27 loop7 # if j >= n2
    loop6:
        lw x28 0(x17)
        lw x29 0(x18)
        bge x29 x28 swap1 #checking small value for swapping the value in the sorted array
        blt x29 x28 swap2
    swap1:
        slli x30 x7 2
        add x14 x15 x30 #address at which we are swapping the array values
        sw x28 0(x14) #swaping the values in the sorted array
        add x14 x0 x15 #sorted array again on the first step after swap opration 
        addi x17 x17 4 #incresing the address of the temporary array 
        addi x7 x7 1 # k++
        addi x5 x5 1 # i++
        blt x5 x26 loop4
        bge x5 x26 loop7
    swap2:
        slli x30 x7 2
        add x14 x15 x30
        sw x29 0(x14)
        add x14 x0 x15
        addi x18 x18 4 #increasing address of the second temporary array 
        addi x6 x6 1 #j++
        addi x7 x7 1 #k++
        blt x6 x27 loop4
        
    loop7:
        add x30 x0 x0
        add x28 x0 x0 
        add x29 x0 x0

    #now we need to store the remaining elements
    #of the temporary array which are remained

        bge x5 x26 loop10 #if i >= n1
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
        
    loop10: bge x6 x27 loop11 #if j >= n2
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
    # addrsing of the all array on its first address

    add x14, x0, x15 
    add x17 x0 x19
    add x18 x0 x20
    lw ra 0(sp)
    addi sp sp 4
    ret 

main2:
    add x14 x0 x15	#taking sorted array to its first index

    addi x5, x0, 0 #int i , j, k counter for merge function temporary registers
    addi x6, x0, 0
    addi x7, x0, 0

    addi x12, x3, -1 # r-1
    addi x11, x0, 0 #l
    addi a6 x0 0 # mid or m
    jal ra merge_sort # call merge sort
end3: