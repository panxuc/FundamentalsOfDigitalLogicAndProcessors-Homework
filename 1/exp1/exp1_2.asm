.text
main:
    li      $v0,    5               # syscall 5 (read integer)
    syscall                         # read i
    move    $t1,    $v0             # save the input value i to $t1
    li      $v0,    5               # syscall 5 (read integer)
    syscall                         # read j
    move    $t2,    $v0             # save the input value j to $t2
    sub     $t1,    $zero,  $t1     # i = -i
    slt     $t3,    $t2,    $zero   # if(j < 0)
    beq     $t3,    $zero,  ELSE    # if not, go to ELSE
    sub     $t2,    $zero,  $t2     # j = -j
ELSE:
    li      $t0,    0               # temp = 0
LOOP:
    bge     $t0,    $t2,    END     # if temp >= j, go to END
    addi    $t1,    $t1,    1       # i += 1
    addi    $t0,    $t0,    1       # temp += 1
    j       LOOP                    # go to LOOP
END:
    li      $v0,    1               # syscall 1 (print integer)
    move    $a0,    $t1             # move i to $a0
    syscall                         # print i
    li      $v0,    10              # syscall 10 (exit)
    syscall                         # exit
