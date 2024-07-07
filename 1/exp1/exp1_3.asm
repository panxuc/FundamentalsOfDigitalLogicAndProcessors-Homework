.text
main:
    li      $v0,    5                   # syscall 5 (read integer)
    syscall                             # read n
    move    $s0,    $v0                 # save the input value n to $t0
    sll     $a0,    $v0,    2           # n * 4
    li      $v0,    9                   # syscall 9 (sbrk)
    syscall                             # allocate memory for n integers
    move    $s1,    $v0                 # save the address of the allocated memory to $t1
    li      $s2,    0                   # i = 0
LOOP_1:
    bge     $s2,    $s0,    END_LOOP_1  # if i >= n, go to END_LOOP_1
    sll     $a0,    $s2,    2           # i * 4
    add     $a0,    $s1,    $a0         # address of a[i]
    li      $v0,    5                   # syscall 5 (read integer)
    syscall                             # read a[i]
    sw      $v0,    0($a0)              # a[i] = v0
    addi    $s2,    $s2,    1           # i++
    j       LOOP_1
END_LOOP_1:
    li      $s2,    0                   # i = 0
    li      $s3,    0                   # t = 0
    srl     $s4,    $s0,    1           # n / 2
LOOP_2:
    bge     $s2,    $s4,    END_LOOP_2  # if i >= n / 2, go to END_LOOP_2
    sll     $t0,    $s2,    2           # i * 4
    add     $t0,    $s1,    $t0         # address of a[i]
    sub     $t1,    $s0,    $s2         # n - i
    subi    $t1,    $t1,    1           # n - i - 1
    sll     $t1,    $t1,    2           # (n - i - 1) * 4
    add     $t1,    $s1,    $t1         # address of a[n - i - 1]
    lw      $t2,    0($t0)              # $t2 = a[i]
    addi    $t2,    $t2,    1           # $t2 = a[i] + 1
    lw      $t3,    0($t1)              # $t3 = a[n - i - 1]
    addi    $t3,    $t3,    1           # $t3 = a[n - i - 1] + 1
    sw      $t3,    0($t0)              # a[i] = $t3
    sw      $t2,    0($t1)              # a[n - i - 1] = $t2
    addi    $s2,    $s2,    1           # i++
    j       LOOP_2
END_LOOP_2:
    li      $s2,    0                   # i = 0
LOOP_3:
    bge     $s2,    $s0,    END_LOOP_3  # if i >= n, go to END_LOOP_3
    sll     $a0,    $s2,    2           # i * 4
    add     $a0,    $s1,    $a0         # address of a[i]
    lw      $a0,    0($a0)              # a[i]
    li      $v0,    1                   # syscall 1 (print integer)
    syscall                             # print a[i]
    addi    $s2,    $s2,    1           # i++
    j       LOOP_3
END_LOOP_3:
    li      $v0,    10                  # syscall 10 (exit)
    syscall                             # exit