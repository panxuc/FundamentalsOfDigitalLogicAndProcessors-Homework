.text
main:
    li      $v0,    5               # syscall 5 (read integer)
    syscall                         # read n
    move    $a0,    $v0             # save n to $a0
    jal     Hanoi
    li      $v0,    1               # syscall 1 (print integer)
    syscall                         # print return value
    li      $v0,    10              # syscall 10 (exit)
    syscall                         # exit

Hanoi:
    addi    $sp,    $sp,    -4      # allocate space for return value
    sw      $ra,    0($sp)          # save return address
    beq     $a0,    1,      base    # if n == 1, goto base
    addi    $a0,    $a0,    -1      # n = n - 1
    jal     Hanoi                   # Hanoi(n - 1)
    sll     $a0,    $a0,    1       # n = n * 2
    addi    $a0,    $a0,    1       # n = n + 1
base:
    lw      $ra,    0($sp)          # restore return address
    addi    $sp,    $sp,    4       # deallocate space for return value
    jr      $ra                     # return
