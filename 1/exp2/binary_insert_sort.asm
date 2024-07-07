.data   
buffer:         .space  4004
compare_count:  .word   0
infile:         .asciiz "a.in"
outfile:        .asciiz "a.out"
.text   
main:           
    la      $a0,                    infile                  # load address of infile into $a0
    li      $a1,                    0                       # read mode
    li      $a2,                    0                       # no additional flags
    li      $v0,                    13                      # syscall 13 (open file)
    syscall                                                 # open file
    move    $a0,                    $v0                     # load file descriptor into $a0
    la      $a1,                    buffer                  # load address of buffer into $a1
    li      $a2,                    4004                    # read 1001 integers
    li      $v0,                    14                      # syscall 14 (read file)
    syscall                                                 # read file
    li      $v0,                    16                      # syscall 16 (close file)
    syscall                                                 # close infile
    lw      $s0,                    buffer                  # load N into $s0
    addi    $a0,                    $a1,            4       # move buffer to the next integer
    move    $a1,                    $s0                     # move N to $a1
    jal     binary_insertion_sort                           # call binary_insertion_sort
    lw      $t0,                    compare_count           # load compare_count into $t0
    sw      $t0,                    buffer                  # store compare_count into buffer[0]
    la      $a0,                    outfile                 # load address of outfile into $a0
    li      $a1,                    1                       # write mode
    li      $a2,                    0                       # no additional flags
    li      $v0,                    13                      # syscall 13 (open file)
    syscall                                                 # open file
    move    $a0,                    $v0                     # load file descriptor into $a0
    la      $a1,                    buffer                  # load address of buffer into $a1
    addi    $a2,                    $s0,            1       # write N + 1 integers
    sll     $a2,                    $a2,            2       # multiply by 4
    li      $v0,                    15                      # syscall 15 (write file)
    syscall                                                 # write file
    li      $v0,                    16                      # syscall 16 (close file)
    syscall                                                 # close outfile
    li      $v0,                    10                      # syscall 10 (exit)
    syscall                                                 # exit

binary_insertion_sort:
    addi    $sp,                    $sp,            -12     # allocate space for 3 integers
    sw      $ra,                    8($sp)                  # save return address
    sw      $s0,                    4($sp)                  # save i
    sw      $s1,                    0($sp)                  # save v[]
    move    $s1,                    $a0                     # move v[] to $s1
    move    $s2,                    $a1                     # move N to $s2
    li      $s0,                    1                       # i = 1
loop_bis:       
    bge     $s0,                    $s2,            end_bis # if i >= N, goto end_bis
    move    $a0,                    $s1                     # move v[] to $a0
    li      $a1,                    0                       # left = 0
    add     $a2,                    $s0,            -1      # right = i - 1
    move    $a3,                    $s0                     # n = i
    jal     binary_search                                   # call binary_search
    move    $a0,                    $s1                     # move v[] to $a0
    move    $a1,                    $v0                     # move place to $a1
    move    $a2,                    $s0                     # move i to $a2
    jal     insert                                          # call insert
    addi    $s0,                    $s0,            1       # i++
    j       loop_bis                                        # goto loop_bis
end_bis:        
    lw      $ra,                    8($sp)                  # restore return address
    lw      $s0,                    4($sp)                  # restore i
    lw      $s1,                    0($sp)                  # restore v[]
    addi    $sp,                    $sp,            12      # deallocate space for 3 integers
    jr      $ra                                             # return

binary_search:  
    ble     $a1,                    $a2,            end_bs0 # if left > right, goto end_bs0
    move    $v0,                    $a1                     # return left
    jr      $ra                                             # return
end_bs0:        
    addi    $sp,                    $sp,            -12     # allocate space for 5 integers
    sw      $ra,                    8($sp)                  # save return address
    sw      $s0,                    4($sp)                  # save mid
    sw      $s1,                    0($sp)                  # save v[]
    add     $s0,                    $a1,            $a2     # left + right
    srl     $s0,                    $s0,            1       # (left + right) / 2
    lw      $t0,                    compare_count           # load compare_count into $t0
    addi    $t0,                    $t0,            1       # compare_count++
    sw      $t0,                    compare_count           # store compare_count into compare_count
    sll     $t0,                    $s0,            2       # mid * 4
    add     $t0,                    $a0,            $t0     # &v[mid]
    lw      $t0,                    0($t0)                  # v[mid]
    sll     $t1,                    $a3,            2       # n * 4
    add     $t1,                    $a0,            $t1     # &v[n]
    lw      $t1,                    0($t1)                  # v[n]
    bgt     $t0,                    $t1,            end_bs1 # if v[mid] > v[n], goto end_bs1
    addi    $a1,                    $s0,            1       # left = mid + 1
    jal     binary_search
    j       end_bs2
end_bs1:        
    addi    $a2,                    $s0,            -1      # right = mid - 1
    jal     binary_search
end_bs2:        
    lw      $ra,                    8($sp)                  # restore return address
    lw      $s0,                    4($sp)                  # restore mid
    lw      $s1,                    0($sp)                  # restore v[]
    addi    $sp,                    $sp,            12      # deallocate space for 5 integers
    jr      $ra                                             # return

insert:         
    sll     $t0,                    $a2,            2       # multiply n by 4
    add     $t0,                    $a0,            $t0     # v[n]
    lw      $t0,                    0($t0)                  # load v[n] into $t0
    addi    $t1,                    $a2,            -1      # n - 1
loop_i:         
    blt     $t1,                    $a1,            end_i   # if i < place, goto end_i
    sll     $t2,                    $t1,            2       # multiply i by 4
    add     $t2,                    $a0,            $t2     # v[i]
    lw      $t3,                    0($t2)                  # load v[i] into $t2
    sw      $t3,                    4($t2)                  # v[i + 1] = v[i]
    addi    $t1,                    $t1,            -1      # i--
    j       loop_i                                          # goto loop_i
end_i:          
    sll     $t2,                    $a1,            2       # multiply place by 4
    add     $t2,                    $a0,            $t2     # v[place]
    sw      $t0,                    0($t2)                  # v[place] = v[n]
    addi    $v0,                    $t1,            1       # return
    jr      $ra                                             # return
