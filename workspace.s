.section .note.GNU-stack,"",@progbits
.data
    n: .long 5
    v: .long 10, 20, 30, 40, 50
.text
.global main
main:
    lea v, %edi
    mov n ,%ecx
etloop:
    mov n, %eax
    sub %ecx, %eax
    movl (%edi, %eax, 4), %edx
    loop etloop
etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

##Problema min dintre 3 nr
.section .note.GNU-stack,"",@progbits
.data
    x: .long 5
    y: .long 10
    z: .long 1
    min: .space 4
.text
.global main
main:
    movl x, %eax
    cmpl y, %eax
    jl xz

    movl y, %eax
    cmpl x, %eax
    jl yz

    movl z, %eax
    cmpl x, %eax
    jl zy

xz:
    cmpl z, %eax
    jl x_st
    cmpl z, %eax
    jg z_st

yz:
    cmpl z, %eax
    jl y_st
    cmpl z, %eax
    jg z_st

zy:
    cmpl y, %eax
    jl z_st
    cmpl y, %eax
    jg y_st

x_st:
    movl x, %eax
    movl %eax, min
    jmp exit
y_st:
    movl x, %eax
    movl %eax, min
    jmp exit

z_st:
    movl z, %eax
    movl %eax, min
    jmp exit

exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80


##Problema cu max unui nr in vector si aparitiile lui
.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    max: .long 0
    x: .space 4
    formatscanf: .asciz "%d"
    format_print: .asciz "max este %d si nr aparitii este %d\n"
.text
.global main
main:
citire:
    pushl $n
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx
    movl $1, %ebx
vect_loop:
// ebx e cnt aparitii
    cmpl n, %ecx
    je et_exit

    pushl %ecx
    pushl $x
    pushl $formatscanf
    call scanf
    popl %eax
    popl %eax
    popl %ecx

    movl x, %eax
    cmpl max, %eax
    je flag

    cmpl max, %eax
    jl flag2
    movl %eax, max
    movl $1, %ebx
    incl %ecx
    jmp vect_loop

flag:
    incl %ebx
    incl %ecx
    jmp vect_loop
flag2:
    incl %ecx
    jmp vect_loop
et_exit:
    pushl %ebx
    pushl max
    pushl $format_print
    call printf
    popl %eax
    popl %eax
    popl %eax

    movl $1, %eax
    movl $0, %ebx
    int $0x80

##Problema determinare div numar
.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    var: .long 0
    format_scanf: .asciz "%d"
    format_printf: .asciz "%d\n"
.text
.global main
main:
citire:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ecx
    popl %ecx

    movl $1, %ecx
et_loop:
    xorl %edx, %edx

    cmpl n, %ecx
    jg et_exit

    movl n, %eax
    idiv %ecx
    cmpl %edx, var
    je scriere

    addl $1, %ecx
    jmp et_loop
scriere:
    pushl %ecx
    pushl $format_printf
    call printf
    popl %eax
    popl %eax
    addl $1, %ecx
    jmp et_loop

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

##FIbonacci nerecursiv
.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    format_scanf: .asciz "%d"
    format_print: .asciz "%d\n"
    f1: .long 0
    f2: .long 1
.text
.global main
main:
    movl $0, %eax
    movl $1, %ecx
citire:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

et_loop:
    cmpl n, %ecx
    jge et_exit

    movl $0, %eax
    addl $1, %ecx
    addl f1, %eax
    addl f2, %eax
    movl f2, %ebx
    movl %ebx, f1
    movl %eax, f2
    jmp et_loop

et_exit:
    pushl f1
    pushl $format_print
    call printf
    pushl %eax
    pushl %eax

    movl $1, %eax
    movl $0, %ebx
    int $0x80

##Problema suma vector si ma 
.section .note.GNU-stack,"",@progbits
.data
    n: .long 6
    v: .long 14, 56, 76, 12, 1, 54
    ma: .space 4
.text
.global main
main:
    lea v, %edi
    xorl %ecx, %ecx
    xorl %ebx, %ebx

et_loop:
    cmpl %ecx, n
    je et_exit

    movl (%edi, %ecx, 4), %edx
    addl %edx, %ebx
    incl %ecx
    jmp et_loop

et_exit:
    xorl %edx, %edx
    movl %ebx, %eax
    idiv n
    movl %eax, ma 

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

## Problema cele mai mici elemente din vector cu o singura parcurgere
.section .note.GNU-stack,"",@progbits
.data 
    min1: .long 10000000
    min2: .long 10000000
    n: .space 4
    x: .space 4
    format_scanf: .asciz "%d"
    format_print: .asciz "Cele mai mici elemente din vector sunt %d si %d\n"
.text
.global main
main:
scan_n:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx

etloop:
    cmpl n, %ecx
    je et_exit

    pushl %ecx
    pushl $x
    pushl $format_scanf
    call scanf
    popl %eax
    popl %eax
    popl %ecx

    movl min2, %edx
    cmpl min1, %edx
    jg swap
cnt:
    movl min1, %edx
    cmpl x, %edx
    jg atr
    incl %ecx
    jmp etloop

swap:
    movl min2, %eax
    movl min1, %ebx
    movl %eax, min1
    movl %ebx, min2

    jmp cnt

atr:
    movl x, %eax
    movl %eax, min1
    incl %ecx
    jmp etloop

et_exit:
    pushl min2
    pushl min1
    pushl $format_print
    call printf
    popl %eax
    popl %eax
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

## Problema gasire element singular vector (for in for)
.section .note.GNU-stack,"",@progbits
.data 
    n: .long 7
    v: .long 1245, 342, 543523, 342, 4234, 1245, 543523
    cnt: .long 0
    val: .space 4
    format_print: .asciz "Elementul singular este %d\n"
.text
.global main
main:
    lea v, %edi
    xorl %ecx, %ecx

etloop1:
    cmpl n, %ecx
    je etexit

    movl (%edi, %ecx, 4), %edx
    xorl %eax, %eax
    movl $0, cnt
etloop2:
    cmpl n, %eax
    je cntl1

    movl (%edi, %eax, 4), %ebx
    cmpl %edx, %ebx
    je ad
cntl2:
    incl %eax
    jmp etloop2

cntl1:
    cmpl $1, cnt
    je atr
    incl %ecx
    jmp etloop1

ad: 
    incl cnt
    jmp cntl2

atr:
    movl %edx, val

etexit:
    pushl val
    pushl $format_print
    call printf
    popl %eax
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

##Suma cifrelor unui numar cu functii
.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    sum: .long 0
    format_scanf: .asciz "%d"
    format_print: .asciz "Suma cifelor numarului %d este %d\n"
.text

sumcif:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
etloop:
    movl $0, %ebx
    cmpl %eax, %ebx
    je sumcif_ret

    xorl %edx, %edx
    movl $10, %ebx
    divl %ebx
    addl %edx, sum
    jmp etloop

sumcif_ret:
    popl %ebp
    ret

.global main
main:
citire: 
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

program:
    pushl n
    call sumcif
    popl %ebx

etexit:
    pushl sum
    pushl n
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

    movl $1, %eax
    movl $0 ,%ebx
    int $0x80
