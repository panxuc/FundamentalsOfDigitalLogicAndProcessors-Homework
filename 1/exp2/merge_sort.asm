.data   
compare_count:  .word   0
buffer:         .space  4004
head:           .space  8
infile:         .asciiz "a.in"
outfile:        .asciiz "a.out"
.text   
main:           
    la      $a0,            infile                      # load address of infile into $a0
    li      $a1,            0                           # read mode
    li      $a2,            0                           # no additional flags
    li      $v0,            13                          # syscall 13 (open file)
    syscall                                             # open file
    move    $a0,            $v0                         # load file descriptor into $a0
    la      $a1,            buffer                      # load address of buffer into $a1
    li      $a2,            4004                        # read 1001 integers
    li      $v0,            14                          # syscall 14 (read file)
    syscall                                             # read file
    li      $v0,            16                          # syscall 16 (close file)
    syscall                                             # close infile
    lw      $s0,            buffer                      # load N into $s0
    la      $t0,            head                        # load address of head into $t0
    sw      $zero,          4($t0)                      # head[1] = NULL
    move    $t1,            $t0                         # load address of head into $t1
    li      $t2,            1                           # idx = 1
    li      $a0,            8                           # size of int[2]
loop_main_1:    
    bgt     $t2,            $s0,            end_main_1  # if idx > N, goto end_main_1
    li      $v0,            9                           # syscall 9 (sbrk)
    li      $a0,            8                           # size of int[2]
    syscall                                             # allocate memory
    sw      $v0,            4($t1)                      # pointer[1] = new int[2]
    move    $t1,            $v0                         # pointer = new int[2]
    sll     $t3,            $t2,            2           # t3 = idx * 4
    la      $t4,            buffer                      # load address of buffer into $t4
    add     $t3,            $t3,            $t4         # t3 = buffer + idx * 4
    lw      $t3,            0($t3)                      # t3 = buffer[idx]
    sw      $t3,            0($t1)                      # pointer[0] = buffer[idx]
    sw      $zero,          4($t1)                      # pointer[1] = NULL
    addi    $t2,            $t2,            1           # idx++
    j       loop_main_1
end_main_1:     
    la      $a0,            head                        # load address of head into $a0
    lw      $a0,            4($a0)                      # load head[1] into $a0
    jal     msort                                       # call msort
    la      $t0,            head                        # load address of head into $t0
    sw      $v0,            4($t0)                      # head[1] = msort(head[1])
    move    $t1,            $t0                         # load address of head into $t1
    la      $a0,            outfile                     # load address of outfile into $a0
    li      $a1,            1                           # write mode
    li      $a2,            0                           # no additional flags
    li      $v0,            13                          # syscall 13 (open file)
    syscall                                             # open file
    move    $a0,            $v0                         # load file descriptor into $a0
    la      $a1,            compare_count               # load address of compare_count into $a1
    li      $a2,            4                           # write 4 bytes
    li      $v0,            15                          # syscall 15 (write file)
    syscall                                             # write file
loop_main_2:    
    lw      $t1,            4($t1)                      # pointer = pointer[1]
    beq     $t1,            $zero,          end_main_2  # if pointer == NULL, goto end_main_2
    la      $a1,            0($t1)                      # load address of pointer[0] into $a1
    li      $a2,            4                           # write 4 bytes
    li      $v0,            15                          # syscall 15 (write file)
    syscall                                             # write file
    j       loop_main_2
end_main_2:     
    li      $v0,            16                          # syscall 16 (close file)
    syscall                                             # close outfile
    li      $v0,            10                          # syscall 10 (exit)
    syscall                                             # exit

msort:          
    addi    $sp,            $sp,            -20         # allocate space
    sw      $ra,            16($sp)                     # save $ra
    sw      $s0,            12($sp)                     # save $s0
    sw      $s1,            8($sp)                      # save $s1
    sw      $s2,            4($sp)                      # save $s2
    sw      $s3,            0($sp)                      # save $s3
    move    $s0,            $a0                         # load head into $s0
    move    $v0,            $a0                         # load head into $v0
    lw      $t0,            4($s0)                      # load head[1] into $t0
    beq     $t0,            $zero,          end_msort   # if head[1] == NULL, goto end_msort
    move    $t1,            $s0                         # stride_1_pointer = head
    move    $t2,            $s0                         # stride_2_pointer = head
loop_msort_1:   
    lw      $t3,            4($t2)                      # load stride_2_pointer[1] into $t3
    beq     $t3,            $zero,          end_msort_1 # if stride_2_pointer[1] == NULL, goto end_msort_1
    lw      $t2,            4($t2)                      # stride_2_pointer = stride_2_pointer[1]
    lw      $t3,            4($t2)                      # load stride_2_pointer[1] into $t3
    beq     $t3,            $zero,          end_msort_1 # if stride_2_pointer[1] == NULL, goto end_msort_1
    lw      $t2,            4($t2)                      # stride_2_pointer = stride_2_pointer[1]
    lw      $t1,            4($t1)                      # stride_1_pointer = stride_1_pointer[1]
    j       loop_msort_1
end_msort_1:    
    lw      $t2,            4($t1)                      # stride_2_pointer = stride_1_pointer[1]
    sw      $zero,          4($t1)                      # stride_1_pointer[1] = NULL
    move    $s1,            $t2                         # load stride_2_pointer into $s1
    move    $a0,            $s0                         # load head into $a0
    jal     msort                                       # call msort
    move    $s2,            $v0                         # load return value into $s2
    move    $a0,            $s1                         # load stride_2_pointer into $a0
    jal     msort                                       # call msort
    move    $s3,            $v0                         # load return value into $s3
    move    $a0,            $s2                         # load l_head into $a0
    move    $a1,            $s3                         # load r_head into $a1
    jal     merge                                       # call merge
end_msort:      
    lw      $ra,            16($sp)                     # restore $ra
    lw      $s0,            12($sp)                     # restore $s0
    lw      $s1,            8($sp)                      # restore $s1
    lw      $s2,            4($sp)                      # restore $s2
    lw      $s3,            0($sp)                      # restore $s3
    addi    $sp,            $sp,            20          # deallocate space
    jr      $ra                                         # return

merge:          
    addi    $sp,            $sp,            -20         # allocate space
    sw      $ra,            16($sp)                     # save $ra
    sw      $s0,            12($sp)                     # save $s0
    sw      $s1,            8($sp)                      # save $s1
    sw      $s2,            4($sp)                      # save $s2
    sw      $s3,            0($sp)                      # save $s3
    move    $s0,            $a0                         # load l_head into $s1
    move    $s1,            $a1                         # load r_head into $s1
    li      $v0,            9                           # syscall 9 (sbrk)
    li      $a0,            8                           # size of int[2]
    syscall                                             # allocate memory
    move    $t0,            $v0                         # load head into $t0
    sw      $s0,            4($t0)                      # head[1] = l_head
    move    $t1,            $t0                         # load address of head into $t1
    move    $t2,            $s1                         # load r_head into $t2
loop_merge_1:   
    lw      $t3,            4($t1)                      # load p_left[1] into $t3
    beq     $t3,            $zero,          end_merge_1 # if p_left[1] == NULL, goto end_merge_1
    lw      $t4,            compare_count               # load compare_count into $t4
    addi    $t4,            $t4,            1           # compare_count++
    sw      $t4,            compare_count               # compare_count = compare_count
    lw      $t3,            0($t3)                      # load p_left[1][0] into $t3
    lw      $t4,            0($t2)                      # load p_right[0] into $t4
    bgt     $t3,            $t4,            end_merge_1 # if p_left[1][0] > p_right[0], goto end_merge_1
    lw      $t1,            4($t1)                      # p_left = p_left[1]
    j       loop_merge_1
end_merge_1:    
    lw      $t3,            4($t1)                      # load p_left[1] into $t3
    beq     $t3,            $zero,          end_merge_t # if p_left[1] == NULL, goto end_merge_t
    move    $t4,            $t2                         # load p_right into $t4
loop_merge_2:   
    lw      $t5,            4($t4)                      # load p_right_temp[1] into $t5
    beq     $t5,            $zero,          end_merge_2 # if p_right_temp[1] == NULL, goto end_merge_2
    lw      $t6,            compare_count               # load compare_count into $t6
    addi    $t6,            $t6,            1           # compare_count++
    sw      $t6,            compare_count               # compare_count = compare_count
    lw      $t5,            0($t5)                      # load p_right_temp[1][0] into $t5
    lw      $t6,            0($t3)                      # load p_left[1][0] into $t6
    bgt     $t5,            $t6,            end_merge_2 # if p_right_temp[1][0] > p_left[1][0], goto end_merge_2
    lw      $t4,            4($t4)                      # p_right_temp = p_right_temp[1]
    j       loop_merge_2
end_merge_2:    
    lw      $t5,            4($t4)                      # load p_right_temp[1] into $t5
    lw      $t6,            4($t1)                      # load p_left[1] into $t6
    sw      $t6,            4($t4)                      # p_right_temp[1] = p_left[1]
    sw      $t2,            4($t1)                      # p_left[1] = p_right
    move    $t1,            $t4                         # p_left = p_right_temp
    move    $t2,            $t5                         # p_right = temp_right_pointer_next
    beq     $t2,            $zero,          end_merge   # if p_right == NULL, goto end_merge
    j       loop_merge_1
end_merge_t:    
    sw      $t2,            4($t1)                      # p_left[1] = p_right
end_merge:      
    lw      $v0,            4($t0)                      # load head[1] into $v0
    lw      $ra,            16($sp)                     # restore $ra
    lw      $s0,            12($sp)                     # restore $s0
    lw      $s1,            8($sp)                      # restore $s1
    lw      $s2,            4($sp)                      # restore $s2
    lw      $s3,            0($sp)                      # restore $s3
    addi    $sp,            $sp,            20          # deallocate space
    jr      $ra                                         # return
