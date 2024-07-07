.data   
infile:     .asciiz "a.in"
outfile:    .asciiz "a.out"
buffer:     .space  8
.text   
main:       
    la      $a0,    infile          # load address of infile into $a0
    li      $a1,    0               # read mode
    li      $a2,    0               # no additional flags
    li      $v0,    13              # syscall 13 (open file)
    syscall                         # open infile
    move    $a0,    $v0             # move file descriptor to $a0
    la      $a1,    buffer          # load address of buffer into $a1
    li      $a2,    8               # read 8 bytes
    li      $v0,    14              # syscall 14 (read file)
    syscall                         # read infile
    li      $v0,    16              # syscall 16 (close file)
    syscall                         # close infile
    la      $a0,    outfile         # load address of outfile into $a0
    li      $a1,    1               # write mode
    li      $a2,    0               # no additional flags
    li      $v0,    13              # syscall 13 (open file)
    syscall                         # open outfile
    move    $a0,    $v0             # move file descriptor to $a0
    la      $a1,    buffer          # load address of buffer into $a1
    li      $a2,    8               # write 8 bytes
    li      $v0,    15              # syscall 15 (write file)
    syscall                         # write outfile
    li      $v0,    16              # syscall 16 (close file)
    syscall                         # close outfile
    li      $v0,    5               # syscall 5 (read integer)
    syscall                         # read i
    addi    $a0,    $v0,        10  # $a0 = $v0 + 10
    li      $v0,    1               # syscall 1 (print integer)
    syscall                         # print i
    li      $v0,    10              # syscall 10 (exit)
    syscall                         # exit