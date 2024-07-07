.data   
buffer:         .space  4004
compare_count:  .word   0
infile:         .asciiz "a.in"
outfile:        .asciiz "a.out"
.text   
main:           
    la      $a0,            infile                  # load address of infile into $a0
    li      $a1,            0                       # read mode
    li      $a2,            0                       # no additional flags
    li      $v0,            13                      # syscall 13 (open file)
    syscall                                         # open file
    move    $a0,            $v0                     # load file descriptor into $a0
    la      $a1,            buffer                  # load address of buffer into $a1
    li      $a2,            4004                    # read 1001 integers
    li      $v0,            14                      # syscall 14 (read file)
    syscall                                         # read file
    li      $v0,            16                      # syscall 16 (close file)
    syscall                                         # close infile
    lw      $s0,            buffer                  # load N into $s0
    addi    $a0,            $a1,            4       # move buffer to the next integer
    move    $a1,            $s0                     # move N to $a1
    jal     insertion_sort                          # call insertion_sort
    lw      $t0,            compare_count           # load compare_count into $t0
    sw      $t0,            buffer                  # store compare_count into buffer[0]
    la      $a0,            outfile                 # load address of outfile into $a0
    li      $a1,            1                       # write mode
    li      $a2,            0                       # no additional flags
    li      $v0,            13                      # syscall 13 (open file)
    syscall                                         # open file
    move    $a0,            $v0                     # load file descriptor into $a0
    la      $a1,            buffer                  # load address of buffer into $a1
    addi    $a2,            $s0,            1       # write N + 1 integers
    sll     $a2,            $a2,            2       # multiply by 4
    li      $v0,            15                      # syscall 15 (write file)
    syscall                                         # write file
    li      $v0,            16                      # syscall 16 (close file)
    syscall                                         # close outfile
    li      $v0,            10                      # syscall 10 (exit)
    syscall                                         # exit

insertion_sort: 
    addi    $sp,            $sp,            -12     # allocate space for 3 integers
    sw      $ra,            8($sp)                  # save return address
    sw      $s0,            4($sp)                  # save $s0
    sw      $s1,            0($sp)                  # save $s1
    move    $s1,            $a0                     # move v[] to $s1
    move    $s2,            $a1                     # move N to $s2
    li      $s0,            1                       # i = 1
loop_is:        
    bge     $s0,            $s2,            end_is  # if i >= N, goto end_is
    move    $a0,            $s1                     # move v[] to $a0
    move    $a1,            $s0                     # move i to $a1
    jal     search                                  # call search
    move    $a0,            $s1                     # move v[] to $a0
    move    $a1,            $v0                     # move place to $a1
    move    $a2,            $s0                     # move i to $a2
    jal     insert                                  # call insert
    addi    $s0,            $s0,            1       # i++
    j       loop_is                                 # goto loop_is
end_is:         
    lw      $ra,            8($sp)                  # restore return address
    lw      $s0,            4($sp)                  # restore $s0
    lw      $s1,            0($sp)                  # restore $s1
    addi    $sp,            $sp,            12      # deallocate space for 3 integers
    jr      $ra                                     # return

search:         
    addi    $sp,            $sp,            -12     # allocate space for 3 integers
    sw      $ra,            8($sp)                  # save return address
    sw      $s0,            4($sp)                  # save $s0
    sw      $s1,            0($sp)                  # save $s1
    lw      $t0,            compare_count           # load compare_count into $t0
    sll     $t1,            $a1,            2       # multiply n by 4
    add     $t1,            $a0,            $t1     # v[n]
    lw      $t1,            0($t1)                  # load v[n] into $t1
    addi    $t2,            $a1,            -1      # n - 1
loop_s:         
    blt     $t2,            $zero,          end_s   # if i < 0, goto end_s
    sll     $t3,            $t2,            2       # multiply i by 4
    add     $t3,            $a0,            $t3     # v[i]
    lw      $t3,            0($t3)                  # load v[i] into $t3
    addi    $t0,            $t0,            1       # compare_count++
    ble     $t3,            $t1,            end_s   # if v[i] >= v[n], goto end_s
    addi    $t2,            $t2,            -1      # i--
    j       loop_s                                  # goto loop_s
end_s:          
    sw      $t0,            compare_count           # store compare_count into compare_count
    addi    $v0,            $t2,            1       # place = i + 1
    lw      $ra,            8($sp)                  # restore return address
    lw      $s0,            4($sp)                  # restore $s0
    lw      $s1,            0($sp)                  # restore $s1
    addi    $sp,            $sp,            12      # deallocate space for 3 integers
    jr      $ra                                     # return

insert:         
    sll     $t0,            $a2,            2       # multiply n by 4
    add     $t0,            $a0,            $t0     # v[n]
    lw      $t0,            0($t0)                  # load v[n] into $t0
    addi    $t1,            $a2,            -1      # n - 1
loop_i:         
    blt     $t1,            $a1,            end_i   # if i < place, goto end_i
    sll     $t2,            $t1,            2       # multiply i by 4
    add     $t2,            $a0,            $t2     # v[i]
    lw      $t3,            0($t2)                  # load v[i] into $t3
    sw      $t3,            4($t2)                  # v[i + 1] = v[i]
    addi    $t1,            $t1,            -1      # i--
    j       loop_i                                  # goto loop_i
end_i:          
    sll     $t2,            $a1,            2       # multiply place by 4
    add     $t2,            $a0,            $t2     # v[place]
    sw      $t0,            0($t2)                  # v[place] = v[n]
    addi    $v0,            $t1,            1       # return
    jr      $ra                                     # return
